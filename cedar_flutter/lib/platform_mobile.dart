// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Mobile impl for platform-specific functions.

import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';

String _tryAddress = "raspberrypi.local";
String? _goodAddress;
ClientChannel? _channel;
cedar_rpc.CedarClient? _client;

const _options = ChannelOptions(
  credentials: ChannelCredentials.insecure(),
  connectTimeout: Duration(seconds: 5),
);

void rpcSucceededImpl() {
  if (_goodAddress == null) {
    _goodAddress = _tryAddress;
    debugPrint("Connected to $_goodAddress");
  }
}

void rpcFailedImpl() {
  if (_goodAddress != null) {
    _channel?.shutdown();
    _channel = ClientChannel(_tryAddress, port: 80, options: _options);
    _client = CedarClient(_channel!);
  }
}

CedarClient getClientImpl() {
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

void goFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  } catch (e) {
    debugPrint('Could not enter full screen with setEnabledSystemUIMode: $e');
  }
}

void cancelFullScreenImpl() {
  try {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  } catch (e) {
    debugPrint('Could not exit full screen with setEnabledSystemUIMode: $e');
  }
}
