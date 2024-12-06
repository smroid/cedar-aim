// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:geolocator/geolocator.dart';

void rpcSucceededImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void rpcFailedImpl() {
  throw UnimplementedError("No impl in platform_none");
}

CedarClient getClientImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void goFullScreenImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void cancelFullScreenImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void setWakeLockImpl(bool locked) {
  throw UnimplementedError("No impl in platform_none");
}

Future<bool> getWakeLockImpl() {
  throw UnimplementedError("No impl in platform_none");
}

Future<Position?> getLocationImpl() async {
  throw UnimplementedError("No impl in platform_none");
}