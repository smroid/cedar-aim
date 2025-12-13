// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Mobile impl for platform-specific functions.

import 'dart:io';

import 'package:cedar_flutter/platform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

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

bool canExitAppImpl() {
  return !Platform.isIOS;
}

void exitAppImpl() {
  if (Platform.isIOS) {
    // On iOS, apps cannot exit themselves per Apple guidelines.
    // Users should use the home button to exit the app.
  } else {
    SystemNavigator.pop();
  }
}

Future<bool> checkNetworkConnectivityImpl(String host) async {
  try {
    // On iOS, dart_ping doesn't work. Use socket connection test instead.
    if (Platform.isIOS) {
      // Try to connect to port 80 as a connectivity test
      final socket = await Socket.connect(host, 80,
          timeout: Duration(seconds: 3));
      socket.destroy();
      return true;
    } else {
      // Use ping on Android and other platforms
      final ping = Ping(host, count: 1);

      await for (final response in ping.stream) {
        // If we get any response, the host is reachable
        if (response.response != null) {
          return true;
        }
        break; // We only need the first response
      }
      return false;
    }
  } catch (e) {
    debugPrint('Network connectivity check failed: $e');
    return false;
  }
}

Future<bool> isAppUpdateAvailableImpl() async {
  try {
    final info = await InAppUpdate.checkForUpdate();
    return info.updateAvailability == UpdateAvailability.updateAvailable;
  } catch (e) {
    debugPrint('Error checking for app update: $e');
    return false;
  }
}

Future<void> startAppUpdateImpl() async {
  try {
    if (Platform.isAndroid) {
      // On Android, use the native in-app update API.
      await InAppUpdate.performImmediateUpdate();
    } else if (Platform.isIOS) {
      // On iOS, open the App Store.
      final appStoreUrl = 'https://apps.apple.com/app/cedar-aim/id6740513717';
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(
          Uri.parse(appStoreUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  } catch (e) {
    debugPrint('Error starting app update: $e');
  }
}
