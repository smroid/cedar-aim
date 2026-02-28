// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Mobile impl for platform-specific functions.

import 'dart:async';
import 'dart:io';

import 'package:cedar_flutter/platform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Imports for Bluetooth control functionality
import 'package:cedar_flutter/bluetooth_proxy.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';

bool isWebImpl() {
  return false;
}

bool isAndroidImpl() {
  return Platform.isAndroid;
}

bool isIOSImpl() {
  return Platform.isIOS;
}

// UUID for Cedar control channel defined in cedar-server
String _btUuid = "4e5d4c88-2965-423f-9111-28a506720760";

String _wifiAddress = isMobile() ? "192.168.4.1" : "192.168.1.158";
CedarDevice _activeDevice = CedarDevice(address: _wifiAddress);
ClientChannel? _channel;
cedar_rpc.CedarClient? _client;
BluetoothGrpcProxy? _activeProxy;
BluetoothConnection? _bluetoothConnection;
int? _activeProxyPort; // Port assigned by OS when using port 0.
// Only request to turn on Bluetooth once while it is off
bool _requestedBtOn = false;

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
);

void rpcSucceededImpl() {}
void rpcFailedImpl() {
  // On RPC failure, just clear the client so next getClientImpl() will create
  // a fresh one. Don't call cleanupImpl() here - it can race with device
  // selection which also calls cleanup.
  _client = null;
}

// Track if we've loaded the selected device from SharedPreferences.
bool _deviceLoaded = false;

Future<CedarClient> getClientImpl() async {
  // On first call, load persisted device selection.
  if (!_deviceLoaded) {
    _deviceLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    final deviceName = prefs.getString('selected_device_name');
    final deviceAddress = prefs.getString('selected_device_address');
    if (deviceAddress != null) {
      debugPrint('Loaded device addr $deviceAddress name $deviceName');
      final device = CedarDevice(address: deviceAddress, name: deviceName);
      await setActiveDeviceImpl(device);
    }
  }

  // Always try WiFi first if we don't have a client.
  if (_client == null) {
    await _channel?.shutdown();
    _channel = null;
    _activeProxy = null;
    _activeProxyPort = null;
    _channel = ClientChannel(_wifiAddress, port: 80, options: _options);
    _client = CedarClient(_channel!);

    // Test the WiFi connection before returning.
    try {
      await _client!
          .getBluetoothName(cedar_rpc.EmptyMessage(),
              options: CallOptions(
                timeout: const Duration(seconds: 5),
              ))
          .timeout(const Duration(seconds: 7), onTimeout: () {
        throw TimeoutException('WiFi connection test timed out');
      });
      debugPrint('WiFi connection test succeeded');
      // Update active device to reflect WiFi usage.
      if (isAndroidImpl()) {
        _activeDevice = CedarDevice(address: _wifiAddress);
      }
      return _client!;
    } catch (e) {
      _client = null;
      await _channel?.shutdown();
      _channel = null;
      if (!isAndroidImpl() || _activeDevice.name == null) {
        // No Bluetooth fallback available, rethrow the error.
        debugPrint('WiFi connection test failed: $e');
        rethrow;
      }
    }
  }

  // For Android with Bluetooth device, establish or check connection.
  if (isAndroidImpl() && _activeDevice.name != null) {
    if (_bluetoothConnection?.isConnected == true) {
      return _client!;
    }
    if (_activeProxyPort == null) {
      await _establishBluetoothConnection(_activeDevice.address);
    }
    await _channel?.shutdown();
    _channel = ClientChannel(
      InternetAddress.loopbackIPv4.address,
      port: _activeProxyPort!,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = CedarClient(_channel!);
  }

  return _client!;
}

void goFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  } catch (e) {
    debugPrint('Could not enter full screen with setEnabledSystemUIMode: $e');
  }
}

void cancelFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  } catch (e) {
    debugPrint('Could not exit full screen with setEnabledSystemUIMode: $e');
  }
}

void setWakeLockImpl(bool locked) {
  WakelockPlus.toggle(enable: locked);
}

Future<bool> getWakeLockImpl() async {
  return await WakelockPlus.enabled;
}

bool evaluatedCanGetLocation = false;
bool canGetLocation = false;

Future<bool> canGetLocationImpl() async {
  if (evaluatedCanGetLocation) {
    return canGetLocation;
  }
  canGetLocation = await _canGetLocationImpl();
  evaluatedCanGetLocation = true;
  return canGetLocation;
}

Future<bool> _canGetLocationImpl() async {
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint("Location services not enabled");
    return false;
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Location permissions are denied");
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    debugPrint("Location permissions are denied forever");
    return false;
  }
  return true;
}

Future<Position?> getLocationImpl() async {
  if (!await canGetLocationImpl()) {
    return null;
  }
  return await Geolocator.getLastKnownPosition();
}

bool canExitAppImpl() {
  return !Platform.isIOS;
}

void exitAppImpl() {
  if (Platform.isIOS) {
    // On iOS, apps cannot exit themselves per Apple guidelines.
    // Users should use the home button to exit the app.
  } else {
    SystemNavigator.pop();
  }
}

Future<bool> isAppUpdateAvailableImpl() async {
  try {
    final info = await InAppUpdate.checkForUpdate();
    return info.updateAvailability == UpdateAvailability.updateAvailable;
  } catch (e) {
    debugPrint('Error checking for app update: $e');
    return false;
  }
}

Future<void> startAppUpdateImpl() async {
  try {
    if (Platform.isAndroid) {
      // On Android, use the native in-app update API.
      // Must call checkForUpdate first before performImmediateUpdate.
      await InAppUpdate.checkForUpdate();
      await InAppUpdate.performImmediateUpdate();
    } else if (Platform.isIOS) {
      // On iOS, open the App Store.
      final appStoreUrl = 'https://apps.apple.com/app/cedar-aim/id6740513717';
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(
          Uri.parse(appStoreUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  } catch (e) {
    debugPrint('Error starting app update: $e');
  }
}

Future<void> cleanupImpl() async {
  _client = null;
  await _channel?.shutdown();
  await _activeProxy?.stop();
  await _bluetoothConnection?.close();
  _bluetoothConnection?.dispose();
  _channel = null;
  _activeProxy = null;
  _activeProxyPort = null;
  _bluetoothConnection = null;
}

Future<List<CedarDevice>> getBluetoothDevicesImpl() async {
  if (Platform.isAndroid) {
    try {
      final flutterBlueClassic = FlutterBlueClassic();
      final bondedDevices = await flutterBlueClassic.bondedDevices;
      if (bondedDevices == null) {
        return [];
      }

      return bondedDevices.map((d) {
        String displayName;
        if (d.alias != null && d.alias!.isNotEmpty) {
          displayName = d.alias!;
        } else if (d.name != null && d.name!.isNotEmpty) {
          displayName = d.name!;
        } else {
          displayName = d.address;
        }

        return CedarDevice(address: d.address, name: displayName);
      }).toList();
    } catch (e) {
      debugPrint('Error getting Bluetooth devices: $e');
      return [];
    }
  }
  throw UnimplementedError('Bluetooth not implemented on iOS');
}

Future<void> setActiveDeviceImpl(CedarDevice device) async {
  if (Platform.isAndroid) {
    _activeDevice = device;

    // Clean up any existing connection.
    await cleanupImpl();

    // Persist device selection for next app launch.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_device_address', device.address);
    if (device.name == null) {
      // WiFi device - just remove the BT device name.
      await prefs.remove('selected_device_name');
    } else {
      // Bluetooth device - persist the name. Connection will be established
      // on the next getClientImpl() call.
      await prefs.setString('selected_device_name', device.name!);
    }
  } else {
    throw UnimplementedError("No implementation for iOS");
  }
}

Future<void> _establishBluetoothConnection(String addr) async {
  try {
    // Ensure any previous connection is fully cleaned up before starting a new
    // one.
    if (_activeProxy != null) {
      try {
        await _activeProxy!.stop().timeout(const Duration(seconds: 2));
      } catch (e) {
        debugPrint('Timeout or error stopping proxy: $e');
      }
      _activeProxy = null;
    }
    _activeProxyPort = null;
    _bluetoothConnection?.dispose();
    _bluetoothConnection = null;

    if (await _checkBluetoothPermissions() == false) {
      debugPrint('Bluetooth permissions denied, cannot connect');
      // Maintain connecting state here to avoid polling too frequently
      return;
    }

    final flutterBlue = FlutterBlueClassic(usesFineLocation: true);
    BluetoothAdapterState state = await flutterBlue.adapterStateNow;
    if (state != BluetoothAdapterState.on) {
      if (_requestedBtOn) {
        return;
      }
      _requestedBtOn = true;
      debugPrint('Attempting to turn on Bluetooth');
      flutterBlue.turnOn();
      try {
        await flutterBlue.adapterState
            .timeout(Duration(seconds: 5))
            .firstWhere((s) => s == BluetoothAdapterState.on);
      } on TimeoutException catch (_) {
        debugPrint('Timed out waiting for Bluetooth to turn on');
        // Connecting state will be cleaned up upon next rpcFailed()
        return;
      }
    }
    _requestedBtOn = false;

    _bluetoothConnection = await flutterBlue
        .connect(addr, uuid: _btUuid)
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException('Bluetooth connection timed out');
    });

    if (_bluetoothConnection!.isConnected) {
      debugPrint(
          'Bluetooth Connected. Starting Proxy with OS-assigned port...');
      _activeProxy = BluetoothGrpcProxy(_bluetoothConnection!);
      // Use port 0 to let OS assign an available port.
      try {
        _activeProxyPort = await _activeProxy!.start(port: 0)
            .timeout(const Duration(seconds: 3), onTimeout: () {
          throw TimeoutException('Proxy startup timed out');
        });
      } catch (e) {
        debugPrint('Error starting proxy: $e');
        _activeProxy = null;
        rethrow;
      }
      debugPrint('Proxy is ready on port $_activeProxyPort');
      // Give proxy a moment to stabilize before attempting gRPC calls.
      await Future.delayed(Duration(milliseconds: 100));
      // Clear client so next getClientImpl() uses the new port.
      _client = null;
    }
  } catch (e) {
    debugPrint('Error establishing Bluetooth connection: $e');
    await cleanupImpl();
    rethrow;
  }
}

Future<bool> _checkBluetoothPermissions() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt > 30) {
      // On Android 12+ (API 31+), we need BLUETOOTH_CONNECT and BLUETOOTH_SCAN
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();

      if (statuses[Permission.bluetoothConnect]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted) {
        return true;
      }
    } else {
      // On Android 11 and below, request BLUETOOTH permission
      // (manifest also declares BLUETOOTH_ADMIN which is granted together)
      return await Permission.bluetooth.request().isGranted;
    }
  }
  return false;
}
