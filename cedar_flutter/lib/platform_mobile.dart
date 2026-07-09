// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
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

const _networkChannel = MethodChannel('cedar/network');

// UUID for Cedar control channel defined in cedar-server
String _btUuid = "4e5d4c88-2965-423f-9111-28a506720760";

String _wifiAddress = "cedar.local";
CedarDevice _activeDevice = CedarDevice(address: _wifiAddress);

String wifiDeviceAddressImpl() => _wifiAddress;
ClientChannel? _channel;
cedar_rpc.CedarClient? _client;
BluetoothGrpcProxy? _activeProxy;
BluetoothConnection? _bluetoothConnection;
int? _activeProxyPort; // Port assigned by OS when using port 0.

// Only request to turn on Bluetooth once while it is off.
bool _requestedBtOn = false;

// Consecutive BT reconnect failures since last successful frame.
int _btReconnectFailures = 0;

// True when we detect the target BT device is no longer bonded (e.g. the user
// unpaired it from Android Bluetooth settings).
bool _btTargetUnbonded = false;

// True when the user has selected a BT device. Persists for the life of the
// BT session — cleared only when the user explicitly selects a WiFi device.
// We never auto-fall-back to WiFi: when BT is in use the server might turn its
// WiFi off, so there is no WiFi endpoint to fall back to.
bool _btDeviceSelected = false;

// Single-flight guard: the in-flight reconnect future, if any. Ensures only
// one connect attempt (one RFCOMM page) is ever outstanding.
Future<void>? _btReconnectInFlight;

// Time of the last actual connect attempt, used to enforce the cooldown below.
DateTime? _lastBtAttemptTime;

// Cooldown between reconnect attempts after a failure. Observed behavior: after
// an unclean BT drop the stale link self-heals in ~22s, and re-paging before
// then not only fails but risks wedging the link. So after a failed attempt we
// stay quiet (no paging) until this much time has elapsed, landing the next
// attempt right around when the link clears. The FIRST attempt after a drop is
// not gated (a clean disconnect can reconnect immediately). One phone's data —
// tune as we gather more.
const Duration _btReconnectCooldown = Duration(seconds: 25);

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
  // No max connection age needed on a local network; suppress periodic GOAWAY.
  connectionTimeout: Duration(days: 365),
);

bool _boundToWifi = false;

// Cached result of the cedar.local DNS lookup.
String? _resolvedCedarHost;

/// Resolves 'cedar.local', caching the result. Falls back to 192.168.4.1
/// if mDNS fails. Subsequent calls return the cached result immediately.
Future<String> resolveCedarHostImpl() async {
  if (_resolvedCedarHost != null) {
    return _resolvedCedarHost!;
  }
  try {
    final result = await InternetAddress.lookup('cedar.local')
        .timeout(const Duration(seconds: 10));
    if (result.isEmpty) {
      throw SocketException('Could not resolve cedar.local');
    }
    debugPrint('DNS lookup for cedar.local succeeded: ${result.first.address}');
    _resolvedCedarHost = 'cedar.local';
  } catch (e) {
    debugPrint('DNS lookup for cedar.local failed: $e');
    _resolvedCedarHost = '192.168.4.1';
    debugPrint('Using fallback IP address: $_resolvedCedarHost');
  }
  return _resolvedCedarHost!;
}

int btReconnectFailuresImpl() => _btReconnectFailures;
bool isBluetoothInUseImpl() => _btDeviceSelected;
bool btTargetUnbondedImpl() => _btTargetUnbonded;

void rpcSucceededImpl() {
  if (_btReconnectFailures > 0) {
    debugPrint('BT rpcSucceeded: resetting failure count from $_btReconnectFailures');
    _btReconnectFailures = 0;
  }
  _btTargetUnbonded = false;
  if (Platform.isAndroid && !_boundToWifi && _activeDevice.name == null) {
    _networkChannel.invokeMethod<bool>('bindToWifi').then((bound) {
      if (bound == true) {
        _boundToWifi = true;
        debugPrint('bindToWifi: bound to WiFi network');
      }
    }).catchError((e) {
      debugPrint('bindToWifi error: $e');
    });
  }
}

// Tears down the BT connection and proxy so the next getClientImpl() call
// re-establishes from scratch. Fire-and-forget; safe to call from sync context.
void btTeardownImpl() {
  if (!_btDeviceSelected) {
    return;
  }
  debugPrint('BT teardown: closing connection and proxy');
  _client = null;
  _activeProxyPort = null;
  final proxy = _activeProxy;
  _activeProxy = null;
  final conn = _bluetoothConnection;
  _bluetoothConnection = null;
  proxy?.stop().catchError((e) => debugPrint('btTeardown proxy stop error: $e'));
  conn?.close();
  conn?.dispose();
}

void rpcFailedImpl() {
  // On RPC failure, just clear the client so next getClientImpl() will create
  // a fresh one. Don't call cleanupImpl() here - it can race with device
  // selection which also calls cleanup.
  _client = null;
  // Invalidate cached DNS so the next connection attempt re-resolves
  // cedar.local — the device may have switched to a different WiFi network
  // where Hopper is at a different IP.
  _resolvedCedarHost = null;
  // Unbind from the network so that on reconnect we rebind to the (possibly
  // new) network handle. Without this, returning to Hopper's WiFi after a
  // disconnect fails with "Machine is not on the network".
  if (Platform.isAndroid && _boundToWifi) {
    _boundToWifi = false;
    _networkChannel.invokeMethod('unbindNetwork').catchError((e) {
      debugPrint('unbindNetwork error: $e');
    });
  }
}

/// Aggressively cleans up the gRPC channel, with timeout and forced terminate.
Future<void> _shutdownChannel({int timeoutSeconds = 2}) async {
  final channel = _channel;
  if (channel == null) {
    return;
  }
  _channel = null;
  try {
    await channel.shutdown().timeout(
      Duration(seconds: timeoutSeconds),
      onTimeout: () {
        debugPrint('Channel shutdown timed out, forcing terminate');
      },
    );
  } catch (e) {
    debugPrint('Error during channel shutdown: $e');
  }
  try {
    await channel.terminate();
  } catch (e) {
    debugPrint('Error during channel terminate: $e');
  }
  // Brief pause to let OS release socket resources.
  await Future.delayed(const Duration(milliseconds: 100));
}

// Track if we've loaded the selected device from SharedPreferences.
bool _deviceLoaded = false;

// Call early (e.g. from initState) to set _btDeviceSelected before the first
// build() runs, so the connection dialog gate works correctly from the start.
Future<void> preloadDeviceSelectionImpl() async {
  if (_deviceLoaded) return;
  final prefs = await SharedPreferences.getInstance();
  final deviceName = prefs.getString('selected_device_name');
  _btDeviceSelected = deviceName != null;
}

// Returns true if the target device is still bonded, or if the check itself
// fails or times out — a flaky bond-state query shouldn't block reconnection.
// Returns false only when the device is confirmed unbonded.
Future<bool> _isTargetDeviceBonded(String address) async {
  try {
    final bondedDevices = await FlutterBlueClassic()
        .bondedDevices
        .timeout(const Duration(seconds: 3), onTimeout: () => null);
    if (bondedDevices == null) {
      return true;
    }
    return bondedDevices.any((d) =>
        d.address == address && d.bondState == BluetoothBondState.bonded);
  } catch (e) {
    debugPrint('Error checking bond state for $address: $e');
    return true;
  }
}

// Performs at most one BT connect attempt, honoring the reconnect cooldown.
// On the first attempt after a drop (failures == 0) it connects immediately.
// After a failure it stays quiet until _btReconnectCooldown has elapsed since
// the last attempt, so we don't re-page while the stale link is self-healing.
// On success sets up _activeProxyPort; on failure or while cooling down leaves
// _activeProxyPort null so the caller treats BT as not-yet-ready and retries.
Future<void> _reconnectBluetooth() async {
  if (_btReconnectFailures > 0 && _lastBtAttemptTime != null) {
    final since = DateTime.now().difference(_lastBtAttemptTime!);
    final remaining = _btReconnectCooldown - since;
    if (remaining > Duration.zero) {
      // Cooling down — leave the link alone. Caller will try again later.
      return;
    }
  }
  _lastBtAttemptTime = DateTime.now();

  if (!await _isTargetDeviceBonded(_activeDevice.address)) {
    // Unbonded is a permanent condition until the user re-pairs — waiting
    // out the cooldown won't help. Count it as a real failed attempt (keeps
    // the failure counter/log honest) but set the fast-path flag so the
    // dialog gate doesn't need to wait for the full failure threshold.
    _btReconnectFailures++;
    _btTargetUnbonded = true;
    debugPrint('BT reconnect: ${_activeDevice.address} is no longer bonded '
        '(consecutive failures: $_btReconnectFailures)');
    return;
  }

  try {
    await _establishBluetoothConnection(_activeDevice.address);
    if (_btReconnectFailures > 0) {
      debugPrint('BT reconnect succeeded after $_btReconnectFailures failure(s)');
    }
    _btReconnectFailures = 0;
  } catch (e) {
    _btReconnectFailures++;
    debugPrint('BT reconnect failed (consecutive failures: $_btReconnectFailures): $e');
    // No inline delay: the cooldown is enforced by time-gating the next
    // attempt, which keeps the link quiet rather than re-paging immediately.
  }
}

Future<CedarClient> getClientImpl() async {
  // On first call, load persisted device selection.
  if (!_deviceLoaded) {
    _deviceLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    final deviceName = prefs.getString('selected_device_name');
    final deviceAddress = prefs.getString('selected_device_address');
    if (deviceAddress != null) {
      debugPrint('Loaded device addr $deviceAddress name $deviceName');
      _btDeviceSelected = deviceName != null;
      final device = CedarDevice(address: deviceAddress, name: deviceName);
      await setActiveDeviceImpl(device);
    }
  }

  // For Android with a Bluetooth device, establish or check the connection.
  // We never fall back to WiFi here: when BT is in use the server might turn
  // its WiFi off, so there is no WiFi endpoint. On a drop we patiently
  // reconnect over BT (see _reconnectBluetooth).
  //
  // NOTE: gate on the BT link's health, NOT on `_client`. When the *remote*
  // closes the link (onDisconnected by remote), the proxy tears itself down
  // and the local proxy port becomes dead, but `_client` is left non-null.
  // If we trusted a non-null `_client` we'd hand back a client pointing at a
  // dead 127.0.0.1 port, and every RPC would fail with "Connection refused"
  // forever with nothing driving a reconnect. So a non-null `_client` is only
  // valid while the underlying BT link is actually connected.
  if (isAndroidImpl() && _activeDevice.name != null) {
    final btAlive = _bluetoothConnection?.isConnected == true;
    if (btAlive && _client != null) {
      // Live link and a valid client — reuse it.
      return _client!;
    }
    if (!btAlive) {
      // Link is down (never connected, we tore it down, or the remote closed
      // it). Drop any stale client/channel and reconnect via a single-flight
      // attempt so only one RFCOMM page is ever outstanding — parallel pages
      // churn/wedge the link. If a reconnect is already running, await it
      // rather than starting a new one.
      _client = null;
      _btReconnectInFlight ??= _reconnectBluetooth();
      final inFlight = _btReconnectInFlight!;
      try {
        await inFlight;
      } finally {
        // Only the starter clears the guard (identity check guards against a
        // newer attempt that may have been started in the meantime).
        if (identical(_btReconnectInFlight, inFlight)) {
          _btReconnectInFlight = null;
        }
      }
    }
    // If we now have a live link with a proxy port, (re)build the client.
    if (_bluetoothConnection?.isConnected == true && _activeProxyPort != null) {
      await _channel?.shutdown();
      _channel = ClientChannel(
        InternetAddress.loopbackIPv4.address,
        port: _activeProxyPort!,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );
      _client = CedarClient(_channel!);
      return _client!;
    }
    // Not connected yet (still cooling down, or attempt failed). Signal the
    // caller that BT isn't ready; the poll loop will call us again. Do NOT
    // fall through to the WiFi probe below.
    throw const BluetoothReconnectingException();
  }

  // Try WiFi if we don't have a client (no BT device selected, or BT fell back).
  if (_client == null && (!isAndroidImpl() || _activeDevice.name == null)) {
    await _shutdownChannel();
    _activeProxy = null;
    _activeProxyPort = null;

    // Resolve cedar.local, using cached result if available.
    final addressToTry = await resolveCedarHostImpl();

    _channel = ClientChannel(addressToTry, port: 80, options: _options);
    _client = CedarClient(_channel!);

    // Test the WiFi connection before returning. Use getFrame() since it's
    // been available in all server versions (unlike newer RPCs).
    try {
      final request = cedar_rpc.FrameRequest()
        ..nonBlocking = true;
      await _client!
          .getFrame(request,
              options: CallOptions(
                timeout: const Duration(seconds: 5),
              ))
          .timeout(const Duration(seconds: 7), onTimeout: () {
        throw TimeoutException('WiFi connection test timed out connecting to $addressToTry:80');
      });
      debugPrint('WiFi connection test succeeded');
      // Update active device to reflect WiFi usage.
      if (isAndroidImpl()) {
        _activeDevice = CedarDevice(address: addressToTry);
      }
      return _client!;
    } catch (e) {
      _client = null;
      await _shutdownChannel(timeoutSeconds: 1);
      // No Bluetooth fallback available, rethrow the error with context.
      debugPrint('WiFi connection test failed connecting to $addressToTry:80: $e');
      throw Exception('Failed to connect to Cedar ($addressToTry:80): $e');
    }
  }

  if (_client == null) {
    throw Exception('No client available');
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
  await _shutdownChannel();
  await _activeProxy?.stop();
  await _bluetoothConnection?.close();
  _bluetoothConnection?.dispose();
  _activeProxy = null;
  _activeProxyPort = null;
  _bluetoothConnection = null;
  if (Platform.isAndroid) {
    _boundToWifi = false;
    try {
      await _networkChannel.invokeMethod('unbindNetwork');
      debugPrint('unbindNetwork: unbound from WiFi network');
    } catch (e) {
      debugPrint('unbindNetwork error: $e');
    }
  }
}

Future<List<CedarDevice>> getBluetoothDevicesImpl() async {
  if (Platform.isAndroid) {
    try {
      final flutterBlueClassic = FlutterBlueClassic();
      final bondedDevices = await flutterBlueClassic.bondedDevices
          .timeout(const Duration(seconds: 3), onTimeout: () => []);
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
    _btDeviceSelected = device.name != null;
    _btReconnectFailures = 0;
    _btTargetUnbonded = false;

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
