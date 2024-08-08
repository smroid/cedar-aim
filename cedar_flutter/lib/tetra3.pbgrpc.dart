//
//  Generated code. Do not modify.
//  source: tetra3.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'tetra3.pb.dart' as $0;

export 'tetra3.pb.dart';

@$pb.GrpcServiceName('tetra3_server.Tetra3')
class Tetra3Client extends $grpc.Client {
  static final _$solveFromCentroids = $grpc.ClientMethod<$0.SolveRequest, $0.SolveResult>(
      '/tetra3_server.Tetra3/SolveFromCentroids',
      ($0.SolveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SolveResult.fromBuffer(value));

  Tetra3Client($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SolveResult> solveFromCentroids($0.SolveRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$solveFromCentroids, request, options: options);
  }
}

@$pb.GrpcServiceName('tetra3_server.Tetra3')
abstract class Tetra3ServiceBase extends $grpc.Service {
  $core.String get $name => 'tetra3_server.Tetra3';

  Tetra3ServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SolveRequest, $0.SolveResult>(
        'SolveFromCentroids',
        solveFromCentroids_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SolveRequest.fromBuffer(value),
        ($0.SolveResult value) => value.writeToBuffer()));
  }

  $async.Future<$0.SolveResult> solveFromCentroids_Pre($grpc.ServiceCall call, $async.Future<$0.SolveRequest> request) async {
    return solveFromCentroids(call, await request);
  }

  $async.Future<$0.SolveResult> solveFromCentroids($grpc.ServiceCall call, $0.SolveRequest request);
}
