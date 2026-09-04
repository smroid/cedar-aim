// This is a generated file - do not edit.
//
// Generated from cedar.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'cedar.pb.dart' as $0;
import 'cedar_common.pb.dart' as $2;
import 'cedar_sky.pb.dart' as $1;

export 'cedar.pb.dart';

@$pb.GrpcServiceName('cedar.Cedar')
class CedarClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CedarClient(super.channel, {super.options, super.interceptors});

  /// Returns the tail of Cedar's server log file.
  $grpc.ResponseFuture<$0.ServerLogResult> getServerLog(
    $0.ServerLogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getServerLog, request, options: options);
  }

  /// Returns a human-readable, top-like snapshot of instantaneous CPU usage:
  /// the busiest processes system-wide, and a per-thread breakdown of
  /// Cedar's own threads. Takes about a second to complete, since it samples
  /// /proc twice to compute instantaneous (not lifetime-average) CPU%.
  $grpc.ResponseFuture<$0.CpuUsageReport> getCpuUsageReport(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCpuUsageReport, request, options: options);
  }

  /// Changes zero or more of Cedar's "fixed" settings. If a field is omitted
  /// from the supplied FixedSettings, that setting is not updated. Returns the
  /// FixedSettings after any updates have been applied. To get the current
  /// settings without making any changes, pass an empty FixedSettings request.
  $grpc.ResponseFuture<$0.FixedSettings> updateFixedSettings(
    $0.FixedSettings request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateFixedSettings, request, options: options);
  }

  /// Reverts Cedar's observer location back to unknown.
  $grpc.ResponseFuture<$0.EmptyMessage> clearObserverLocation(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clearObserverLocation, request, options: options);
  }

  /// Changes zero or more of Cedar's operation settings. If a field is omitted
  /// from the supplied OperationSettings, that setting is not updated. Returns
  /// the OperationSettings after any updates have been applied (in most cases;
  /// when the change triggers a calilbration, the change is not reflected until
  /// the calibration is complete).
  /// To get the current settings without making any changes, pass an empty
  /// OperationSettings request.
  $grpc.ResponseFuture<$0.OperationSettings> updateOperationSettings(
    $0.OperationSettings request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateOperationSettings, request,
        options: options);
  }

  /// Changes zero or more of Cedar's user interface preferences. If a field is
  /// omitted from the supplied Preferences, that preference is not updated.
  /// For the dont_show_items field: an empty array means no change; a non-empty
  /// array means add these items to the existing set (no duplicates).
  /// Returns the Preferences after any updates have been applied. To get the
  /// current preferences without making any changes, pass an empty Preferences
  /// request.
  $grpc.ResponseFuture<$0.Preferences> updatePreferences(
    $0.Preferences request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updatePreferences, request, options: options);
  }

  /// Obtains the most recent Cedar computation result. Blocks if necessary to
  /// wait for a new result (see FrameRequest's `prev_frame_id` field).
  $grpc.ResponseFuture<$0.FrameResult> getFrame(
    $0.FrameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFrame, request, options: options);
  }

  /// Server-streaming variant of GetFrame(). The client sends one FrameRequest
  /// and the server pushes FrameResult messages continuously as new frames
  /// become available, until the client cancels the stream. The `non_blocking`
  /// field of FrameRequest is ignored; the server always waits for a new frame
  /// before sending. The `prev_frame_id` / `prev_solution_id` fields apply only
  /// to the first frame; subsequent frames advance automatically.
  $grpc.ResponseStream<$0.FrameResult> getFrames(
    $0.FrameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getFrames, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Returns the most recently acquired camera image. This is always an 8 bit
  /// monochrome image; if the camera is color the raw bayer array is returned.
  /// The image is split across multiple streamed ImageResult messages (see
  /// ImageResult.image_chunk). See ImageRequest.prev_frame_id for how to
  /// obtain successive fresh images.
  /// Returns an error if images are not currently being acquired, or if a
  /// calibration is in progress.
  $grpc.ResponseStream<$0.ImageResult> getImage(
    $0.ImageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$getImage, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Performs the requested action(s).
  $grpc.ResponseFuture<$0.EmptyMessage> initiateAction(
    $0.ActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$initiateAction, request, options: options);
  }

  /// For Cedar Sky, if implemented in Cedar server. See cedar_sky.proto.
  $grpc.ResponseFuture<$1.QueryCatalogResponse> queryCatalogEntries(
    $1.QueryCatalogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$queryCatalogEntries, request, options: options);
  }

  $grpc.ResponseFuture<$1.CatalogEntry> getCatalogEntry(
    $1.CatalogEntryKey request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogEntry, request, options: options);
  }

  $grpc.ResponseFuture<$1.CatalogDescriptionResponse> getCatalogDescriptions(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCatalogDescriptions, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.ObjectTypeResponse> getObjectTypes(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getObjectTypes, request, options: options);
  }

  $grpc.ResponseFuture<$1.ConstellationResponse> getConstellations(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConstellations, request, options: options);
  }

  /// Bluetooth management.
  $grpc.ResponseFuture<$0.GetBluetoothNameResponse> getBluetoothName(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBluetoothName, request, options: options);
  }

  $grpc.ResponseFuture<$0.EmptyMessage> setPairingMode(
    $0.SetPairingModeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setPairingMode, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetBondedDevicesResponse> getBondedDevices(
    $0.EmptyMessage request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBondedDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.EmptyMessage> removeBond(
    $0.RemoveBondRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeBond, request, options: options);
  }

  /// Conversion utility. Error if the observer location or time is not known.
  $grpc.ResponseFuture<$2.HorizonCoord> convertToHorizon(
    $2.CelestialCoord request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$convertToHorizon, request, options: options);
  }

  $grpc.ResponseFuture<$2.CelestialCoord> convertToCelestial(
    $2.HorizonCoord request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$convertToCelestial, request, options: options);
  }

  // method descriptors

  static final _$getServerLog =
      $grpc.ClientMethod<$0.ServerLogRequest, $0.ServerLogResult>(
          '/cedar.Cedar/GetServerLog',
          ($0.ServerLogRequest value) => value.writeToBuffer(),
          $0.ServerLogResult.fromBuffer);
  static final _$getCpuUsageReport =
      $grpc.ClientMethod<$0.EmptyMessage, $0.CpuUsageReport>(
          '/cedar.Cedar/GetCpuUsageReport',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $0.CpuUsageReport.fromBuffer);
  static final _$updateFixedSettings =
      $grpc.ClientMethod<$0.FixedSettings, $0.FixedSettings>(
          '/cedar.Cedar/UpdateFixedSettings',
          ($0.FixedSettings value) => value.writeToBuffer(),
          $0.FixedSettings.fromBuffer);
  static final _$clearObserverLocation =
      $grpc.ClientMethod<$0.EmptyMessage, $0.EmptyMessage>(
          '/cedar.Cedar/ClearObserverLocation',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $0.EmptyMessage.fromBuffer);
  static final _$updateOperationSettings =
      $grpc.ClientMethod<$0.OperationSettings, $0.OperationSettings>(
          '/cedar.Cedar/UpdateOperationSettings',
          ($0.OperationSettings value) => value.writeToBuffer(),
          $0.OperationSettings.fromBuffer);
  static final _$updatePreferences =
      $grpc.ClientMethod<$0.Preferences, $0.Preferences>(
          '/cedar.Cedar/UpdatePreferences',
          ($0.Preferences value) => value.writeToBuffer(),
          $0.Preferences.fromBuffer);
  static final _$getFrame = $grpc.ClientMethod<$0.FrameRequest, $0.FrameResult>(
      '/cedar.Cedar/GetFrame',
      ($0.FrameRequest value) => value.writeToBuffer(),
      $0.FrameResult.fromBuffer);
  static final _$getFrames =
      $grpc.ClientMethod<$0.FrameRequest, $0.FrameResult>(
          '/cedar.Cedar/GetFrames',
          ($0.FrameRequest value) => value.writeToBuffer(),
          $0.FrameResult.fromBuffer);
  static final _$getImage = $grpc.ClientMethod<$0.ImageRequest, $0.ImageResult>(
      '/cedar.Cedar/GetImage',
      ($0.ImageRequest value) => value.writeToBuffer(),
      $0.ImageResult.fromBuffer);
  static final _$initiateAction =
      $grpc.ClientMethod<$0.ActionRequest, $0.EmptyMessage>(
          '/cedar.Cedar/InitiateAction',
          ($0.ActionRequest value) => value.writeToBuffer(),
          $0.EmptyMessage.fromBuffer);
  static final _$queryCatalogEntries =
      $grpc.ClientMethod<$1.QueryCatalogRequest, $1.QueryCatalogResponse>(
          '/cedar.Cedar/QueryCatalogEntries',
          ($1.QueryCatalogRequest value) => value.writeToBuffer(),
          $1.QueryCatalogResponse.fromBuffer);
  static final _$getCatalogEntry =
      $grpc.ClientMethod<$1.CatalogEntryKey, $1.CatalogEntry>(
          '/cedar.Cedar/GetCatalogEntry',
          ($1.CatalogEntryKey value) => value.writeToBuffer(),
          $1.CatalogEntry.fromBuffer);
  static final _$getCatalogDescriptions =
      $grpc.ClientMethod<$0.EmptyMessage, $1.CatalogDescriptionResponse>(
          '/cedar.Cedar/GetCatalogDescriptions',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $1.CatalogDescriptionResponse.fromBuffer);
  static final _$getObjectTypes =
      $grpc.ClientMethod<$0.EmptyMessage, $1.ObjectTypeResponse>(
          '/cedar.Cedar/GetObjectTypes',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $1.ObjectTypeResponse.fromBuffer);
  static final _$getConstellations =
      $grpc.ClientMethod<$0.EmptyMessage, $1.ConstellationResponse>(
          '/cedar.Cedar/GetConstellations',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $1.ConstellationResponse.fromBuffer);
  static final _$getBluetoothName =
      $grpc.ClientMethod<$0.EmptyMessage, $0.GetBluetoothNameResponse>(
          '/cedar.Cedar/GetBluetoothName',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $0.GetBluetoothNameResponse.fromBuffer);
  static final _$setPairingMode =
      $grpc.ClientMethod<$0.SetPairingModeRequest, $0.EmptyMessage>(
          '/cedar.Cedar/SetPairingMode',
          ($0.SetPairingModeRequest value) => value.writeToBuffer(),
          $0.EmptyMessage.fromBuffer);
  static final _$getBondedDevices =
      $grpc.ClientMethod<$0.EmptyMessage, $0.GetBondedDevicesResponse>(
          '/cedar.Cedar/GetBondedDevices',
          ($0.EmptyMessage value) => value.writeToBuffer(),
          $0.GetBondedDevicesResponse.fromBuffer);
  static final _$removeBond =
      $grpc.ClientMethod<$0.RemoveBondRequest, $0.EmptyMessage>(
          '/cedar.Cedar/RemoveBond',
          ($0.RemoveBondRequest value) => value.writeToBuffer(),
          $0.EmptyMessage.fromBuffer);
  static final _$convertToHorizon =
      $grpc.ClientMethod<$2.CelestialCoord, $2.HorizonCoord>(
          '/cedar.Cedar/ConvertToHorizon',
          ($2.CelestialCoord value) => value.writeToBuffer(),
          $2.HorizonCoord.fromBuffer);
  static final _$convertToCelestial =
      $grpc.ClientMethod<$2.HorizonCoord, $2.CelestialCoord>(
          '/cedar.Cedar/ConvertToCelestial',
          ($2.HorizonCoord value) => value.writeToBuffer(),
          $2.CelestialCoord.fromBuffer);
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
    $addMethod($grpc.ServiceMethod<$0.EmptyMessage, $0.CpuUsageReport>(
        'GetCpuUsageReport',
        getCpuUsageReport_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
        ($0.CpuUsageReport value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FixedSettings, $0.FixedSettings>(
        'UpdateFixedSettings',
        updateFixedSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FixedSettings.fromBuffer(value),
        ($0.FixedSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.EmptyMessage, $0.EmptyMessage>(
        'ClearObserverLocation',
        clearObserverLocation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
        ($0.EmptyMessage value) => value.writeToBuffer()));
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
    $addMethod($grpc.ServiceMethod<$0.FrameRequest, $0.FrameResult>(
        'GetFrames',
        getFrames_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.FrameRequest.fromBuffer(value),
        ($0.FrameResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.ImageResult>(
        'GetImage',
        getImage_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.ImageResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ActionRequest, $0.EmptyMessage>(
        'InitiateAction',
        initiateAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ActionRequest.fromBuffer(value),
        ($0.EmptyMessage value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.QueryCatalogRequest, $1.QueryCatalogResponse>(
            'QueryCatalogEntries',
            queryCatalogEntries_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.QueryCatalogRequest.fromBuffer(value),
            ($1.QueryCatalogResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CatalogEntryKey, $1.CatalogEntry>(
        'GetCatalogEntry',
        getCatalogEntry_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CatalogEntryKey.fromBuffer(value),
        ($1.CatalogEntry value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.EmptyMessage, $1.CatalogDescriptionResponse>(
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
    $addMethod(
        $grpc.ServiceMethod<$0.EmptyMessage, $0.GetBluetoothNameResponse>(
            'GetBluetoothName',
            getBluetoothName_Pre,
            false,
            false,
            ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
            ($0.GetBluetoothNameResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetPairingModeRequest, $0.EmptyMessage>(
        'SetPairingMode',
        setPairingMode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetPairingModeRequest.fromBuffer(value),
        ($0.EmptyMessage value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.EmptyMessage, $0.GetBondedDevicesResponse>(
            'GetBondedDevices',
            getBondedDevices_Pre,
            false,
            false,
            ($core.List<$core.int> value) => $0.EmptyMessage.fromBuffer(value),
            ($0.GetBondedDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveBondRequest, $0.EmptyMessage>(
        'RemoveBond',
        removeBond_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveBondRequest.fromBuffer(value),
        ($0.EmptyMessage value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.CelestialCoord, $2.HorizonCoord>(
        'ConvertToHorizon',
        convertToHorizon_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.CelestialCoord.fromBuffer(value),
        ($2.HorizonCoord value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.HorizonCoord, $2.CelestialCoord>(
        'ConvertToCelestial',
        convertToCelestial_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.HorizonCoord.fromBuffer(value),
        ($2.CelestialCoord value) => value.writeToBuffer()));
  }

  $async.Future<$0.ServerLogResult> getServerLog_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ServerLogRequest> $request) async {
    return getServerLog($call, await $request);
  }

  $async.Future<$0.ServerLogResult> getServerLog(
      $grpc.ServiceCall call, $0.ServerLogRequest request);

  $async.Future<$0.CpuUsageReport> getCpuUsageReport_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getCpuUsageReport($call, await $request);
  }

  $async.Future<$0.CpuUsageReport> getCpuUsageReport(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$0.FixedSettings> updateFixedSettings_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FixedSettings> $request) async {
    return updateFixedSettings($call, await $request);
  }

  $async.Future<$0.FixedSettings> updateFixedSettings(
      $grpc.ServiceCall call, $0.FixedSettings request);

  $async.Future<$0.EmptyMessage> clearObserverLocation_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return clearObserverLocation($call, await $request);
  }

  $async.Future<$0.EmptyMessage> clearObserverLocation(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$0.OperationSettings> updateOperationSettings_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.OperationSettings> $request) async {
    return updateOperationSettings($call, await $request);
  }

  $async.Future<$0.OperationSettings> updateOperationSettings(
      $grpc.ServiceCall call, $0.OperationSettings request);

  $async.Future<$0.Preferences> updatePreferences_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Preferences> $request) async {
    return updatePreferences($call, await $request);
  }

  $async.Future<$0.Preferences> updatePreferences(
      $grpc.ServiceCall call, $0.Preferences request);

  $async.Future<$0.FrameResult> getFrame_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FrameRequest> $request) async {
    return getFrame($call, await $request);
  }

  $async.Future<$0.FrameResult> getFrame(
      $grpc.ServiceCall call, $0.FrameRequest request);

  $async.Stream<$0.FrameResult> getFrames_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FrameRequest> $request) async* {
    yield* getFrames($call, await $request);
  }

  $async.Stream<$0.FrameResult> getFrames(
      $grpc.ServiceCall call, $0.FrameRequest request);

  $async.Stream<$0.ImageResult> getImage_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ImageRequest> $request) async* {
    yield* getImage($call, await $request);
  }

  $async.Stream<$0.ImageResult> getImage(
      $grpc.ServiceCall call, $0.ImageRequest request);

  $async.Future<$0.EmptyMessage> initiateAction_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ActionRequest> $request) async {
    return initiateAction($call, await $request);
  }

  $async.Future<$0.EmptyMessage> initiateAction(
      $grpc.ServiceCall call, $0.ActionRequest request);

  $async.Future<$1.QueryCatalogResponse> queryCatalogEntries_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.QueryCatalogRequest> $request) async {
    return queryCatalogEntries($call, await $request);
  }

  $async.Future<$1.QueryCatalogResponse> queryCatalogEntries(
      $grpc.ServiceCall call, $1.QueryCatalogRequest request);

  $async.Future<$1.CatalogEntry> getCatalogEntry_Pre($grpc.ServiceCall $call,
      $async.Future<$1.CatalogEntryKey> $request) async {
    return getCatalogEntry($call, await $request);
  }

  $async.Future<$1.CatalogEntry> getCatalogEntry(
      $grpc.ServiceCall call, $1.CatalogEntryKey request);

  $async.Future<$1.CatalogDescriptionResponse> getCatalogDescriptions_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getCatalogDescriptions($call, await $request);
  }

  $async.Future<$1.CatalogDescriptionResponse> getCatalogDescriptions(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$1.ObjectTypeResponse> getObjectTypes_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getObjectTypes($call, await $request);
  }

  $async.Future<$1.ObjectTypeResponse> getObjectTypes(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$1.ConstellationResponse> getConstellations_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getConstellations($call, await $request);
  }

  $async.Future<$1.ConstellationResponse> getConstellations(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$0.GetBluetoothNameResponse> getBluetoothName_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getBluetoothName($call, await $request);
  }

  $async.Future<$0.GetBluetoothNameResponse> getBluetoothName(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$0.EmptyMessage> setPairingMode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetPairingModeRequest> $request) async {
    return setPairingMode($call, await $request);
  }

  $async.Future<$0.EmptyMessage> setPairingMode(
      $grpc.ServiceCall call, $0.SetPairingModeRequest request);

  $async.Future<$0.GetBondedDevicesResponse> getBondedDevices_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.EmptyMessage> $request) async {
    return getBondedDevices($call, await $request);
  }

  $async.Future<$0.GetBondedDevicesResponse> getBondedDevices(
      $grpc.ServiceCall call, $0.EmptyMessage request);

  $async.Future<$0.EmptyMessage> removeBond_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemoveBondRequest> $request) async {
    return removeBond($call, await $request);
  }

  $async.Future<$0.EmptyMessage> removeBond(
      $grpc.ServiceCall call, $0.RemoveBondRequest request);

  $async.Future<$2.HorizonCoord> convertToHorizon_Pre($grpc.ServiceCall $call,
      $async.Future<$2.CelestialCoord> $request) async {
    return convertToHorizon($call, await $request);
  }

  $async.Future<$2.HorizonCoord> convertToHorizon(
      $grpc.ServiceCall call, $2.CelestialCoord request);

  $async.Future<$2.CelestialCoord> convertToCelestial_Pre(
      $grpc.ServiceCall $call, $async.Future<$2.HorizonCoord> $request) async {
    return convertToCelestial($call, await $request);
  }

  $async.Future<$2.CelestialCoord> convertToCelestial(
      $grpc.ServiceCall call, $2.HorizonCoord request);
}
