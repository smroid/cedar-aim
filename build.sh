#!/bin/bash

cd cedar_flutter/lib
protoc --experimental_allow_proto3_optional --dart_out=grpc:. --proto_path=../../src/proto ../../src/proto/cedar.proto ../../src/proto/cedar_common.proto ../../src/proto/cedar_sky.proto
flutter build web --no-web-resources-cdn

