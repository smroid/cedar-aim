// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:html';

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

CedarClient getClient() {
  return CedarClient(GrpcWebClientChannel.xhr(Uri.base));
}

void goFullScreen() {
  document.documentElement?.requestFullscreen();
}

void cancelFullScreen() {
  document.exitFullscreen();
}
