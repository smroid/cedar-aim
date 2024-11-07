// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:html';

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc_web.dart';

GrpcWebClientChannel? _channel;

void rpcSucceeded() {}
void rpcFailed() {
  if (_channel != null) {
    _channel!.shutdown();
    _channel = null;
  }
}

CedarClient getClient() {
  _channel ??= GrpcWebClientChannel.xhr(Uri.base);
  return CedarClient(_channel!);
}

void goFullScreen() {
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

void cancelFullScreen() {
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
