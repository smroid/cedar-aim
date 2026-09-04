// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Web-based impl for platform-specific functions.

// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js' as js;

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:cedar_flutter/platform.dart' show CedarDevice;
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grpc/grpc_web.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

GrpcWebClientChannel? _channel;

bool isWebImpl() {
  return true;
}

bool isAndroidImpl() {
  return false;
}

// iPadOS 13+ reports as MacIntel, distinguished by multi-touch support.
bool isIOSImpl() {
  final ua = window.navigator.userAgent;
  final platform = window.navigator.platform ?? '';
  final maxTouchPoints = window.navigator.maxTouchPoints ?? 0;
  return RegExp(r'iPad|iPhone|iPod').hasMatch(ua) ||
      (platform == 'MacIntel' && maxTouchPoints > 1);
}

void rpcSucceededImpl() {}
void rpcFailedImpl() {
  if (_channel != null) {
    _channel!.shutdown();
    _channel = null;
  }
}

// Web has no Bluetooth transport, so these are always the WiFi-only defaults.
int btReconnectFailuresImpl() => 0;
bool isBluetoothInUseImpl() => false;
bool btTargetUnbondedImpl() => false;
void btTeardownImpl() {}
Future<void> preloadDeviceSelectionImpl() async {}

Future<CedarClient> getClientImpl() async {
  _channel ??= GrpcWebClientChannel.xhr(Uri.base);
  return CedarClient(_channel!);
}

bool isFullScreenImpl() {
  try {
    return document.fullscreenElement != null;
  } catch (_) {
    return false;
  }
}

void toggleFullScreenImpl() {
  if (isFullScreenImpl()) {
    cancelFullScreenImpl();
  } else {
    goFullScreenImpl();
  }
}

// Detects standalone/fullscreen display mode (installed PWA / Home Screen).
bool isStandaloneImpl() {
  try {
    return window.matchMedia('(display-mode: standalone)').matches ||
        window.matchMedia('(display-mode: fullscreen)').matches;
  } catch (_) {
    return false;
  }
}

void goFullScreenImpl() {
  try {
    if (document.fullscreenEnabled ?? false) {
      document.documentElement?.requestFullscreen();
    } else {
      debugPrint("Fullscreen not enabled.");
    }
  } catch (e) {
    debugPrint('Could not call requestFullscreen: $e');
  }
}

void cancelFullScreenImpl() {
  try {
    if (document.fullscreenEnabled ?? false) {
      document.exitFullscreen();
    } else {
      debugPrint("Fullscreen not enabled.");
    }
  } catch (e) {
    debugPrint('Could not call exitFullscreen: $e');
  }
}

// This usually doesn't work on Web.
void setWakeLockImpl(bool locked) {
  WakelockPlus.toggle(enable: locked);
}

Future<bool> getWakeLockImpl() async {
  return await WakelockPlus.enabled;
}

Future<bool> canGetLocationImpl() async {
  return false;
}

// This is only available when we're served over HTTPS.
Future<Position?> getLocationImpl() async {
  throw UnimplementedError("No getLocationImpl in platform_web");
}

bool canExitAppImpl() {
  return true; // Web can attempt to close the window
}

void exitAppImpl() {
  js.context.callMethod('close');
}


Future<bool> isAppUpdateAvailableImpl() async {
  return false; // No app store update mechanism for web
}

Future<void> startAppUpdateImpl() async {
  // No app store update mechanism for web
}

Future<void> cleanupImpl() async {
  _channel!.shutdown();
  _channel = null;
}

Future<List<CedarDevice>> getBluetoothDevicesImpl() async {
  throw UnimplementedError("Bluetooth not implemented for web");
}

Future<void> setActiveDeviceImpl(CedarDevice device) async {
  throw UnimplementedError("No impl in platform_web");
}

Future<String> resolveCedarHostImpl() async {
  return 'cedar.local'; // Web doesn't need mDNS fallback.
}

String wifiDeviceAddressImpl() => 'cedar.local';
