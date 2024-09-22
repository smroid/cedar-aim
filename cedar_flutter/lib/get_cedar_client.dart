// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/cedar.pbgrpc.dart';
import 'package:grpc/grpc.dart';

// For non-web deployments.
CedarClient getClient() {
  return CedarClient(ClientChannel(
    'raspberrypi.local',
    port: 80,
    options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        connectTimeout: Duration(seconds: 5)),
  ));
}

void goFullScreen() {}
void cancelFullScreen() {}
