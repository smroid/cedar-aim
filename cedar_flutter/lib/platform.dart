// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';

// Functions that have platform-specific implementations.

import 'platform_none.dart'
    if (dart.library.io) 'platform_mobile.dart'
    if (dart.library.html) 'platform_web.dart';

void rpcSucceeded() {
  rpcSucceededImpl();
}

void rpcFailed() {
  rpcFailedImpl();
}

CedarClient getClient() {
  return getClientImpl();
}

void goFullScreen() {
  goFullScreenImpl();
}

void cancelFullScreen() {
  cancelFullScreenImpl();
}

void setWakeLock(bool locked) {
  setWakeLockImpl(locked);
}

Future<bool> getWakeLock() async {
  return getWakeLockImpl();
}
