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

// Cached short model name of the phone/tablet running the app (e.g. "Pixel 8",
// "iPhone", "iPad"), used to disambiguate "this device" from the Cedar device.
// iOS redacts the user-set name since iOS 16, so this is the model/type, not a
// personal name. Empty if unavailable.
String _deviceModel = '';

Future<String> deviceModelImpl() async {
  if (_deviceModel.isNotEmpty) {
    return _deviceModel;
  }
  try {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      _deviceModel = (await info.androidInfo).model;
    } else if (Platform.isIOS) {
      // iOS gives a generic model ("iPhone"/"iPad") since the name is redacted.
      _deviceModel = (await info.iosInfo).model;
    }
  } catch (e) {
    debugPrint('deviceModel lookup failed: $e');
  }
  return _deviceModel;
}

const _networkChannel = MethodChannel('cedar/network');

// UUID for Cedar control channel defined in cedar-server
String _btUuid = "4e5d4c88-2965-423f-9111-28a506720760";

// The device's access-point address, where DIY Cedar always operates.
const String _apAddress = "192.168.4.1";

// Port used for all gRPC WiFi connections to Cedar (cedar-server also listens
// on 8080, see cedar_server.rs, but 80 works fine on both platforms).
const int cedarWifiPort = 80;

// SharedPreferences keys. Transport axis (how we reach the device):
const String _prefDeviceName = 'device_name';
const String _prefDeviceTransport = 'device_transport'; // 'wifi' | 'bluetooth'
const String _prefDeviceBtMac = 'device_bt_mac';
// Device WiFi-mode axis (what mode to resume from the recovery dialog):
const String _prefServerWifiMode = 'server_wifi_mode'; // 'access_point'|'client'
const String _prefServerWifiClientSsid = 'server_wifi_client_ssid';
// Legacy keys (pre-schema-redesign), read once for migration.
const String _legacyDeviceName = 'selected_device_name';
const String _legacyDeviceAddress = 'selected_device_address';

// The last-known device name (== AP SSID == BT name == mDNS <name>.local).
// Learned from ServerInformation.device_name; null until first contact.
String? _deviceName;

// The device the app is currently using (or would use) to reach the server.
// Defaults to WiFi with no known name yet; updated by setActiveDeviceImpl()
// when the user selects a device, and by learnDeviceNameImpl() on connect.
CedarDevice _activeDevice = CedarDevice.wifi();

String? wifiDeviceNameImpl() => _deviceName;

// Forces the next WiFi connect to re-resolve instead of reusing the cached
// address. Used when the user explicitly asks to reconnect (e.g. the recovery
// dialog's "Retry").
void resetWifiResolutionImpl() {
  _resolvedCedarHost = null;
  _cedarHostResolutionReset?.call();
  debugPrint('WiFi resolution reset; next connect will re-resolve');
}
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

// Cached result of the WiFi host resolution ladder. Cleared on teardown
// (rpcFailedImpl/cleanup) so a network switch re-resolves.
String? _resolvedCedarHost;

// Set via setCedarHostResolverImpl() to override DIY's fixed-AP resolution
// below; null (and thus unused) when nothing has injected a resolver.
Future<String?> Function()? _cedarHostResolver;

// Paired with _cedarHostResolver: clears the injected resolver's own cache.
// Called from resetWifiResolutionImpl() so "Retry" also forces the injected
// resolver to re-resolve, not just this file's cache.
void Function()? _cedarHostResolutionReset;

void setCedarHostResolverImpl(
    Future<String?> Function()? resolver, void Function()? reset) {
  _cedarHostResolver = resolver;
  _cedarHostResolutionReset = reset;
}

/// Resolves the address to reach the device over WiFi, caching the result.
///
/// If a resolver has been injected (see [setCedarHostResolverImpl]), defers to
/// it entirely. Otherwise assumes DIY Cedar, always reachable at its fixed
/// address.
Future<String?> resolveCedarHostImpl() async {
  final injected = _cedarHostResolver;
  if (injected != null) {
    return injected();
  }
  if (_resolvedCedarHost != null) {
    return _resolvedCedarHost!;
  }
  _resolvedCedarHost = _apAddress;
  return _resolvedCedarHost;
}

int btReconnectFailuresImpl() => _btReconnectFailures;
bool isBluetoothInUseImpl() => _btDeviceSelected;
bool btTargetUnbondedImpl() => _btTargetUnbonded;

// Live query of whether the phone's OS is currently bonded, over Bluetooth,
// to the device at [address] (independent of the current transport, so it
// works even while connected over WiFi). Fails closed: returns false if
// [address] is empty, or if the bond-state query fails or times out. This is
// intentionally stricter than _isTargetDeviceBonded() (which fails open for
// reconnect leniency), because callers use this to gate actions that require a
// confirmed Bluetooth fallback.
Future<bool> isBtDeviceBondedImpl(String address) async {
  if (address.isEmpty) {
    return false;
  }
  try {
    final bondedDevices = await FlutterBlueClassic()
        .bondedDevices
        .timeout(const Duration(seconds: 3), onTimeout: () => null);
    if (bondedDevices == null) {
      return false;
    }
    return bondedDevices.any((d) =>
        d.address == address && d.bondState == BluetoothBondState.bonded);
  } catch (e) {
    debugPrint('Error checking bond state for $address: $e');
    return false;
  }
}

void rpcSucceededImpl() {
  if (_btReconnectFailures > 0) {
    debugPrint('BT rpcSucceeded: resetting failure count from $_btReconnectFailures');
    _btReconnectFailures = 0;
  }
  _btTargetUnbonded = false;
  if (Platform.isAndroid && !_boundToWifi && _activeDevice.isWifi) {
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
  // Deliberately KEEP _resolvedCedarHost: on a transient failure (e.g. the
  // server briefly went away) the device is almost certainly still at the same
  // address, so the next attempt should just retry it — that keeps reconnect
  // (and the "connection lost" UI) fast instead of re-running the whole
  // resolution ladder. The cache is invalidated only when a connection attempt
  // to that cached address actually fails (see the WiFi connect path), which
  // is the real "device moved / network switched" signal.
  //
  // Unbind from the network so that on reconnect we rebind to the (possibly
  // new) network handle. Without this, returning to the device's WiFi after a
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

// One-time migration from the legacy prefs schema (selected_device_name /
// selected_device_address) to the current one. The legacy schema encoded
// transport implicitly (name present => Bluetooth) and overloaded the address
// (MAC for BT, host for WiFi). Runs only if no current-schema key exists.
Future<void> _migrateLegacyPrefs(SharedPreferences prefs) async {
  if (prefs.getString(_prefDeviceTransport) != null) {
    return; // Already on the current schema.
  }
  final legacyName = prefs.getString(_legacyDeviceName);
  final legacyAddress = prefs.getString(_legacyDeviceAddress);
  if (legacyAddress == null && legacyName == null) {
    return; // Nothing persisted yet; first run.
  }
  if (legacyName != null) {
    // Had a BT device: name is the device name, address is the MAC.
    await prefs.setString(_prefDeviceTransport, 'bluetooth');
    await prefs.setString(_prefDeviceName, legacyName);
    if (legacyAddress != null) {
      await prefs.setString(_prefDeviceBtMac, legacyAddress);
    }
  } else {
    // Had a WiFi device: address was a host, either "<name>.local" or the
    // bare AP IP. Recover the device name by stripping ".local"; if it was
    // the AP IP (or otherwise not a .local name), leave the name unset so we
    // re-learn it from ServerInformation on first contact.
    await prefs.setString(_prefDeviceTransport, 'wifi');
    if (legacyAddress != null && legacyAddress.endsWith('.local')) {
      final name =
          legacyAddress.substring(0, legacyAddress.length - '.local'.length);
      if (name.isNotEmpty && name != 'cedar') {
        // 'cedar' was the old hardcoded placeholder, never a real device
        // name; treat it as unknown so we re-learn the real name.
        await prefs.setString(_prefDeviceName, name);
      }
    }
  }
  await prefs.remove(_legacyDeviceName);
  await prefs.remove(_legacyDeviceAddress);
}

// Loads persisted device selection (migrating the legacy schema first) into
// the in-memory state: _activeDevice, _deviceName, _btDeviceSelected.
Future<void> _loadDeviceSelection(SharedPreferences prefs) async {
  await _migrateLegacyPrefs(prefs);
  final transport = prefs.getString(_prefDeviceTransport);
  final name = prefs.getString(_prefDeviceName);
  _deviceName = name;
  if (transport == 'bluetooth') {
    final mac = prefs.getString(_prefDeviceBtMac);
    if (mac != null) {
      _activeDevice = CedarDevice.bluetooth(name: name, btMac: mac);
      _btDeviceSelected = true;
      return;
    }
  }
  // Default / WiFi.
  _activeDevice = CedarDevice.wifi(name: name);
  _btDeviceSelected = false;
}

// Idempotently loads the persisted device selection (including _deviceName)
// exactly once, before anything reads _deviceName/_activeDevice.
Future<void> _ensureDeviceLoaded() async {
  if (_deviceLoaded) {
    return;
  }
  _deviceLoaded = true;
  final prefs = await SharedPreferences.getInstance();
  await _loadDeviceSelection(prefs);
}

// Call early (e.g. from initState) to set _btDeviceSelected before the first
// build() runs, so the connection dialog gate works correctly from the start.
Future<void> preloadDeviceSelectionImpl() async {
  await _ensureDeviceLoaded();
}

// Persists the learned device name (fire-and-forget from the connect path).
Future<void> _persistDeviceName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_prefDeviceName, name);
}

// Persists the device's WiFi mode (and client ssid for client mode) so the
// connection-recovery dialog's "use wifi" can resume the right mode. Called
// from setWifiModeImpl(); psk is never stored (the server remembers it).
Future<void> persistServerWifiModeImpl(
    {required bool isClient, String? clientSsid}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      _prefServerWifiMode, isClient ? 'client' : 'access_point');
  if (isClient && clientSsid != null && clientSsid.isNotEmpty) {
    await prefs.setString(_prefServerWifiClientSsid, clientSsid);
  }
}

// Reads the persisted device WiFi mode for recovery resume. Returns a record
// of (isClient, clientSsid). Defaults to access-point when nothing is stored.
Future<({bool isClient, String? clientSsid})> readServerWifiModeImpl() async {
  final prefs = await SharedPreferences.getInstance();
  final mode = prefs.getString(_prefServerWifiMode);
  final isClient = mode == 'client';
  return (
    isClient: isClient,
    clientSsid: isClient ? prefs.getString(_prefServerWifiClientSsid) : null,
  );
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

  final mac = _activeDevice.btMac;
  if (mac == null) {
    return; // Not a Bluetooth device; nothing to reconnect.
  }
  if (!await _isTargetDeviceBonded(mac)) {
    // Unbonded is a permanent condition until the user re-pairs — waiting
    // out the cooldown won't help. Count it as a real failed attempt (keeps
    // the failure counter/log honest) but set the fast-path flag so the
    // dialog gate doesn't need to wait for the full failure threshold.
    _btReconnectFailures++;
    _btTargetUnbonded = true;
    debugPrint('BT reconnect: $mac is no longer bonded '
        '(consecutive failures: $_btReconnectFailures)');
    return;
  }

  try {
    await _establishBluetoothConnection(mac);
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
  // Load persisted device selection (migrating legacy schema) if not already
  // done — resolution may have loaded it first (e.g. updater_fix).
  final wasLoaded = _deviceLoaded;
  await _ensureDeviceLoaded();
  if (!wasLoaded) {
    debugPrint('Loaded device: transport=${_activeDevice.transport} '
        'name=${_activeDevice.name} btMac=${_activeDevice.btMac}');
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
  if (isAndroidImpl() && _activeDevice.isBluetooth) {
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
  if (_client == null && (!isAndroidImpl() || _activeDevice.isWifi)) {
    await _shutdownChannel();
    _activeProxy = null;
    _activeProxyPort = null;

    // Resolve the WiFi host (cached if available). This can throw, or return
    // null, when nothing is reachable; treat that the same as a connection
    // failure below.
    String addressToTry = '?';
    try {
      final resolved = await resolveCedarHostImpl();
      if (resolved == null) {
        throw Exception('No reachable Cedar address on this network');
      }
      addressToTry = resolved;

      _channel = ClientChannel(addressToTry, port: cedarWifiPort, options: _options);
      _client = CedarClient(_channel!);

      // Test the WiFi connection before returning. Use getFrame() since it's
      // been available in all server versions (unlike newer RPCs).
      final request = cedar_rpc.FrameRequest()
        ..nonBlocking = true;
      final response = await _client!
          .getFrame(request,
              options: CallOptions(
                timeout: const Duration(seconds: 5),
              ))
          .timeout(const Duration(seconds: 7), onTimeout: () {
        throw TimeoutException(
            'WiFi connection test timed out connecting to $addressToTry:$cedarWifiPort');
      });
      debugPrint('WiFi connection test succeeded');
      // Update active device to reflect WiFi usage. Learn/refresh the device
      // name from the response so future connects can resolve <name>.local.
      final learnedName = response.serverInformation.deviceName;
      if (learnedName.isNotEmpty && learnedName != _deviceName) {
        debugPrint('Learned device name "$learnedName" '
            '(was "${_deviceName ?? ''}"); persisting for <name>.local');
        _deviceName = learnedName;
        unawaited(_persistDeviceName(learnedName));
      } else {
        debugPrint('Device name unchanged: "${_deviceName ?? ''}"');
      }
      if (isAndroidImpl()) {
        _activeDevice = CedarDevice.wifi(name: _deviceName);
      }
      return _client!;
    } catch (e) {
      _client = null;
      await _shutdownChannel(timeoutSeconds: 1);
      // Keep _resolvedCedarHost: a failed attempt (typically "connection
      // refused" while the server is briefly down, or a timeout) does NOT mean
      // the address is wrong — the device is almost certainly still there. We
      // keep retrying the same cached address on each reconnect probe so the
      // "connection lost" UI surfaces quickly, instead of falling into the slow
      // resolution ladder. The cache is re-resolved only on an explicit trigger
      // (see resetWifiResolutionImpl, called on device (re)selection).
      // No Bluetooth fallback available, rethrow the error with context.
      debugPrint('WiFi connection test failed connecting to $addressToTry:$cedarWifiPort: $e');
      throw Exception('Failed to connect to Cedar ($addressToTry:$cedarWifiPort): $e');
    }
  }

  if (_client == null) {
    throw Exception('No client available');
  }
  return _client!;
}

bool _isMobileFullScreen = false;

bool isFullScreenImpl() => _isMobileFullScreen;

bool isStandaloneImpl() => true;  // Disable full screen button.

// On Android, swiping from the top/bottom edge can reveal the system status
// and/or navigation bars while we're still in immersive mode. SystemChrome's
// system UI change callback fires for this case, so we track it separately and
// let callers (e.g. to show a fullscreen button as a way back) react to it.
bool _systemUiOverlaysVisible = false;
void Function(bool)? _systemUiChangeListener;
bool _systemUiCallbackRegistered = false;

void _ensureSystemUiCallbackRegistered() {
  if (_systemUiCallbackRegistered || !Platform.isAndroid) {
    return;
  }
  _systemUiCallbackRegistered = true;
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    _systemUiOverlaysVisible = systemOverlaysAreVisible && _isMobileFullScreen;
    _systemUiChangeListener?.call(_systemUiOverlaysVisible);
  });
}

bool isSystemUiOverlaysVisibleImpl() => _systemUiOverlaysVisible;

void setSystemUiChangeListenerImpl(void Function(bool)? listener) {
  _systemUiChangeListener = listener;
  _ensureSystemUiCallbackRegistered();
}

void goFullScreenImpl() {
  try {
    _ensureSystemUiCallbackRegistered();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _isMobileFullScreen = true;
    if (_systemUiOverlaysVisible) {
      _systemUiOverlaysVisible = false;
      _systemUiChangeListener?.call(false);
    }
  } catch (e) {
    debugPrint('Could not enter full screen with setEnabledSystemUIMode: $e');
  }
}

void cancelFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _isMobileFullScreen = false;
    if (_systemUiOverlaysVisible) {
      _systemUiOverlaysVisible = false;
      _systemUiChangeListener?.call(false);
    }
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
  // Force the resolution ladder to run again next connect: cleanup happens on
  // device (re)selection / transport switch / dispose, i.e. the moments where
  // the device's address may genuinely have changed. (A plain RPC failure does
  // NOT come through here, so a transient blip keeps retrying the cached
  // address quickly rather than re-resolving.)
  _resolvedCedarHost = null;
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

        return CedarDevice.bluetooth(name: displayName, btMac: d.address);
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
    // Only reset the reconnect backoff when the user actually switches to a
    // different device. Re-selecting the currently-active device (e.g. tapping
    // it again in the connection recovery dialog while a reconnect is already
    // churning) must preserve _btReconnectFailures/_lastBtAttemptTime so the
    // reconnect cooldown stays in effect — otherwise we defeat the cooldown and
    // re-page an already-struggling link.
    final sameDevice = device == _activeDevice;
    _activeDevice = device;
    _btDeviceSelected = device.isBluetooth;
    // Remember the device name across a WiFi/BT switch so WiFi can resolve
    // <name>.local; a WiFi selection may carry no name yet (bootstrap).
    if (device.name != null && device.name!.isNotEmpty) {
      _deviceName = device.name;
    }
    if (!sameDevice) {
      _btReconnectFailures = 0;
      _btTargetUnbonded = false;
    }

    // Clean up any existing connection.
    await cleanupImpl();

    // Persist device selection for next app launch (current schema).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _prefDeviceTransport, device.isBluetooth ? 'bluetooth' : 'wifi');
    if (device.name != null && device.name!.isNotEmpty) {
      await prefs.setString(_prefDeviceName, device.name!);
    }
    if (device.isBluetooth) {
      // Connection will be established on the next getClientImpl() call.
      await prefs.setString(_prefDeviceBtMac, device.btMac!);
    } else {
      await prefs.remove(_prefDeviceBtMac);
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

    // Connect timeout must comfortably exceed how long the server can take to
    // accept an RFCOMM connection. Right after the WiFi AP is disabled, the
    // shared WiFi/BT radio settles and the server has been observed to take
    // ~12s to accept. A too-short timeout abandons a connection that then
    // succeeds server-side but is left with no client driving it, so the
    // server's RFCOMM-write watchdog reaps it ~30s later — dragging recovery
    // out across several failed attempts.
    _bluetoothConnection = await flutterBlue
        .connect(addr, uuid: _btUuid)
        .timeout(const Duration(seconds: 20), onTimeout: () {
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
