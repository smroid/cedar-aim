// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Web-based impl for platform-specific functions.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc_web.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

GrpcWebClientChannel? _channel;

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
