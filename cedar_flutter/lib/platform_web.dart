// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Web-based impl for platform-specific functions.

// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js' as js;

import 'package:cedar_flutter/cedar.pbgrpc.dart';
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

bool isIOSImpl() {
  return false;
}

void rpcSucceededImpl() {}
void rpcFailedImpl() {
  if (_channel != null) {
    _channel!.shutdown();
    _channel = null;
  }
}

CedarClient getClientImpl() {
  _channel ??= GrpcWebClientChannel.xhr(Uri.base);
  return CedarClient(_channel!);
}

// This usually doesn't work on Web.
void goFullScreenImpl() {
  try {
    if (document.fullscreenEnabled!) {
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
    if (document.fullscreenEnabled!) {
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

Future<bool> checkNetworkConnectivityImpl(String host) async {
  // For web platform, we can't do traditional ping, but we can try HTTP request
  throw UnimplementedError("Network connectivity check not implemented for web");
}
