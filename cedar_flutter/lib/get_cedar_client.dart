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
cedar_rpc.CedarClient? _client;

void rpcSucceeded() {
  _goodAddress = _tryAddress;
  debugPrint("Connected to $_goodAddress");
}

CedarClient getClient() {
  const options = ChannelOptions(
    credentials: ChannelCredentials.insecure(),
    connectTimeout: Duration(seconds: 5),
    keepAlive:
        ClientKeepAliveOptions(pingInterval: Duration(milliseconds: 100)),
  );
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
  _client = CedarClient(ClientChannel(_tryAddress, port: 80, options: options));
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
