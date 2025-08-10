//
//  Generated code. Do not modify.
//  source: cedar.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'cedar.pb.dart' as $0;
import 'cedar_sky.pb.dart' as $1;

export 'cedar.pb.dart';

@$pb.GrpcServiceName('cedar.Cedar')
class CedarClient extends $grpc.Client {
  static final _$getServerLog = $grpc.ClientMethod<$0.ServerLogRequest, $0.ServerLogResult>(
      '/cedar.Cedar/GetServerLog',
      ($0.ServerLogRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServerLogResult.fromBuffer(value));
  static final _$updateFixedSettings = $grpc.ClientMethod<$0.FixedSettings, $0.FixedSettings>(
      '/cedar.Cedar/UpdateFixedSettings',
      ($0.FixedSettings value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FixedSettings.fromBuffer(value));
  static final _$updateOperationSettings = $grpc.ClientMethod<$0.OperationSettings, $0.OperationSettings>(
      '/cedar.Cedar/UpdateOperationSettings',
      ($0.OperationSettings value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OperationSettings.fromBuffer(value));
  static final _$updatePreferences = $grpc.ClientMethod<$0.Preferences, $0.Preferences>(
      '/cedar.Cedar/UpdatePreferences',
      ($0.Preferences value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Preferences.fromBuffer(value));
  static final _$getFrame = $grpc.ClientMethod<$0.FrameRequest, $0.FrameResult>(
      '/cedar.Cedar/GetFrame',
      ($0.FrameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FrameResult.fromBuffer(value));
  static final _$initiateAction = $grpc.ClientMethod<$0.ActionRequest, $0.EmptyMessage>(
      '/cedar.Cedar/InitiateAction',
      ($0.ActionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value));
  static final _$queryCatalogEntries = $grpc.ClientMethod<$1.QueryCatalogRequest, $1.QueryCatalogResponse>(
      '/cedar.Cedar/QueryCatalogEntries',
      ($1.QueryCatalogRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.QueryCatalogResponse.fromBuffer(value));
  static final _$getCatalogEntry = $grpc.ClientMethod<$1.CatalogEntryKey, $1.CatalogEntry>(
      '/cedar.Cedar/GetCatalogEntry',
      ($1.CatalogEntryKey value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CatalogEntry.fromBuffer(value));
  static final _$getCatalogDescriptions = $grpc.ClientMethod<$0.EmptyMessage, $1.CatalogDescriptionResponse>(
      '/cedar.Cedar/GetCatalogDescriptions',
      ($0.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CatalogDescriptionResponse.fromBuffer(value));
  static final _$getObjectTypes = $grpc.ClientMethod<$0.EmptyMessage, $1.ObjectTypeResponse>(
      '/cedar.Cedar/GetObjectTypes',
      ($0.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ObjectTypeResponse.fromBuffer(value));
  static final _$getConstellations = $grpc.ClientMethod<$0.EmptyMessage, $1.ConstellationResponse>(
      '/cedar.Cedar/GetConstellations',
      ($0.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ConstellationResponse.fromBuffer(value));

  CedarClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ServerLogResult> getServerLog($0.ServerLogRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getServerLog, request, options: options);
  }

  $grpc.ResponseFuture<$0.FixedSettings> updateFixedSettings($0.FixedSettings request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFixedSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.OperationSettings> updateOperationSettings($0.OperationSettings request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateOperationSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.Preferences> updatePreferences($0.Preferences request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updatePreferences, request, options: options);
  }

  $grpc.ResponseFuture<$0.FrameResult> getFrame($0.FrameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFrame, request, options: options);
  }

  $grpc.ResponseFuture<$0.EmptyMessage> initiateAction($0.ActionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$initiateAction, request, options: options);
  }

  $grpc.ResponseFuture<$1.QueryCatalogResponse> queryCatalogEntries($1.QueryCatalogRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$queryCatalogEntries, request, options: options);
  }

  $grpc.ResponseFuture<$1.CatalogEntry> getCatalogEntry($1.CatalogEntryKey request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCatalogEntry, request, options: options);
  }

  $grpc.ResponseFuture<$1.CatalogDescriptionResponse> getCatalogDescriptions($0.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCatalogDescriptions, request, options: options);
  }

  $grpc.ResponseFuture<$1.ObjectTypeResponse> getObjectTypes($0.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getObjectTypes, request, options: options);
  }

  $grpc.ResponseFuture<$1.ConstellationResponse> getConstellations($0.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getConstellations, request, options: options);
  }
}

@$pb.GrpcServiceName('cedar.Cedar')
abstract class CedarServiceBase extends $grpc.Service {
  $core.String get $name => 'cedar.Cedar';

  CedarServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ServerLogRequest, $0.ServerLogResult>(
        'GetServerLog',
        getServerLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ServerLogRequest.fromBuffer(value),
        ($0.ServerLogResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FixedSettings, $0.FixedSettings>(
        'UpdateFixedSettings',
        updateFixedSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FixedSettings.fromBuffer(value),
        ($0.FixedSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OperationSettings, $0.OperationSettings>(
        'UpdateOperationSettings',
        updateOperationSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OperationSettings.fromBuffer(value),
        ($0.OperationSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Preferences, $0.Preferences>(
        'UpdatePreferences',
        updatePreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Preferences.fromBuffer(value),
        ($0.Preferences value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FrameRequest, $0.FrameResult>(
        'GetFrame',
        getFrame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FrameRequest.fromBuffer(value),
        ($0.FrameResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ActionRequest, $0.EmptyMessage>(
        'InitiateAction',
        initiateAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ActionRequest.fromBuffer(value),
        ($0.EmptyMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.QueryCatalogRequest, $1.QueryCatalogResponse>(
        'QueryCatalogEntries',
        queryCatalogEntries_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.QueryCatalogRequest.fromBuffer(value),
        ($1.QueryCatalogResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CatalogEntryKey, $1.CatalogEntry>(
        'GetCatalogEntry',
        getCatalogEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CatalogEntryKey.fromBuffer(value),
        ($1.CatalogEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EmptyMessage, $1.CatalogDescriptionResponse>(
        'GetCatalogDescriptions',
        getCatalogDescriptions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
        ($1.CatalogDescriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EmptyMessage, $1.ObjectTypeResponse>(
        'GetObjectTypes',
        getObjectTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
        ($1.ObjectTypeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EmptyMessage, $1.ConstellationResponse>(
        'GetConstellations',
        getConstellations_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
        ($1.ConstellationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ServerLogResult> getServerLog_Pre($grpc.ServiceCall $call, $async.Future<$0.ServerLogRequest> $request) async {
    return getServerLog($call, await $request);
  }

  $async.Future<$0.FixedSettings> updateFixedSettings_Pre($grpc.ServiceCall $call, $async.Future<$0.FixedSettings> $request) async {
    return updateFixedSettings($call, await $request);
  }

  $async.Future<$0.OperationSettings> updateOperationSettings_Pre($grpc.ServiceCall $call, $async.Future<$0.OperationSettings> $request) async {
    return updateOperationSettings($call, await $request);
  }

  $async.Future<$0.Preferences> updatePreferences_Pre($grpc.ServiceCall $call, $async.Future<$0.Preferences> $request) async {
    return updatePreferences($call, await $request);
  }

  $async.Future<$0.FrameResult> getFrame_Pre($grpc.ServiceCall $call, $async.Future<$0.FrameRequest> $request) async {
    return getFrame($call, await $request);
  }

  $async.Future<$0.EmptyMessage> initiateAction_Pre($grpc.ServiceCall $call, $async.Future<$0.ActionRequest> $request) async {
    return initiateAction($call, await $request);
  }

  $async.Future<$1.QueryCatalogResponse> queryCatalogEntries_Pre($grpc.ServiceCall $call, $async.Future<$1.QueryCatalogRequest> $request) async {
    return queryCatalogEntries($call, await $request);
  }

  $async.Future<$1.CatalogEntry> getCatalogEntry_Pre($grpc.ServiceCall $call, $async.Future<$1.CatalogEntryKey> $request) async {
    return getCatalogEntry($call, await $request);
  }

  $async.Future<$1.CatalogDescriptionResponse> getCatalogDescriptions_Pre($grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getCatalogDescriptions($call, await $request);
  }

  $async.Future<$1.ObjectTypeResponse> getObjectTypes_Pre($grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getObjectTypes($call, await $request);
  }

  $async.Future<$1.ConstellationResponse> getConstellations_Pre($grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getConstellations($call, await $request);
  }

  $async.Future<$0.ServerLogResult> getServerLog($grpc.ServiceCall call, $0.ServerLogRequest request);
  $async.Future<$0.FixedSettings> updateFixedSettings($grpc.ServiceCall call, $0.FixedSettings request);
  $async.Future<$0.OperationSettings> updateOperationSettings($grpc.ServiceCall call, $0.OperationSettings request);
  $async.Future<$0.Preferences> updatePreferences($grpc.ServiceCall call, $0.Preferences request);
  $async.Future<$0.FrameResult> getFrame($grpc.ServiceCall call, $0.FrameRequest request);
  $async.Future<$0.EmptyMessage> initiateAction($grpc.ServiceCall call, $0.ActionRequest request);
  $async.Future<$1.QueryCatalogResponse> queryCatalogEntries($grpc.ServiceCall call, $1.QueryCatalogRequest request);
  $async.Future<$1.CatalogEntry> getCatalogEntry($grpc.ServiceCall call, $1.CatalogEntryKey request);
  $async.Future<$1.CatalogDescriptionResponse> getCatalogDescriptions($grpc.ServiceCall call, $0.EmptyMessage request);
  $async.Future<$1.ObjectTypeResponse> getObjectTypes($grpc.ServiceCall call, $0.EmptyMessage request);
  $async.Future<$1.ConstellationResponse> getConstellations($grpc.ServiceCall call, $0.EmptyMessage request);
}
