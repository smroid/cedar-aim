// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:grpc/grpc.dart';

// For non-web deployments.
CedarClient getClient() {
  return CedarClient(ClientChannel(
//    'raspberrypi.local',
    '192.168.1.133',
    port: 80,
    options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        connectTimeout: Duration(seconds: 5)),
  ));
}

void goFullScreen() {}
void cancelFullScreen() {}
