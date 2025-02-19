// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Mobile impl for platform-specific functions.

import 'dart:io';

import 'package:cedar_flutter/platform.dart';
import 'package:geolocator/geolocator.dart';

import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

bool isWebImpl() {
  return false;
}

bool isAndroidImpl() {
  return Platform.isAndroid;
}

bool isIOSImpl() {
  return Platform.isIOS;
}

String _wifiAddress = isMobile() ? "192.168.4.1" : "192.168.1.158";
ClientChannel? _channel;
cedar_rpc.CedarClient? _client;

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
);

void rpcSucceededImpl() {}
void rpcFailedImpl() {
  _client = null;
}

CedarClient getClientImpl() {
  if (_client != null) {
    return _client!;
  }
  _channel?.shutdown();
  _channel = ClientChannel(_wifiAddress, port: 80, options: _options);
  _client = CedarClient(_channel!);
  return _client!;
}

void goFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  } catch (e) {
    debugPrint('Could not enter full screen with setEnabledSystemUIMode: $e');
  }
}

void cancelFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  } catch (e) {
    debugPrint('Could not exit full screen with setEnabledSystemUIMode: $e');
  }
}

void setWakeLockImpl(bool locked) {
  WakelockPlus.toggle(enable: locked);
}

Future<bool> getWakeLockImpl() async {
  return await WakelockPlus.enabled;
}

bool evaluatedCanGetLocation = false;
bool canGetLocation = false;

Future<bool> canGetLocationImpl() async {
  if (evaluatedCanGetLocation) {
    return canGetLocation;
  }
  canGetLocation = await _canGetLocationImpl();
  evaluatedCanGetLocation = true;
  return canGetLocation;
}

Future<bool> _canGetLocationImpl() async {
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint("Location services not enabled");
    return false;
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint("Location permissions are denied");
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    debugPrint("Location permissions are denied forever");
    return false;
  }
  return true;
}

Future<Position?> getLocationImpl() async {
  if (!await canGetLocationImpl()) {
    return null;
  }
  return await Geolocator.getLastKnownPosition();
}

void exitAppImpl() {
  exit(0);
}
