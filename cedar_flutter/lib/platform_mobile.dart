// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Mobile impl for platform-specific functions.

import 'dart:async';
import 'dart:io';

import 'package:cedar_flutter/platform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dart_ping/dart_ping.dart';
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
bool _connecting = false;
DateTime? _startTime;
// Only request to turn on Bluetooth once while it is off
bool _requestedBtOn = false;

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
);

void rpcSucceededImpl() {}
void rpcFailedImpl() {
  if (!_connecting || DateTime.now().difference(_startTime!).inSeconds > 5) {
    cleanupImpl();
  }
}

CedarClient getClientImpl() {
  if (_client != null) {
    return _client!;
  }

  if (isAndroidImpl() && _activeDevice.name != null) {
    _connecting = true;
    _startTime = DateTime.now();
    _activeProxy?.stop();
    _bluetoothConnection?.dispose();

    // Fixed port for local proxy allows immediate synchronous return
    const int kLocalProxyPort = 50055;

    // Start proxy and connection in the background
    _establishBluetoothConnection(_activeDevice.address, kLocalProxyPort);

    final channel = ClientChannel(
      InternetAddress.loopbackIPv4.address,
      port: kLocalProxyPort,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );
    _client = CedarClient(channel);
    return _client!;
  }

  // Fallback for non-Android platforms or explicit WiFi usage
  _channel?.shutdown();
  _channel = ClientChannel(_activeDevice.address, port: 80, options: _options);
  _client = CedarClient(_channel!);
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

Future<bool> checkNetworkConnectivityImpl(String host) async {
  try {
    // On iOS, dart_ping doesn't work. Use socket connection test instead.
    if (Platform.isIOS) {
      // Try to connect to port 80 as a connectivity test
      final socket =
          await Socket.connect(host, 80, timeout: Duration(seconds: 3));
      socket.destroy();
      return true;
    } else {
      // Use ping on Android and other platforms
      final ping = Ping(host, count: 1);

      await for (final response in ping.stream) {
        // If we get any response, the host is reachable
        if (response.response != null) {
          return true;
        }
        break; // We only need the first response
      }
      return false;
    }
  } catch (e) {
    debugPrint('Network connectivity check failed: $e');
    return false;
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

void cleanupImpl() {
  _client = null;
  _channel?.shutdown();
  _activeProxy?.stop();
  _bluetoothConnection?.close();
  _bluetoothConnection?.dispose();
  _channel = null;
  _activeProxy = null;
  _bluetoothConnection = null;
  _connecting = false;
  _startTime = null;
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
      print('Error getting Bluetooth devices: $e');
      return [];
    }
  }
  throw UnimplementedError('Bluetooth not implemented on iOS');
}

void setActiveDeviceImpl(CedarDevice device) {
  if (Platform.isAndroid) {
    _activeDevice = device;
    cleanupImpl();
  } else {
    throw UnimplementedError("No implementation for iOS");
  }
}

Future<void> _establishBluetoothConnection(String addr, int localPort) async {
  try {
    if (await _checkBluetoothPermissions() == false) {
      print('Bluetooth permissions denied, cannot connect');
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
      print('Attempting to turn on Bluetooth');
      flutterBlue.turnOn();
      try {
        await flutterBlue.adapterState
            .timeout(Duration(seconds: 5))
            .firstWhere((s) => s == BluetoothAdapterState.on);
      } on TimeoutException catch (_) {
        print('Timed out waiting for Bluetooth to turn on');
        // Connecting state will be cleaned up upon next rpcFailed()
        return;
      }
    }
    _requestedBtOn = false;

    print('Attempting to connect to $addr ...');

    _bluetoothConnection = await flutterBlue.connect(addr, uuid: _btUuid);

    if (_bluetoothConnection!.isConnected) {
      print('Bluetooth Connected. Starting Proxy on port $localPort...');
      _activeProxy = BluetoothGrpcProxy(_bluetoothConnection!);
      await _activeProxy!.start(port: localPort);
      print('Proxy is ready and forwarding traffic.');
    }
  } catch (e) {
    print('Error establishing Bluetooth connection: $e');
    cleanupImpl();
  }
  _connecting = false;
  _startTime = null;
}

Future<bool> _checkBluetoothPermissions() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Checking permissions on SDK ${androidInfo.version.sdkInt}');
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
      return await Permission.bluetooth.request().isGranted;
    }
  }
  return false;
}
