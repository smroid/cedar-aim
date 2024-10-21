// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:developer';
import 'dart:html';

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

CedarClient getClient() {
  return CedarClient(GrpcWebClientChannel.xhr(Uri.base));
}

void goFullScreen() {
  try {
    if (document.fullscreenEnabled!) {
      document.documentElement?.requestFullscreen();
    } else {
      log("Fullscreen not enabled.");
    }
  } catch (e) {
    log('Could not call requestFullscreen: $e');
  }
}

void cancelFullScreen() {
  try {
    if (document.fullscreenEnabled!) {
      document.exitFullscreen();
    } else {
      log("Fullscreen not enabled.");
    }
  } catch (e) {
    log('Could not call exitFullscreen: $e');
  }
}
