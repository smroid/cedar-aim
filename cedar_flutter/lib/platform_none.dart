// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:cedar_flutter/platform.dart' show CedarDevice;
import 'package:geolocator/geolocator.dart';

bool isWebImpl() {
  throw UnimplementedError("No impl in platform_none");
}

bool isAndroidImpl() {
  throw UnimplementedError("No impl in platform_none");
}

bool isIOSImpl() {
  throw UnimplementedError("No impl in platform_none");
}

int btReconnectFailuresImpl() => 0;
bool isBluetoothInUseImpl() => false;
bool btTargetUnbondedImpl() => false;
Future<bool> isBtDeviceBondedImpl(String address) async => false;
void btTeardownImpl() {}

void rpcSucceededImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void rpcFailedImpl() {
  throw UnimplementedError("No impl in platform_none");
}

Future<CedarClient> getClientImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

bool isFullScreenImpl() => false;

bool isStandaloneImpl() => false;

bool isSystemUiOverlaysVisibleImpl() => false;

void setSystemUiChangeListenerImpl(void Function(bool)? listener) {}

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

Future<bool> canGetLocationImpl() async {
  return false;
}

Future<Position?> getLocationImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

bool canExitAppImpl() {
  throw UnimplementedError("No impl in platform_none");
}

void exitAppImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

Future<bool> isAppUpdateAvailableImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

Future<void> startAppUpdateImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

Future<void> cleanupImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

Future<List<CedarDevice>> getBluetoothDevicesImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

Future<void> setActiveDeviceImpl(CedarDevice device) async {
  throw UnimplementedError("No impl in platform_none");
}

Future<void> preloadDeviceSelectionImpl() async {}

Future<String?> resolveCedarHostImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

void setCedarHostResolverImpl(
    Future<String?> Function()? resolver, void Function()? reset) {
  throw UnimplementedError("No impl in platform_none");
}

String? wifiDeviceNameImpl() {
  throw UnimplementedError("No impl in platform_none");
}

Future<String> deviceModelImpl() async {
  throw UnimplementedError("No impl in platform_none");
}

void resetWifiResolutionImpl() {
  throw UnimplementedError("No impl in platform_none");
}

Future<void> persistServerWifiModeImpl(
    {required bool isClient, String? clientSsid}) async {
  throw UnimplementedError("No impl in platform_none");
}

Future<({bool isClient, String? clientSsid})> readServerWifiModeImpl() async {
  throw UnimplementedError("No impl in platform_none");
}
