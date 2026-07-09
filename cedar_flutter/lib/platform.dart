// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// Functions that have platform-specific implementations.

import 'platform_none.dart'
    if (dart.library.io) 'platform_mobile.dart'
    if (dart.library.html) 'platform_web.dart';

class CedarDevice {
  final String address; // IP or MAC address
  final String? name; // null for WiFi

  CedarDevice({required this.address, this.name});
}

/// Thrown by getClient() when a Bluetooth reconnect is in progress (either an
/// attempt is running or we're in the quiet cooldown between attempts). This is
/// an expected, transient state — not an error. Callers should treat it as
/// "not ready yet, back off and retry" without logging it as an RPC failure or
/// recycling the gRPC channel.
class BluetoothReconnectingException implements Exception {
  const BluetoothReconnectingException();
  @override
  String toString() => 'Bluetooth not connected (reconnecting)';
}

bool isWeb() {
  return isWebImpl();
}

bool isAndroid() {
  return isAndroidImpl();
}

bool isIOS() {
  return isIOSImpl();
}

bool isMobile() {
  return isAndroid() || isIOS();
}

void rpcSucceeded() {
  try {
    rpcSucceededImpl();
  } catch (e) {
    debugPrint('rpcSucceeded: $e');
  }
}

void rpcFailed() {
  try {
    rpcFailedImpl();
  } catch (e) {
    debugPrint('rpcFailed: $e');
  }
}

Future<CedarClient> getClient() async {
  try {
    return await getClientImpl();
  } on BluetoothReconnectingException {
    // Expected transient state; caller handles it quietly. Don't log.
    rethrow;
  } catch (e) {
    debugPrint('getClient: $e');
    rethrow;
  }
}

void goFullScreen() {
  try {
    goFullScreenImpl();
  } catch (e) {
    debugPrint('goFullScreen: $e');
  }
}

void cancelFullScreen() {
  try {
    cancelFullScreenImpl();
  } catch (e) {
    debugPrint('cancelFullScreen: $e');
  }
}

void setWakeLock(bool locked) {
  try {
    setWakeLockImpl(locked);
  } catch (e) {
    debugPrint('setWakeLock: $e');
  }
}

Future<bool> getWakeLock() async {
  try {
    return getWakeLockImpl();
  } catch (e) {
    debugPrint('rpcFailed: $e');
    return false;
  }
}

Future<bool> canGetLocation() async {
  return canGetLocationImpl();
}

Future<Position?> getLocation() async {
  try {
    return getLocationImpl();
  } catch (e) {
    debugPrint('getLocation: $e');
    rethrow;
  }
}

bool canExitApp() {
  try {
    return canExitAppImpl();
  } catch (e) {
    debugPrint('canExitApp: $e');
    return false;
  }
}

void exitApp() {
  try {
    return exitAppImpl();
  } catch (e) {
    debugPrint('exitApp: $e');
    rethrow;
  }
}


/// Check if an app update is available on the app store.
/// Returns true if an update is available, false if on latest version or check fails.
Future<bool> isAppUpdateAvailable() async {
  try {
    return await isAppUpdateAvailableImpl();
  } catch (e) {
    debugPrint('isAppUpdateAvailable: $e');
    return false;
  }
}

/// Initiate the app update flow. On Android, shows the system update UI.
/// On iOS, opens the App Store. Does nothing if no update is available.
Future<void> startAppUpdate() async {
  try {
    await startAppUpdateImpl();
  } catch (e) {
    debugPrint('startAppUpdate: $e');
  }
}

int btReconnectFailures() => btReconnectFailuresImpl();
bool isBluetoothInUse() => isBluetoothInUseImpl();
void btTeardown() => btTeardownImpl();

// True once we detect the currently-selected BT device is no longer bonded
// (e.g. unpaired from Android Bluetooth settings).
bool btTargetUnbonded() => btTargetUnbondedImpl();

/// Loads the persisted device selection early (call from initState) so
/// isBluetoothInUse() is correct before the first build().
Future<void> preloadDeviceSelection() async {
  await preloadDeviceSelectionImpl();
}

Future<void> cleanup() async {
  await cleanupImpl();
}

Future<List<CedarDevice>> getBluetoothDevices() async {
  try {
    return await getBluetoothDevicesImpl();
  } catch (e) {
    debugPrint('getBluetoothDevices: $e');
    return [];
  }
}

Future<void> setActiveDevice(CedarDevice device) async {
  await setActiveDeviceImpl(device);
}

/// Resolves 'cedar.local', caching the result. Falls back to 192.168.4.1
/// if mDNS fails. Subsequent calls return the cached result immediately.
Future<String> resolveCedarHost() async {
  return resolveCedarHostImpl();
}

/// The CedarDevice representing the WiFi transport (name is null, marking it
/// as WiFi rather than Bluetooth). Used to let the user manually switch back
/// to WiFi, e.g. from the connection recovery dialog.
CedarDevice wifiDevice() => CedarDevice(address: wifiDeviceAddressImpl());
