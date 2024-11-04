//
//  Generated code. Do not modify.
//  source: cedar.proto
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

import 'cedar.pb.dart' as $1;
import 'cedar_sky.pb.dart' as $2;

export 'cedar.pb.dart';

@$pb.GrpcServiceName('cedar.Cedar')
class CedarClient extends $grpc.Client {
  static final _$getServerLog = $grpc.ClientMethod<$1.ServerLogRequest, $1.ServerLogResult>(
      '/cedar.Cedar/GetServerLog',
      ($1.ServerLogRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ServerLogResult.fromBuffer(value));
  static final _$updateFixedSettings = $grpc.ClientMethod<$1.FixedSettings, $1.FixedSettings>(
      '/cedar.Cedar/UpdateFixedSettings',
      ($1.FixedSettings value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.FixedSettings.fromBuffer(value));
  static final _$updateOperationSettings = $grpc.ClientMethod<$1.OperationSettings, $1.OperationSettings>(
      '/cedar.Cedar/UpdateOperationSettings',
      ($1.OperationSettings value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.OperationSettings.fromBuffer(value));
  static final _$updatePreferences = $grpc.ClientMethod<$1.Preferences, $1.Preferences>(
      '/cedar.Cedar/UpdatePreferences',
      ($1.Preferences value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Preferences.fromBuffer(value));
  static final _$getFrame = $grpc.ClientMethod<$1.FrameRequest, $1.FrameResult>(
      '/cedar.Cedar/GetFrame',
      ($1.FrameRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.FrameResult.fromBuffer(value));
  static final _$initiateAction = $grpc.ClientMethod<$1.ActionRequest, $1.EmptyMessage>(
      '/cedar.Cedar/InitiateAction',
      ($1.ActionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.EmptyMessage.fromBuffer(value));
  static final _$queryCatalogEntries = $grpc.ClientMethod<$2.QueryCatalogRequest, $2.QueryCatalogResponse>(
      '/cedar.Cedar/QueryCatalogEntries',
      ($2.QueryCatalogRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.QueryCatalogResponse.fromBuffer(value));
  static final _$getCatalogEntry = $grpc.ClientMethod<$2.CatalogEntryKey, $2.CatalogEntry>(
      '/cedar.Cedar/GetCatalogEntry',
      ($2.CatalogEntryKey value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.CatalogEntry.fromBuffer(value));
  static final _$getCatalogDescriptions = $grpc.ClientMethod<$1.EmptyMessage, $2.CatalogDescriptionResponse>(
      '/cedar.Cedar/GetCatalogDescriptions',
      ($1.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.CatalogDescriptionResponse.fromBuffer(value));
  static final _$getObjectTypes = $grpc.ClientMethod<$1.EmptyMessage, $2.ObjectTypeResponse>(
      '/cedar.Cedar/GetObjectTypes',
      ($1.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ObjectTypeResponse.fromBuffer(value));
  static final _$getConstellations = $grpc.ClientMethod<$1.EmptyMessage, $2.ConstellationResponse>(
      '/cedar.Cedar/GetConstellations',
      ($1.EmptyMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ConstellationResponse.fromBuffer(value));

  CedarClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.ServerLogResult> getServerLog($1.ServerLogRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getServerLog, request, options: options);
  }

  $grpc.ResponseFuture<$1.FixedSettings> updateFixedSettings($1.FixedSettings request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFixedSettings, request, options: options);
  }

  $grpc.ResponseFuture<$1.OperationSettings> updateOperationSettings($1.OperationSettings request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateOperationSettings, request, options: options);
  }

  $grpc.ResponseFuture<$1.Preferences> updatePreferences($1.Preferences request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updatePreferences, request, options: options);
  }

  $grpc.ResponseFuture<$1.FrameResult> getFrame($1.FrameRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFrame, request, options: options);
  }

  $grpc.ResponseFuture<$1.EmptyMessage> initiateAction($1.ActionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$initiateAction, request, options: options);
  }

  $grpc.ResponseFuture<$2.QueryCatalogResponse> queryCatalogEntries($2.QueryCatalogRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$queryCatalogEntries, request, options: options);
  }

  $grpc.ResponseFuture<$2.CatalogEntry> getCatalogEntry($2.CatalogEntryKey request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCatalogEntry, request, options: options);
  }

  $grpc.ResponseFuture<$2.CatalogDescriptionResponse> getCatalogDescriptions($1.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getCatalogDescriptions, request, options: options);
  }

  $grpc.ResponseFuture<$2.ObjectTypeResponse> getObjectTypes($1.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getObjectTypes, request, options: options);
  }

  $grpc.ResponseFuture<$2.ConstellationResponse> getConstellations($1.EmptyMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getConstellations, request, options: options);
  }
}

@$pb.GrpcServiceName('cedar.Cedar')
abstract class CedarServiceBase extends $grpc.Service {
  $core.String get $name => 'cedar.Cedar';

  CedarServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.ServerLogRequest, $1.ServerLogResult>(
        'GetServerLog',
        getServerLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ServerLogRequest.fromBuffer(value),
        ($1.ServerLogResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.FixedSettings, $1.FixedSettings>(
        'UpdateFixedSettings',
        updateFixedSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.FixedSettings.fromBuffer(value),
        ($1.FixedSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.OperationSettings, $1.OperationSettings>(
        'UpdateOperationSettings',
        updateOperationSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.OperationSettings.fromBuffer(value),
        ($1.OperationSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Preferences, $1.Preferences>(
        'UpdatePreferences',
        updatePreferences_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Preferences.fromBuffer(value),
        ($1.Preferences value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.FrameRequest, $1.FrameResult>(
        'GetFrame',
        getFrame_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.FrameRequest.fromBuffer(value),
        ($1.FrameResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ActionRequest, $1.EmptyMessage>(
        'InitiateAction',
        initiateAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ActionRequest.fromBuffer(value),
        ($1.EmptyMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.QueryCatalogRequest, $2.QueryCatalogResponse>(
        'QueryCatalogEntries',
        queryCatalogEntries_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.QueryCatalogRequest.fromBuffer(value),
        ($2.QueryCatalogResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.CatalogEntryKey, $2.CatalogEntry>(
        'GetCatalogEntry',
        getCatalogEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.CatalogEntryKey.fromBuffer(value),
        ($2.CatalogEntry value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EmptyMessage, $2.CatalogDescriptionResponse>(
        'GetCatalogDescriptions',
        getCatalogDescriptions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EmptyMessage.fromBuffer(value),
        ($2.CatalogDescriptionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EmptyMessage, $2.ObjectTypeResponse>(
        'GetObjectTypes',
        getObjectTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EmptyMessage.fromBuffer(value),
        ($2.ObjectTypeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.EmptyMessage, $2.ConstellationResponse>(
        'GetConstellations',
        getConstellations_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.EmptyMessage.fromBuffer(value),
        ($2.ConstellationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.ServerLogResult> getServerLog_Pre($grpc.ServiceCall call, $async.Future<$1.ServerLogRequest> request) async {
    return getServerLog(call, await request);
  }

  $async.Future<$1.FixedSettings> updateFixedSettings_Pre($grpc.ServiceCall call, $async.Future<$1.FixedSettings> request) async {
    return updateFixedSettings(call, await request);
  }

  $async.Future<$1.OperationSettings> updateOperationSettings_Pre($grpc.ServiceCall call, $async.Future<$1.OperationSettings> request) async {
    return updateOperationSettings(call, await request);
  }

  $async.Future<$1.Preferences> updatePreferences_Pre($grpc.ServiceCall call, $async.Future<$1.Preferences> request) async {
    return updatePreferences(call, await request);
  }

  $async.Future<$1.FrameResult> getFrame_Pre($grpc.ServiceCall call, $async.Future<$1.FrameRequest> request) async {
    return getFrame(call, await request);
  }

  $async.Future<$1.EmptyMessage> initiateAction_Pre($grpc.ServiceCall call, $async.Future<$1.ActionRequest> request) async {
    return initiateAction(call, await request);
  }

  $async.Future<$2.QueryCatalogResponse> queryCatalogEntries_Pre($grpc.ServiceCall call, $async.Future<$2.QueryCatalogRequest> request) async {
    return queryCatalogEntries(call, await request);
  }

  $async.Future<$2.CatalogEntry> getCatalogEntry_Pre($grpc.ServiceCall call, $async.Future<$2.CatalogEntryKey> request) async {
    return getCatalogEntry(call, await request);
  }

  $async.Future<$2.CatalogDescriptionResponse> getCatalogDescriptions_Pre($grpc.ServiceCall call, $async.Future<$1.EmptyMessage> request) async {
    return getCatalogDescriptions(call, await request);
  }

  $async.Future<$2.ObjectTypeResponse> getObjectTypes_Pre($grpc.ServiceCall call, $async.Future<$1.EmptyMessage> request) async {
    return getObjectTypes(call, await request);
  }

  $async.Future<$2.ConstellationResponse> getConstellations_Pre($grpc.ServiceCall call, $async.Future<$1.EmptyMessage> request) async {
    return getConstellations(call, await request);
  }

  $async.Future<$1.ServerLogResult> getServerLog($grpc.ServiceCall call, $1.ServerLogRequest request);
  $async.Future<$1.FixedSettings> updateFixedSettings($grpc.ServiceCall call, $1.FixedSettings request);
  $async.Future<$1.OperationSettings> updateOperationSettings($grpc.ServiceCall call, $1.OperationSettings request);
  $async.Future<$1.Preferences> updatePreferences($grpc.ServiceCall call, $1.Preferences request);
  $async.Future<$1.FrameResult> getFrame($grpc.ServiceCall call, $1.FrameRequest request);
  $async.Future<$1.EmptyMessage> initiateAction($grpc.ServiceCall call, $1.ActionRequest request);
  $async.Future<$2.QueryCatalogResponse> queryCatalogEntries($grpc.ServiceCall call, $2.QueryCatalogRequest request);
  $async.Future<$2.CatalogEntry> getCatalogEntry($grpc.ServiceCall call, $2.CatalogEntryKey request);
  $async.Future<$2.CatalogDescriptionResponse> getCatalogDescriptions($grpc.ServiceCall call, $1.EmptyMessage request);
  $async.Future<$2.ObjectTypeResponse> getObjectTypes($grpc.ServiceCall call, $1.EmptyMessage request);
  $async.Future<$2.ConstellationResponse> getConstellations($grpc.ServiceCall call, $1.EmptyMessage request);
}
