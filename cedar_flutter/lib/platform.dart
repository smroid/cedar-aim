// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

// Functions that have platform-specific implementations.

import 'platform_none.dart'
    if (dart.library.io) 'platform_mobile.dart'
    if (dart.library.html) 'platform_web.dart';

enum CedarTransport { wifi, bluetooth }

/// A device the app can connect to, over WiFi or Bluetooth.
///
/// [name] is the device's single universal name: it is simultaneously the
/// WiFi access-point SSID, the Bluetooth advertised name, and the mDNS name
/// (reached at `<name>.local`). Over WiFi the host is derived from the name
/// (`<name>.local`) rather than stored, so [name] may be null before we have
/// ever learned it (first-ever contact); the resolution ladder then falls
/// back to the AP address / subnet sweep. Over Bluetooth [btMac] holds the
/// MAC needed to open the link, since it cannot be derived from the name.
class CedarDevice {
  final CedarTransport transport;
  final String? name;
  final String? btMac; // Set iff transport == bluetooth.

  CedarDevice.wifi({this.name})
      : transport = CedarTransport.wifi,
        btMac = null;

  CedarDevice.bluetooth({required this.name, required String this.btMac})
      : transport = CedarTransport.bluetooth;

  bool get isWifi => transport == CedarTransport.wifi;
  bool get isBluetooth => transport == CedarTransport.bluetooth;

  /// Stable identity key for equality/tracking (was the old `address`).
  /// For BT that is the MAC; for WiFi the name (or empty when unknown).
  String get key => btMac ?? name ?? '';

  @override
  bool operator ==(Object other) =>
      other is CedarDevice &&
      other.transport == transport &&
      other.name == name &&
      other.btMac == btMac;

  @override
  int get hashCode => Object.hash(transport, name, btMac);
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

bool isFullScreen() {
  try {
    return isFullScreenImpl();
  } catch (e) {
    debugPrint('isFullScreen: $e');
    return false;
  }
}

void toggleFullScreen() {
  try {
    if (isFullScreen()) {
      cancelFullScreen();
    } else {
      goFullScreen();
    }
  } catch (e) {
    debugPrint('toggleFullScreen: $e');
  }
}

bool isStandalone() {
  try {
    return isStandaloneImpl();
  } catch (e) {
    debugPrint('isStandalone: $e');
    return false;
  }
}

// True (Android only) when the system status/navigation bars have been
// swiped back into view while we're still nominally in fullscreen mode.
bool systemUiOverlaysVisible() {
  try {
    return isSystemUiOverlaysVisibleImpl();
  } catch (e) {
    debugPrint('systemUiOverlaysVisible: $e');
    return false;
  }
}

// Registers a callback invoked whenever systemUiOverlaysVisible() changes.
// Pass null to unregister. No-op on platforms other than Android.
void setSystemUiChangeListener(void Function(bool)? listener) {
  try {
    setSystemUiChangeListenerImpl(listener);
  } catch (e) {
    debugPrint('setSystemUiChangeListener: $e');
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

/// Returns true only if the device's OS confirms it is currently bonded, over
/// Bluetooth, to the Bluetooth device at [address] (e.g. the server's own
/// Bluetooth adapter address, from the GetBluetoothName RPC). This makes a
/// live query of the device's Bluetooth bond state independent of the current
/// transport, so it can be used to gate actions (like disabling a WiFi access
/// point) that require a working Bluetooth fallback even when currently
/// connected over WiFi. Returns false (fails closed) if the bond state can't
/// be confirmed, e.g. on web, if [address] is empty, or if the query fails or
/// times out.
Future<bool> isBtDeviceBonded(String address) =>
    isBtDeviceBondedImpl(address);

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

/// Resolves the address to reach the device over WiFi, caching the result.
/// Returns null if nothing is reachable; callers must handle that rather than
/// assuming a usable address.
Future<String?> resolveCedarHost() async {
  return resolveCedarHostImpl();
}

/// Injects a resolver and cache-reset callback to use in place of DIY's
/// fixed-AP default. Pass null for both to restore the default.
void setCedarHostResolver(
        Future<String?> Function()? resolver, void Function()? reset) =>
    setCedarHostResolverImpl(resolver, reset);

/// The CedarDevice representing the WiFi transport. Used to switch to WiFi,
/// e.g. from the connection recovery dialog. Carries the last-known device
/// name if we have one (so it resolves `<name>.local`); otherwise the
/// resolution ladder handles first-contact via the AP address / subnet sweep.
CedarDevice wifiDevice() => CedarDevice.wifi(name: wifiDeviceNameImpl());

/// Persists the device's WiFi mode (and client SSID for client mode) so the
/// connection-recovery dialog's "use wifi" can resume the right mode. The
/// passphrase is never stored — the server remembers it.
Future<void> persistServerWifiMode(
        {required bool isClient, String? clientSsid}) =>
    persistServerWifiModeImpl(isClient: isClient, clientSsid: clientSsid);

/// Reads the persisted device WiFi mode for recovery resume. Defaults to
/// access-point (isClient == false) when nothing has been stored.
Future<({bool isClient, String? clientSsid})> readServerWifiMode() =>
    readServerWifiModeImpl();

/// The short model name of the phone/tablet running the app (e.g. "Pixel 8",
/// "iPhone", "iPad"), for disambiguating "this device" from the Cedar device in
/// UI text. Returns "" if unavailable; callers should have a generic fallback.
Future<String> deviceModel() => deviceModelImpl();

/// Discards the cached WiFi host so the next connect re-runs the resolution
/// ladder. Call when the user explicitly asks to reconnect (e.g. "Retry")
/// after the device may have moved to a new address (e.g. a client-mode join,
/// where it leaves the AP's 192.168.4.1 for a DHCP address).
void resetWifiResolution() => resetWifiResolutionImpl();

/// Opens the phone's WiFi settings screen (so the user can join the network the
/// device is switching to). Best-effort; failures are logged, not thrown.
///
/// On Android this reliably opens the WiFi settings pane directly. On iOS,
/// Apple provides no public API to deep-link to the WiFi pane specifically;
/// the private App-Prefs:WIFI URL scheme this used to rely on is rejected by
/// modern iOS versions and falls back to this app's own settings page
/// (app-settings:), not general Settings. We use settings() (App-prefs:)
/// instead, which reliably opens the top-level Settings app; see
/// [wifiSettingsLabel] for UI copy that matches this.
Future<void> openWifiSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => settings.wifi(),
      OpenSettingsPlusIOS settings => settings.settings(),
      _ => throw Exception('Platform not supported'),
    };
  } catch (e) {
    debugPrint('openWifiSettings error: $e');
  }
}

/// Label for the button/link that calls [openWifiSettings], reflecting what
/// the platform actually navigates to: Android goes straight to the WiFi
/// pane, iOS can only reach the general Settings app.
String get wifiSettingsLabel => isIOS() ? 'Settings' : 'WiFi Settings';

/// Whether the phone offers a direct link to personal-hotspot / tethering
/// settings. True on iOS (dedicated screen); false on Android, which has no
/// reliable deep link — callers should not offer hotspot navigation there
/// (dumping the user in WiFi settings instead would be misleading).
bool get canOpenHotspotSettings => OpenSettingsPlus.shared is OpenSettingsPlusIOS;

/// Opens the phone's personal-hotspot settings so the user can turn on the
/// hotspot the device is about to join. Only meaningful when
/// [canOpenHotspotSettings] is true. Best-effort; failures are logged.
Future<void> openHotspotSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusIOS settings => settings.personalHotspot(),
      _ => throw Exception('Hotspot settings not available on this platform'),
    };
  } catch (e) {
    debugPrint('openHotspotSettings error: $e');
  }
}
