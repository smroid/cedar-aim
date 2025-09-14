// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

// Functions that have platform-specific implementations.

import 'platform_none.dart'
    if (dart.library.io) 'platform_mobile.dart'
    if (dart.library.html) 'platform_web.dart';

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

CedarClient getClient() {
  try {
    return getClientImpl();
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

void exitApp() {
  try {
    return exitAppImpl();
  } catch (e) {
    debugPrint('exitApp: $e');
    rethrow;
  }
}

/// Check network connectivity to a specific host (ping-like functionality).
/// Returns true if the host is reachable, false otherwise.
Future<bool> checkNetworkConnectivity(String host) async {
  try {
    return await checkNetworkConnectivityImpl(host);
  } catch (e) {
    debugPrint('checkNetworkConnectivity: $e');
    return false;
  }
}
