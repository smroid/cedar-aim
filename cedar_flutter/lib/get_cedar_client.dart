// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';

// For non-web deployments.

String _tryAddress = "raspberrypi.local";
String? _goodAddress;
ClientChannel? _channel;
cedar_rpc.CedarClient? _client;

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
);

void rpcSucceeded() {
  if (_goodAddress == null) {
    _goodAddress = _tryAddress;
    debugPrint("Connected to $_goodAddress");
  }
}

void rpcFailed() {
  if (_goodAddress != null) {
    _channel?.shutdown();
    _channel = ClientChannel(_tryAddress, port: 80, options: _options);
    _client = CedarClient(_channel!);
  }
}

CedarClient getClient() {
  if (_goodAddress != null) {
    return _client!;
  }
  switch (_tryAddress) {
    case "raspberrypi.local":
      _tryAddress = "192.168.4.1";
      break;
    case "192.168.4.1":
      _tryAddress = "192.168.1.133";
      break;
    default:
      _tryAddress = "raspberrypi.local";
      break;
  }
  _channel?.shutdown();
  _channel = ClientChannel(_tryAddress, port: 80, options: _options);
  _client = CedarClient(_channel!);
  return _client!;
}

void goFullScreen() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  } catch (e) {
    debugPrint('Could not enter full screen with setEnabledSystemUIMode: $e');
  }
}

void cancelFullScreen() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  } catch (e) {
    debugPrint('Could not exit full screen with setEnabledSystemUIMode: $e');
  }
}
