//
//  Generated code. Do not modify.
//  source: cedar.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'cedar.pbenum.dart';
import 'cedar_common.pb.dart' as $4;
import 'cedar_sky.pb.dart' as $1;
import 'cedar_sky.pbenum.dart' as $1;
import 'google/protobuf/duration.pb.dart' as $3;
import 'google/protobuf/timestamp.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'cedar.pbenum.dart';

class ServerInformation extends $pb.GeneratedMessage {
  factory ServerInformation({
    $core.String? productName,
    $core.String? copyright,
    $core.String? cedarServerVersion,
    FeatureLevel? featureLevel,
    $core.String? processorModel,
    $core.String? osVersion,
    $core.double? cpuTemperature,
    $2.Timestamp? serverTime,
    CameraModel? camera,
    WiFiAccessPoint? wifiAccessPoint,
    $core.Iterable<$core.String>? demoImageNames,
    $core.String? serialNumber,
  }) {
    final $result = create();
    if (productName != null) {
      $result.productName = productName;
    }
    if (copyright != null) {
      $result.copyright = copyright;
    }
    if (cedarServerVersion != null) {
      $result.cedarServerVersion = cedarServerVersion;
    }
    if (featureLevel != null) {
      $result.featureLevel = featureLevel;
    }
    if (processorModel != null) {
      $result.processorModel = processorModel;
    }
    if (osVersion != null) {
      $result.osVersion = osVersion;
    }
    if (cpuTemperature != null) {
      $result.cpuTemperature = cpuTemperature;
    }
    if (serverTime != null) {
      $result.serverTime = serverTime;
    }
    if (camera != null) {
      $result.camera = camera;
    }
    if (wifiAccessPoint != null) {
      $result.wifiAccessPoint = wifiAccessPoint;
    }
    if (demoImageNames != null) {
      $result.demoImageNames.addAll(demoImageNames);
    }
    if (serialNumber != null) {
      $result.serialNumber = serialNumber;
    }
    return $result;
  }
  ServerInformation._() : super();
  factory ServerInformation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerInformation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerInformation', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'productName')
    ..aOS(2, _omitFieldNames ? '' : 'copyright')
    ..aOS(3, _omitFieldNames ? '' : 'cedarServerVersion')
    ..e<FeatureLevel>(4, _omitFieldNames ? '' : 'featureLevel', $pb.PbFieldType.OE, defaultOrMaker: FeatureLevel.FEATURE_LEVEL_UNSPECIFIED, valueOf: FeatureLevel.valueOf, enumValues: FeatureLevel.values)
    ..aOS(5, _omitFieldNames ? '' : 'processorModel')
    ..aOS(6, _omitFieldNames ? '' : 'osVersion')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'cpuTemperature', $pb.PbFieldType.OF)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'serverTime', subBuilder: $2.Timestamp.create)
    ..aOM<CameraModel>(9, _omitFieldNames ? '' : 'camera', subBuilder: CameraModel.create)
    ..aOM<WiFiAccessPoint>(10, _omitFieldNames ? '' : 'wifiAccessPoint', subBuilder: WiFiAccessPoint.create)
    ..pPS(11, _omitFieldNames ? '' : 'demoImageNames')
    ..aOS(12, _omitFieldNames ? '' : 'serialNumber')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerInformation clone() => ServerInformation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerInformation copyWith(void Function(ServerInformation) updates) => super.copyWith((message) => updates(message as ServerInformation)) as ServerInformation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerInformation create() => ServerInformation._();
  ServerInformation createEmptyInstance() => create();
  static $pb.PbList<ServerInformation> createRepeated() => $pb.PbList<ServerInformation>();
  @$core.pragma('dart2js:noInline')
  static ServerInformation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerInformation>(create);
  static ServerInformation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productName => $_getSZ(0);
  @$pb.TagNumber(1)
  set productName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProductName() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get copyright => $_getSZ(1);
  @$pb.TagNumber(2)
  set copyright($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCopyright() => $_has(1);
  @$pb.TagNumber(2)
  void clearCopyright() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cedarServerVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set cedarServerVersion($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCedarServerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearCedarServerVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  FeatureLevel get featureLevel => $_getN(3);
  @$pb.TagNumber(4)
  set featureLevel(FeatureLevel v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFeatureLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeatureLevel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get processorModel => $_getSZ(4);
  @$pb.TagNumber(5)
  set processorModel($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProcessorModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcessorModel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get osVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set osVersion($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOsVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearOsVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get cpuTemperature => $_getN(6);
  @$pb.TagNumber(7)
  set cpuTemperature($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCpuTemperature() => $_has(6);
  @$pb.TagNumber(7)
  void clearCpuTemperature() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get serverTime => $_getN(7);
  @$pb.TagNumber(8)
  set serverTime($2.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasServerTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearServerTime() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureServerTime() => $_ensure(7);

  /// Omitted if no camera detected.
  @$pb.TagNumber(9)
  CameraModel get camera => $_getN(8);
  @$pb.TagNumber(9)
  set camera(CameraModel v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCamera() => $_has(8);
  @$pb.TagNumber(9)
  void clearCamera() => $_clearField(9);
  @$pb.TagNumber(9)
  CameraModel ensureCamera() => $_ensure(8);

  /// Network info.
  @$pb.TagNumber(10)
  WiFiAccessPoint get wifiAccessPoint => $_getN(9);
  @$pb.TagNumber(10)
  set wifiAccessPoint(WiFiAccessPoint v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasWifiAccessPoint() => $_has(9);
  @$pb.TagNumber(10)
  void clearWifiAccessPoint() => $_clearField(10);
  @$pb.TagNumber(10)
  WiFiAccessPoint ensureWifiAccessPoint() => $_ensure(9);

  /// Filenames of image(s) found in run/demo_images directory.
  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get demoImageNames => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get serialNumber => $_getSZ(11);
  @$pb.TagNumber(12)
  set serialNumber($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSerialNumber() => $_has(11);
  @$pb.TagNumber(12)
  void clearSerialNumber() => $_clearField(12);
}

class CameraModel extends $pb.GeneratedMessage {
  factory CameraModel({
    $core.String? model,
    $core.int? imageWidth,
    $core.int? imageHeight,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    if (imageWidth != null) {
      $result.imageWidth = imageWidth;
    }
    if (imageHeight != null) {
      $result.imageHeight = imageHeight;
    }
    return $result;
  }
  CameraModel._() : super();
  factory CameraModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CameraModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CameraModel', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'imageWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'imageHeight', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CameraModel clone() => CameraModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CameraModel copyWith(void Function(CameraModel) updates) => super.copyWith((message) => updates(message as CameraModel)) as CameraModel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CameraModel create() => CameraModel._();
  CameraModel createEmptyInstance() => create();
  static $pb.PbList<CameraModel> createRepeated() => $pb.PbList<CameraModel>();
  @$core.pragma('dart2js:noInline')
  static CameraModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CameraModel>(create);
  static CameraModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get imageWidth => $_getIZ(1);
  @$pb.TagNumber(2)
  set imageWidth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasImageWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearImageWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get imageHeight => $_getIZ(2);
  @$pb.TagNumber(3)
  set imageHeight($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImageHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearImageHeight() => $_clearField(3);
}

/// Information about the WiFi access point that Cedar server puts
/// up.
class WiFiAccessPoint extends $pb.GeneratedMessage {
  factory WiFiAccessPoint({
    $core.String? ssid,
    $core.String? psk,
    $core.int? channel,
  }) {
    final $result = create();
    if (ssid != null) {
      $result.ssid = ssid;
    }
    if (psk != null) {
      $result.psk = psk;
    }
    if (channel != null) {
      $result.channel = channel;
    }
    return $result;
  }
  WiFiAccessPoint._() : super();
  factory WiFiAccessPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WiFiAccessPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WiFiAccessPoint', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ssid')
    ..aOS(2, _omitFieldNames ? '' : 'psk')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'channel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WiFiAccessPoint clone() => WiFiAccessPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WiFiAccessPoint copyWith(void Function(WiFiAccessPoint) updates) => super.copyWith((message) => updates(message as WiFiAccessPoint)) as WiFiAccessPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WiFiAccessPoint create() => WiFiAccessPoint._();
  WiFiAccessPoint createEmptyInstance() => create();
  static $pb.PbList<WiFiAccessPoint> createRepeated() => $pb.PbList<WiFiAccessPoint>();
  @$core.pragma('dart2js:noInline')
  static WiFiAccessPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WiFiAccessPoint>(create);
  static WiFiAccessPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ssid => $_getSZ(0);
  @$pb.TagNumber(1)
  set ssid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSsid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSsid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get psk => $_getSZ(1);
  @$pb.TagNumber(2)
  set psk($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPsk() => $_has(1);
  @$pb.TagNumber(2)
  void clearPsk() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get channel => $_getIZ(2);
  @$pb.TagNumber(3)
  set channel($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChannel() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannel() => $_clearField(3);
}

class FixedSettings extends $pb.GeneratedMessage {
  factory FixedSettings({
    LatLong? observerLocation,
    $2.Timestamp? currentTime,
    $core.String? sessionName,
    $3.Duration? maxExposureTime,
  }) {
    final $result = create();
    if (observerLocation != null) {
      $result.observerLocation = observerLocation;
    }
    if (currentTime != null) {
      $result.currentTime = currentTime;
    }
    if (sessionName != null) {
      $result.sessionName = sessionName;
    }
    if (maxExposureTime != null) {
      $result.maxExposureTime = maxExposureTime;
    }
    return $result;
  }
  FixedSettings._() : super();
  factory FixedSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FixedSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FixedSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<LatLong>(2, _omitFieldNames ? '' : 'observerLocation', subBuilder: LatLong.create)
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'currentTime', subBuilder: $2.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'sessionName')
    ..aOM<$3.Duration>(6, _omitFieldNames ? '' : 'maxExposureTime', subBuilder: $3.Duration.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FixedSettings clone() => FixedSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FixedSettings copyWith(void Function(FixedSettings) updates) => super.copyWith((message) => updates(message as FixedSettings)) as FixedSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FixedSettings create() => FixedSettings._();
  FixedSettings createEmptyInstance() => create();
  static $pb.PbList<FixedSettings> createRepeated() => $pb.PbList<FixedSettings>();
  @$core.pragma('dart2js:noInline')
  static FixedSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FixedSettings>(create);
  static FixedSettings? _defaultInstance;

  @$pb.TagNumber(2)
  LatLong get observerLocation => $_getN(0);
  @$pb.TagNumber(2)
  set observerLocation(LatLong v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasObserverLocation() => $_has(0);
  @$pb.TagNumber(2)
  void clearObserverLocation() => $_clearField(2);
  @$pb.TagNumber(2)
  LatLong ensureObserverLocation() => $_ensure(0);

  /// The current time (when setting, this is the client's time; when retrieving,
  /// this is the server's time). When setting, the server's current time is
  /// updated to match.
  @$pb.TagNumber(4)
  $2.Timestamp get currentTime => $_getN(1);
  @$pb.TagNumber(4)
  set currentTime($2.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentTime() => $_has(1);
  @$pb.TagNumber(4)
  void clearCurrentTime() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureCurrentTime() => $_ensure(1);

  /// The session name is used when storing boresight offset, when logging dwell
  /// positions, and when logging debugging captures (the latter should go
  /// elsewhere?).
  @$pb.TagNumber(5)
  $core.String get sessionName => $_getSZ(2);
  @$pb.TagNumber(5)
  set sessionName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasSessionName() => $_has(2);
  @$pb.TagNumber(5)
  void clearSessionName() => $_clearField(5);

  /// The configured maximum exposure time. Note that this cannot be changed via
  /// the UpdateFixedSettings() RPC.
  @$pb.TagNumber(6)
  $3.Duration get maxExposureTime => $_getN(3);
  @$pb.TagNumber(6)
  set maxExposureTime($3.Duration v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxExposureTime() => $_has(3);
  @$pb.TagNumber(6)
  void clearMaxExposureTime() => $_clearField(6);
  @$pb.TagNumber(6)
  $3.Duration ensureMaxExposureTime() => $_ensure(3);
}

class LatLong extends $pb.GeneratedMessage {
  factory LatLong({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }
  LatLong._() : super();
  factory LatLong.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LatLong.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LatLong', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LatLong clone() => LatLong()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LatLong copyWith(void Function(LatLong) updates) => super.copyWith((message) => updates(message as LatLong)) as LatLong;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatLong create() => LatLong._();
  LatLong createEmptyInstance() => create();
  static $pb.PbList<LatLong> createRepeated() => $pb.PbList<LatLong>();
  @$core.pragma('dart2js:noInline')
  static LatLong getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LatLong>(create);
  static LatLong? _defaultInstance;

  /// Degrees.
  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);
}

class OperationSettings extends $pb.GeneratedMessage {
  factory OperationSettings({
    $core.bool? daylightMode,
    OperatingMode? operatingMode,
    $3.Duration? updateInterval,
    $3.Duration? dwellUpdateInterval,
    $core.bool? logDwelledPositions,
    $1.CatalogEntryMatch? catalogEntryMatch,
    $core.String? demoImageFilename,
    $core.bool? focusAssistMode,
  }) {
    final $result = create();
    if (daylightMode != null) {
      $result.daylightMode = daylightMode;
    }
    if (operatingMode != null) {
      $result.operatingMode = operatingMode;
    }
    if (updateInterval != null) {
      $result.updateInterval = updateInterval;
    }
    if (dwellUpdateInterval != null) {
      $result.dwellUpdateInterval = dwellUpdateInterval;
    }
    if (logDwelledPositions != null) {
      $result.logDwelledPositions = logDwelledPositions;
    }
    if (catalogEntryMatch != null) {
      $result.catalogEntryMatch = catalogEntryMatch;
    }
    if (demoImageFilename != null) {
      $result.demoImageFilename = demoImageFilename;
    }
    if (focusAssistMode != null) {
      $result.focusAssistMode = focusAssistMode;
    }
    return $result;
  }
  OperationSettings._() : super();
  factory OperationSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OperationSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OperationSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'daylightMode')
    ..e<OperatingMode>(4, _omitFieldNames ? '' : 'operatingMode', $pb.PbFieldType.OE, defaultOrMaker: OperatingMode.MODE_UNSPECIFIED, valueOf: OperatingMode.valueOf, enumValues: OperatingMode.values)
    ..aOM<$3.Duration>(7, _omitFieldNames ? '' : 'updateInterval', subBuilder: $3.Duration.create)
    ..aOM<$3.Duration>(8, _omitFieldNames ? '' : 'dwellUpdateInterval', subBuilder: $3.Duration.create)
    ..aOB(10, _omitFieldNames ? '' : 'logDwelledPositions')
    ..aOM<$1.CatalogEntryMatch>(11, _omitFieldNames ? '' : 'catalogEntryMatch', subBuilder: $1.CatalogEntryMatch.create)
    ..aOS(12, _omitFieldNames ? '' : 'demoImageFilename')
    ..aOB(14, _omitFieldNames ? '' : 'focusAssistMode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OperationSettings clone() => OperationSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OperationSettings copyWith(void Function(OperationSettings) updates) => super.copyWith((message) => updates(message as OperationSettings)) as OperationSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationSettings create() => OperationSettings._();
  OperationSettings createEmptyInstance() => create();
  static $pb.PbList<OperationSettings> createRepeated() => $pb.PbList<OperationSettings>();
  @$core.pragma('dart2js:noInline')
  static OperationSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationSettings>(create);
  static OperationSettings? _defaultInstance;

  /// Relevant only in SETUP mode. Instead of trying to detect and plate solve
  /// stars (for boresight aligning), Cedar server instead exposes the image in a
  /// conventional photographic fashion and returns the non-stretched image for
  /// display at the client.
  /// ActionRequest.designate_boresight is then used to convey the user's
  /// identification of the image coordinate corresponding to the telescope's FOV
  /// center.
  @$pb.TagNumber(1)
  $core.bool get daylightMode => $_getBF(0);
  @$pb.TagNumber(1)
  set daylightMode($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDaylightMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaylightMode() => $_clearField(1);

  /// Defaults to SETUP mode.
  @$pb.TagNumber(4)
  OperatingMode get operatingMode => $_getN(1);
  @$pb.TagNumber(4)
  set operatingMode(OperatingMode v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasOperatingMode() => $_has(1);
  @$pb.TagNumber(4)
  void clearOperatingMode() => $_clearField(4);

  /// The desired time interval at which Cedar should replace its current frame
  /// result. Default is zero, meaning go as fast as possible. Ignored in SETUP
  /// mode.
  @$pb.TagNumber(7)
  $3.Duration get updateInterval => $_getN(2);
  @$pb.TagNumber(7)
  set updateInterval($3.Duration v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdateInterval() => $_has(2);
  @$pb.TagNumber(7)
  void clearUpdateInterval() => $_clearField(7);
  @$pb.TagNumber(7)
  $3.Duration ensureUpdateInterval() => $_ensure(2);

  /// In OPERATE mode, when Cedar detects that the camera is dwelling
  /// (motionless) for more than some number of seconds, `dwell_update_interval`
  /// is used instead of `update_interval`. Default is 1sec. Ignored in SETUP
  /// mode.
  @$pb.TagNumber(8)
  $3.Duration get dwellUpdateInterval => $_getN(3);
  @$pb.TagNumber(8)
  set dwellUpdateInterval($3.Duration v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasDwellUpdateInterval() => $_has(3);
  @$pb.TagNumber(8)
  void clearDwellUpdateInterval() => $_clearField(8);
  @$pb.TagNumber(8)
  $3.Duration ensureDwellUpdateInterval() => $_ensure(3);

  /// If true, when Cedar detects that the camera is dwelling (motionless) for
  /// more than some number of seconds, the RA/DEC is logged. Note that if the
  /// RA/DEC are changing during dwelling due to sidereal motion (non-tracked
  /// mount) or polar misalighment (tracked equatorial mount), only the RA/DEC
  /// at the onset of dwelling is logged.
  @$pb.TagNumber(10)
  $core.bool get logDwelledPositions => $_getBF(4);
  @$pb.TagNumber(10)
  set logDwelledPositions($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(10)
  $core.bool hasLogDwelledPositions() => $_has(4);
  @$pb.TagNumber(10)
  void clearLogDwelledPositions() => $_clearField(10);

  /// In OPERATE mode, if `catalog_entry_match` is present, this is used to
  /// determine the `catalog_entries` returned in each FrameResult. Only the
  /// `faintest_magnitude` is used; the catalog label and object type label
  /// filters are ignored.
  /// This field is also used to initialize the filter criteria in Cedar Aim's
  /// catalog panel. Note that in that context the catalog label and object
  /// type label filters are relevant.
  @$pb.TagNumber(11)
  $1.CatalogEntryMatch get catalogEntryMatch => $_getN(5);
  @$pb.TagNumber(11)
  set catalogEntryMatch($1.CatalogEntryMatch v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasCatalogEntryMatch() => $_has(5);
  @$pb.TagNumber(11)
  void clearCatalogEntryMatch() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.CatalogEntryMatch ensureCatalogEntryMatch() => $_ensure(5);

  /// Controls whether an image file is substituted for the camera. When calling
  /// UpdateOperationSettings(), set this field to empty string to cancel
  /// demo mode.
  @$pb.TagNumber(12)
  $core.String get demoImageFilename => $_getSZ(6);
  @$pb.TagNumber(12)
  set demoImageFilename($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(12)
  $core.bool hasDemoImageFilename() => $_has(6);
  @$pb.TagNumber(12)
  void clearDemoImageFilename() => $_clearField(12);

  /// Relevant only in SETUP mode. Instead of trying to detect and plate solve
  /// stars (for boresight aligning), Cedar server instead exposes the image for
  /// the brightest point in the image.
  @$pb.TagNumber(14)
  $core.bool get focusAssistMode => $_getBF(7);
  @$pb.TagNumber(14)
  set focusAssistMode($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(14)
  $core.bool hasFocusAssistMode() => $_has(7);
  @$pb.TagNumber(14)
  void clearFocusAssistMode() => $_clearField(14);
}

/// User interface preferences and operation settings that are stored durably on
/// the server.
class Preferences extends $pb.GeneratedMessage {
  factory Preferences({
    CelestialCoordFormat? celestialCoordFormat,
    $core.double? eyepieceFov,
    $core.bool? nightVisionTheme,
    $core.bool? hideAppBar,
    MountType? mountType,
    LatLong? observerLocation,
    $3.Duration? updateInterval,
    $1.CatalogEntryMatch? catalogEntryMatch,
    $core.double? maxDistance,
    $core.double? minElevation,
    $1.Ordering? ordering,
    $core.bool? maxDistanceActive,
    $core.bool? minElevationActive,
    $core.bool? advanced,
    $core.int? textSizeIndex,
    ImageCoord? boresightPixel,
    $core.bool? rightHanded,
    CelestialCoordChoice? celestialCoordChoice,
    $core.bool? screenAlwaysOn,
    $core.bool? dontShowWelcome,
    $core.bool? dontShowFocusIntro,
    $core.bool? dontShowAlignIntro,
    $core.bool? dontShowCalibrationFail,
    $core.bool? dontShowSetupFinished,
  }) {
    final $result = create();
    if (celestialCoordFormat != null) {
      $result.celestialCoordFormat = celestialCoordFormat;
    }
    if (eyepieceFov != null) {
      $result.eyepieceFov = eyepieceFov;
    }
    if (nightVisionTheme != null) {
      $result.nightVisionTheme = nightVisionTheme;
    }
    if (hideAppBar != null) {
      $result.hideAppBar = hideAppBar;
    }
    if (mountType != null) {
      $result.mountType = mountType;
    }
    if (observerLocation != null) {
      $result.observerLocation = observerLocation;
    }
    if (updateInterval != null) {
      $result.updateInterval = updateInterval;
    }
    if (catalogEntryMatch != null) {
      $result.catalogEntryMatch = catalogEntryMatch;
    }
    if (maxDistance != null) {
      $result.maxDistance = maxDistance;
    }
    if (minElevation != null) {
      $result.minElevation = minElevation;
    }
    if (ordering != null) {
      $result.ordering = ordering;
    }
    if (maxDistanceActive != null) {
      $result.maxDistanceActive = maxDistanceActive;
    }
    if (minElevationActive != null) {
      $result.minElevationActive = minElevationActive;
    }
    if (advanced != null) {
      $result.advanced = advanced;
    }
    if (textSizeIndex != null) {
      $result.textSizeIndex = textSizeIndex;
    }
    if (boresightPixel != null) {
      $result.boresightPixel = boresightPixel;
    }
    if (rightHanded != null) {
      $result.rightHanded = rightHanded;
    }
    if (celestialCoordChoice != null) {
      $result.celestialCoordChoice = celestialCoordChoice;
    }
    if (screenAlwaysOn != null) {
      $result.screenAlwaysOn = screenAlwaysOn;
    }
    if (dontShowWelcome != null) {
      $result.dontShowWelcome = dontShowWelcome;
    }
    if (dontShowFocusIntro != null) {
      $result.dontShowFocusIntro = dontShowFocusIntro;
    }
    if (dontShowAlignIntro != null) {
      $result.dontShowAlignIntro = dontShowAlignIntro;
    }
    if (dontShowCalibrationFail != null) {
      $result.dontShowCalibrationFail = dontShowCalibrationFail;
    }
    if (dontShowSetupFinished != null) {
      $result.dontShowSetupFinished = dontShowSetupFinished;
    }
    return $result;
  }
  Preferences._() : super();
  factory Preferences.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Preferences.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Preferences', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..e<CelestialCoordFormat>(1, _omitFieldNames ? '' : 'celestialCoordFormat', $pb.PbFieldType.OE, defaultOrMaker: CelestialCoordFormat.FORMAT_UNSPECIFIED, valueOf: CelestialCoordFormat.valueOf, enumValues: CelestialCoordFormat.values)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'eyepieceFov', $pb.PbFieldType.OD)
    ..aOB(3, _omitFieldNames ? '' : 'nightVisionTheme')
    ..aOB(5, _omitFieldNames ? '' : 'hideAppBar')
    ..e<MountType>(6, _omitFieldNames ? '' : 'mountType', $pb.PbFieldType.OE, defaultOrMaker: MountType.MOUNT_UNSPECIFIED, valueOf: MountType.valueOf, enumValues: MountType.values)
    ..aOM<LatLong>(7, _omitFieldNames ? '' : 'observerLocation', subBuilder: LatLong.create)
    ..aOM<$3.Duration>(9, _omitFieldNames ? '' : 'updateInterval', subBuilder: $3.Duration.create)
    ..aOM<$1.CatalogEntryMatch>(11, _omitFieldNames ? '' : 'catalogEntryMatch', subBuilder: $1.CatalogEntryMatch.create)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'maxDistance', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'minElevation', $pb.PbFieldType.OD)
    ..e<$1.Ordering>(14, _omitFieldNames ? '' : 'ordering', $pb.PbFieldType.OE, defaultOrMaker: $1.Ordering.UNSPECIFIED, valueOf: $1.Ordering.valueOf, enumValues: $1.Ordering.values)
    ..aOB(15, _omitFieldNames ? '' : 'maxDistanceActive')
    ..aOB(16, _omitFieldNames ? '' : 'minElevationActive')
    ..aOB(17, _omitFieldNames ? '' : 'advanced')
    ..a<$core.int>(18, _omitFieldNames ? '' : 'textSizeIndex', $pb.PbFieldType.O3)
    ..aOM<ImageCoord>(19, _omitFieldNames ? '' : 'boresightPixel', subBuilder: ImageCoord.create)
    ..aOB(21, _omitFieldNames ? '' : 'rightHanded')
    ..e<CelestialCoordChoice>(22, _omitFieldNames ? '' : 'celestialCoordChoice', $pb.PbFieldType.OE, defaultOrMaker: CelestialCoordChoice.CHOICE_UNSPECIFIED, valueOf: CelestialCoordChoice.valueOf, enumValues: CelestialCoordChoice.values)
    ..aOB(23, _omitFieldNames ? '' : 'screenAlwaysOn')
    ..aOB(24, _omitFieldNames ? '' : 'dontShowWelcome')
    ..aOB(25, _omitFieldNames ? '' : 'dontShowFocusIntro')
    ..aOB(26, _omitFieldNames ? '' : 'dontShowAlignIntro')
    ..aOB(27, _omitFieldNames ? '' : 'dontShowCalibrationFail')
    ..aOB(28, _omitFieldNames ? '' : 'dontShowSetupFinished')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Preferences clone() => Preferences()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Preferences copyWith(void Function(Preferences) updates) => super.copyWith((message) => updates(message as Preferences)) as Preferences;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Preferences create() => Preferences._();
  Preferences createEmptyInstance() => create();
  static $pb.PbList<Preferences> createRepeated() => $pb.PbList<Preferences>();
  @$core.pragma('dart2js:noInline')
  static Preferences getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Preferences>(create);
  static Preferences? _defaultInstance;

  /// How the user interface should display celestial coordinates.
  @$pb.TagNumber(1)
  CelestialCoordFormat get celestialCoordFormat => $_getN(0);
  @$pb.TagNumber(1)
  set celestialCoordFormat(CelestialCoordFormat v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCelestialCoordFormat() => $_has(0);
  @$pb.TagNumber(1)
  void clearCelestialCoordFormat() => $_clearField(1);

  /// Diameter (in degrees) of the boresight circle displayed in operation
  /// mode.
  @$pb.TagNumber(2)
  $core.double get eyepieceFov => $_getN(1);
  @$pb.TagNumber(2)
  set eyepieceFov($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEyepieceFov() => $_has(1);
  @$pb.TagNumber(2)
  void clearEyepieceFov() => $_clearField(2);

  /// If true, the UI should favor red highlights instead of white.
  @$pb.TagNumber(3)
  $core.bool get nightVisionTheme => $_getBF(2);
  @$pb.TagNumber(3)
  set nightVisionTheme($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNightVisionTheme() => $_has(2);
  @$pb.TagNumber(3)
  void clearNightVisionTheme() => $_clearField(3);

  /// If true, the UI app bar is hidden to allow full screen operation.
  @$pb.TagNumber(5)
  $core.bool get hideAppBar => $_getBF(3);
  @$pb.TagNumber(5)
  set hideAppBar($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasHideAppBar() => $_has(3);
  @$pb.TagNumber(5)
  void clearHideAppBar() => $_clearField(5);

  /// The kind of telescope mount. This influences the display of the boresight
  /// circle (cross aligned to north for EQUATORIAL or to zenith for ALT_AZ) and
  /// target slew direction instructions.
  @$pb.TagNumber(6)
  MountType get mountType => $_getN(4);
  @$pb.TagNumber(6)
  set mountType(MountType v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMountType() => $_has(4);
  @$pb.TagNumber(6)
  void clearMountType() => $_clearField(6);

  /// The saved location. On server startup we use this to initialize the
  /// corresponding FixedSettings field. Note: do not update this via
  /// UpdatePreferences().
  @$pb.TagNumber(7)
  LatLong get observerLocation => $_getN(5);
  @$pb.TagNumber(7)
  set observerLocation(LatLong v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasObserverLocation() => $_has(5);
  @$pb.TagNumber(7)
  void clearObserverLocation() => $_clearField(7);
  @$pb.TagNumber(7)
  LatLong ensureObserverLocation() => $_ensure(5);

  /// Saved dwell interval. On server startup we use this to initialize the
  /// corresponding OperationSettings field. Note: do not update this via
  /// UpdatePreferences().
  @$pb.TagNumber(9)
  $3.Duration get updateInterval => $_getN(6);
  @$pb.TagNumber(9)
  set updateInterval($3.Duration v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdateInterval() => $_has(6);
  @$pb.TagNumber(9)
  void clearUpdateInterval() => $_clearField(9);
  @$pb.TagNumber(9)
  $3.Duration ensureUpdateInterval() => $_ensure(6);

  /// Saved catalog object selection criteria for FOV image decoration. On server
  /// startup we use this to initialize the corresponding OperationSettings
  /// field. Note: do not update this via UpdatePreferences().
  @$pb.TagNumber(11)
  $1.CatalogEntryMatch get catalogEntryMatch => $_getN(7);
  @$pb.TagNumber(11)
  set catalogEntryMatch($1.CatalogEntryMatch v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasCatalogEntryMatch() => $_has(7);
  @$pb.TagNumber(11)
  void clearCatalogEntryMatch() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.CatalogEntryMatch ensureCatalogEntryMatch() => $_ensure(7);

  @$pb.TagNumber(12)
  $core.double get maxDistance => $_getN(8);
  @$pb.TagNumber(12)
  set maxDistance($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(12)
  $core.bool hasMaxDistance() => $_has(8);
  @$pb.TagNumber(12)
  void clearMaxDistance() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get minElevation => $_getN(9);
  @$pb.TagNumber(13)
  set minElevation($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(13)
  $core.bool hasMinElevation() => $_has(9);
  @$pb.TagNumber(13)
  void clearMinElevation() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Ordering get ordering => $_getN(10);
  @$pb.TagNumber(14)
  set ordering($1.Ordering v) { $_setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasOrdering() => $_has(10);
  @$pb.TagNumber(14)
  void clearOrdering() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get maxDistanceActive => $_getBF(11);
  @$pb.TagNumber(15)
  set maxDistanceActive($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(15)
  $core.bool hasMaxDistanceActive() => $_has(11);
  @$pb.TagNumber(15)
  void clearMaxDistanceActive() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get minElevationActive => $_getBF(12);
  @$pb.TagNumber(16)
  set minElevationActive($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(16)
  $core.bool hasMinElevationActive() => $_has(12);
  @$pb.TagNumber(16)
  void clearMinElevationActive() => $_clearField(16);

  /// Advanced mode vs. basic mode.
  @$pb.TagNumber(17)
  $core.bool get advanced => $_getBF(13);
  @$pb.TagNumber(17)
  set advanced($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(17)
  $core.bool hasAdvanced() => $_has(13);
  @$pb.TagNumber(17)
  void clearAdvanced() => $_clearField(17);

  /// 0: normal; -1: smaller; +1: bigger.
  @$pb.TagNumber(18)
  $core.int get textSizeIndex => $_getIZ(14);
  @$pb.TagNumber(18)
  set textSizeIndex($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(18)
  $core.bool hasTextSizeIndex() => $_has(14);
  @$pb.TagNumber(18)
  void clearTextSizeIndex() => $_clearField(18);

  /// Saved boresight position. On server startup we use this to initialize the
  /// internal state which appears at FrameResult.boresight_position. Note: do
  /// not update this via UpdatePreferences().
  @$pb.TagNumber(19)
  ImageCoord get boresightPixel => $_getN(15);
  @$pb.TagNumber(19)
  set boresightPixel(ImageCoord v) { $_setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasBoresightPixel() => $_has(15);
  @$pb.TagNumber(19)
  void clearBoresightPixel() => $_clearField(19);
  @$pb.TagNumber(19)
  ImageCoord ensureBoresightPixel() => $_ensure(15);

  /// Whether UI buttons and such are positioned on right side of screen.
  @$pb.TagNumber(21)
  $core.bool get rightHanded => $_getBF(16);
  @$pb.TagNumber(21)
  set rightHanded($core.bool v) { $_setBool(16, v); }
  @$pb.TagNumber(21)
  $core.bool hasRightHanded() => $_has(16);
  @$pb.TagNumber(21)
  void clearRightHanded() => $_clearField(21);

  /// Whether main display shows RA/Dec or Az/Alt.
  @$pb.TagNumber(22)
  CelestialCoordChoice get celestialCoordChoice => $_getN(17);
  @$pb.TagNumber(22)
  set celestialCoordChoice(CelestialCoordChoice v) { $_setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasCelestialCoordChoice() => $_has(17);
  @$pb.TagNumber(22)
  void clearCelestialCoordChoice() => $_clearField(22);

  /// Whether mobile screen is kept on while in Cedar Aim.
  @$pb.TagNumber(23)
  $core.bool get screenAlwaysOn => $_getBF(18);
  @$pb.TagNumber(23)
  set screenAlwaysOn($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(23)
  $core.bool hasScreenAlwaysOn() => $_has(18);
  @$pb.TagNumber(23)
  void clearScreenAlwaysOn() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.bool get dontShowWelcome => $_getBF(19);
  @$pb.TagNumber(24)
  set dontShowWelcome($core.bool v) { $_setBool(19, v); }
  @$pb.TagNumber(24)
  $core.bool hasDontShowWelcome() => $_has(19);
  @$pb.TagNumber(24)
  void clearDontShowWelcome() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.bool get dontShowFocusIntro => $_getBF(20);
  @$pb.TagNumber(25)
  set dontShowFocusIntro($core.bool v) { $_setBool(20, v); }
  @$pb.TagNumber(25)
  $core.bool hasDontShowFocusIntro() => $_has(20);
  @$pb.TagNumber(25)
  void clearDontShowFocusIntro() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.bool get dontShowAlignIntro => $_getBF(21);
  @$pb.TagNumber(26)
  set dontShowAlignIntro($core.bool v) { $_setBool(21, v); }
  @$pb.TagNumber(26)
  $core.bool hasDontShowAlignIntro() => $_has(21);
  @$pb.TagNumber(26)
  void clearDontShowAlignIntro() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.bool get dontShowCalibrationFail => $_getBF(22);
  @$pb.TagNumber(27)
  set dontShowCalibrationFail($core.bool v) { $_setBool(22, v); }
  @$pb.TagNumber(27)
  $core.bool hasDontShowCalibrationFail() => $_has(22);
  @$pb.TagNumber(27)
  void clearDontShowCalibrationFail() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.bool get dontShowSetupFinished => $_getBF(23);
  @$pb.TagNumber(28)
  set dontShowSetupFinished($core.bool v) { $_setBool(23, v); }
  @$pb.TagNumber(28)
  $core.bool hasDontShowSetupFinished() => $_has(23);
  @$pb.TagNumber(28)
  void clearDontShowSetupFinished() => $_clearField(28);
}

class FrameRequest extends $pb.GeneratedMessage {
  factory FrameRequest({
    $core.int? prevFrameId,
    $core.bool? nonBlocking,
    DisplayOrientation? displayOrientation,
  }) {
    final $result = create();
    if (prevFrameId != null) {
      $result.prevFrameId = prevFrameId;
    }
    if (nonBlocking != null) {
      $result.nonBlocking = nonBlocking;
    }
    if (displayOrientation != null) {
      $result.displayOrientation = displayOrientation;
    }
    return $result;
  }
  FrameRequest._() : super();
  factory FrameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FrameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FrameRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'prevFrameId', $pb.PbFieldType.O3)
    ..aOB(2, _omitFieldNames ? '' : 'nonBlocking')
    ..e<DisplayOrientation>(3, _omitFieldNames ? '' : 'displayOrientation', $pb.PbFieldType.OE, defaultOrMaker: DisplayOrientation.ORIENTATION_UNSPECIFIED, valueOf: DisplayOrientation.valueOf, enumValues: DisplayOrientation.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FrameRequest clone() => FrameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FrameRequest copyWith(void Function(FrameRequest) updates) => super.copyWith((message) => updates(message as FrameRequest)) as FrameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FrameRequest create() => FrameRequest._();
  FrameRequest createEmptyInstance() => create();
  static $pb.PbList<FrameRequest> createRepeated() => $pb.PbList<FrameRequest>();
  @$core.pragma('dart2js:noInline')
  static FrameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FrameRequest>(create);
  static FrameRequest? _defaultInstance;

  /// This is the frame_id of the previous FrameResult obtained by the requesting
  /// client. If provided, GetFrame() will block until this is no longer the
  /// server's current FrameResult. If omitted, GetFrame() will return the
  /// server's current FrameResult.
  @$pb.TagNumber(1)
  $core.int get prevFrameId => $_getIZ(0);
  @$pb.TagNumber(1)
  set prevFrameId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPrevFrameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrevFrameId() => $_clearField(1);

  /// If true, GetFrame() returns immediately. If the requested frame (a new frame
  /// different from 'prev_frame_id' or the current frame if 'prev_frame_id' is
  /// omitted) is available, the returned FrameResult.has_result field will be
  /// true.
  @$pb.TagNumber(2)
  $core.bool get nonBlocking => $_getBF(1);
  @$pb.TagNumber(2)
  set nonBlocking($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNonBlocking() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonBlocking() => $_clearField(2);

  /// In SETUP align mode, Cedar adjusts the returned image rotation so that the
  /// zenith is towards the top of the image. When doing so, the server needs to
  /// know the client's orientation for the displayed image.
  /// If omitted, LANDSCAPE is assumed.
  @$pb.TagNumber(3)
  DisplayOrientation get displayOrientation => $_getN(2);
  @$pb.TagNumber(3)
  set displayOrientation(DisplayOrientation v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDisplayOrientation() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayOrientation() => $_clearField(3);
}

/// Next tag: 35.
class FrameResult extends $pb.GeneratedMessage {
  factory FrameResult({
    $core.int? frameId,
    OperationSettings? operationSettings,
    Image? image,
    $core.Iterable<StarCentroid>? starCandidates,
    CalibrationData? calibrationData,
    $core.int? centerPeakValue,
    $3.Duration? exposureTime,
    ProcessingStats? processingStats,
    $2.Timestamp? captureTime,
    ImageCoord? centerPeakPosition,
    Image? centerPeakImage,
    PlateSolution? plateSolution,
    ImageCoord? boresightPosition,
    $core.bool? calibrating,
    $core.double? calibrationProgress,
    SlewRequest? slewRequest,
    Preferences? preferences,
    $core.double? noiseEstimate,
    FixedSettings? fixedSettings,
    Image? boresightImage,
    LocationBasedInfo? locationBasedInfo,
    PolarAlignAdvice? polarAlignAdvice,
    $core.Iterable<FovCatalogEntry>? labeledCatalogEntries,
    ServerInformation? serverInformation,
    $core.Iterable<FovCatalogEntry>? unlabeledCatalogEntries,
    $core.bool? hasResult,
  }) {
    final $result = create();
    if (frameId != null) {
      $result.frameId = frameId;
    }
    if (operationSettings != null) {
      $result.operationSettings = operationSettings;
    }
    if (image != null) {
      $result.image = image;
    }
    if (starCandidates != null) {
      $result.starCandidates.addAll(starCandidates);
    }
    if (calibrationData != null) {
      $result.calibrationData = calibrationData;
    }
    if (centerPeakValue != null) {
      $result.centerPeakValue = centerPeakValue;
    }
    if (exposureTime != null) {
      $result.exposureTime = exposureTime;
    }
    if (processingStats != null) {
      $result.processingStats = processingStats;
    }
    if (captureTime != null) {
      $result.captureTime = captureTime;
    }
    if (centerPeakPosition != null) {
      $result.centerPeakPosition = centerPeakPosition;
    }
    if (centerPeakImage != null) {
      $result.centerPeakImage = centerPeakImage;
    }
    if (plateSolution != null) {
      $result.plateSolution = plateSolution;
    }
    if (boresightPosition != null) {
      $result.boresightPosition = boresightPosition;
    }
    if (calibrating != null) {
      $result.calibrating = calibrating;
    }
    if (calibrationProgress != null) {
      $result.calibrationProgress = calibrationProgress;
    }
    if (slewRequest != null) {
      $result.slewRequest = slewRequest;
    }
    if (preferences != null) {
      $result.preferences = preferences;
    }
    if (noiseEstimate != null) {
      $result.noiseEstimate = noiseEstimate;
    }
    if (fixedSettings != null) {
      $result.fixedSettings = fixedSettings;
    }
    if (boresightImage != null) {
      $result.boresightImage = boresightImage;
    }
    if (locationBasedInfo != null) {
      $result.locationBasedInfo = locationBasedInfo;
    }
    if (polarAlignAdvice != null) {
      $result.polarAlignAdvice = polarAlignAdvice;
    }
    if (labeledCatalogEntries != null) {
      $result.labeledCatalogEntries.addAll(labeledCatalogEntries);
    }
    if (serverInformation != null) {
      $result.serverInformation = serverInformation;
    }
    if (unlabeledCatalogEntries != null) {
      $result.unlabeledCatalogEntries.addAll(unlabeledCatalogEntries);
    }
    if (hasResult != null) {
      $result.hasResult = hasResult;
    }
    return $result;
  }
  FrameResult._() : super();
  factory FrameResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FrameResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FrameResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'frameId', $pb.PbFieldType.O3)
    ..aOM<OperationSettings>(2, _omitFieldNames ? '' : 'operationSettings', subBuilder: OperationSettings.create)
    ..aOM<Image>(3, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..pc<StarCentroid>(4, _omitFieldNames ? '' : 'starCandidates', $pb.PbFieldType.PM, subBuilder: StarCentroid.create)
    ..aOM<CalibrationData>(5, _omitFieldNames ? '' : 'calibrationData', subBuilder: CalibrationData.create)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'centerPeakValue', $pb.PbFieldType.O3)
    ..aOM<$3.Duration>(7, _omitFieldNames ? '' : 'exposureTime', subBuilder: $3.Duration.create)
    ..aOM<ProcessingStats>(8, _omitFieldNames ? '' : 'processingStats', subBuilder: ProcessingStats.create)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'captureTime', subBuilder: $2.Timestamp.create)
    ..aOM<ImageCoord>(12, _omitFieldNames ? '' : 'centerPeakPosition', subBuilder: ImageCoord.create)
    ..aOM<Image>(13, _omitFieldNames ? '' : 'centerPeakImage', subBuilder: Image.create)
    ..aOM<PlateSolution>(17, _omitFieldNames ? '' : 'plateSolution', subBuilder: PlateSolution.create)
    ..aOM<ImageCoord>(21, _omitFieldNames ? '' : 'boresightPosition', subBuilder: ImageCoord.create)
    ..aOB(22, _omitFieldNames ? '' : 'calibrating')
    ..a<$core.double>(23, _omitFieldNames ? '' : 'calibrationProgress', $pb.PbFieldType.OD)
    ..aOM<SlewRequest>(24, _omitFieldNames ? '' : 'slewRequest', subBuilder: SlewRequest.create)
    ..aOM<Preferences>(25, _omitFieldNames ? '' : 'preferences', subBuilder: Preferences.create)
    ..a<$core.double>(26, _omitFieldNames ? '' : 'noiseEstimate', $pb.PbFieldType.OD)
    ..aOM<FixedSettings>(27, _omitFieldNames ? '' : 'fixedSettings', subBuilder: FixedSettings.create)
    ..aOM<Image>(28, _omitFieldNames ? '' : 'boresightImage', subBuilder: Image.create)
    ..aOM<LocationBasedInfo>(29, _omitFieldNames ? '' : 'locationBasedInfo', subBuilder: LocationBasedInfo.create)
    ..aOM<PolarAlignAdvice>(30, _omitFieldNames ? '' : 'polarAlignAdvice', subBuilder: PolarAlignAdvice.create)
    ..pc<FovCatalogEntry>(31, _omitFieldNames ? '' : 'labeledCatalogEntries', $pb.PbFieldType.PM, subBuilder: FovCatalogEntry.create)
    ..aOM<ServerInformation>(32, _omitFieldNames ? '' : 'serverInformation', subBuilder: ServerInformation.create)
    ..pc<FovCatalogEntry>(33, _omitFieldNames ? '' : 'unlabeledCatalogEntries', $pb.PbFieldType.PM, subBuilder: FovCatalogEntry.create)
    ..aOB(34, _omitFieldNames ? '' : 'hasResult')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FrameResult clone() => FrameResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FrameResult copyWith(void Function(FrameResult) updates) => super.copyWith((message) => updates(message as FrameResult)) as FrameResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FrameResult create() => FrameResult._();
  FrameResult createEmptyInstance() => create();
  static $pb.PbList<FrameResult> createRepeated() => $pb.PbList<FrameResult>();
  @$core.pragma('dart2js:noInline')
  static FrameResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FrameResult>(create);
  static FrameResult? _defaultInstance;

  /// Identifies this FrameResult. A client can include this in its next
  /// FrameRequest to block until a new FrameResult is available.
  @$pb.TagNumber(1)
  $core.int get frameId => $_getIZ(0);
  @$pb.TagNumber(1)
  set frameId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFrameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrameId() => $_clearField(1);

  /// The Cedar settings in effect for this frame.
  @$pb.TagNumber(2)
  OperationSettings get operationSettings => $_getN(1);
  @$pb.TagNumber(2)
  set operationSettings(OperationSettings v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOperationSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  OperationSettings ensureOperationSettings() => $_ensure(1);

  /// The image from which information in this FrameResult is derived. This image
  /// is from the entire sensor, typically with some amount of binning.
  /// Note that this image has stretch/gamma applied for better visibility of
  /// dark features (unless OperationSettings.daylight_mode is in effect, in
  /// which case a more natural rendering is used).
  @$pb.TagNumber(3)
  Image get image => $_getN(2);
  @$pb.TagNumber(3)
  set image(Image v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);
  @$pb.TagNumber(3)
  Image ensureImage() => $_ensure(2);

  /// The star candidates detected by CedarDetect; ordered by brightest
  /// first. In SETUP alignment mode, these are the catalog stars from
  /// the plate solution, with relative `brightness` values derived from
  /// the star catalog magnitudes.
  @$pb.TagNumber(4)
  $pb.PbList<StarCentroid> get starCandidates => $_getList(3);

  /// Calibration in effect for this frame.
  @$pb.TagNumber(5)
  CalibrationData get calibrationData => $_getN(4);
  @$pb.TagNumber(5)
  set calibrationData(CalibrationData v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCalibrationData() => $_has(4);
  @$pb.TagNumber(5)
  void clearCalibrationData() => $_clearField(5);
  @$pb.TagNumber(5)
  CalibrationData ensureCalibrationData() => $_ensure(4);

  /// The pixel value at the center_peak_position. Only present in
  /// `focus_assist_mode`.
  @$pb.TagNumber(6)
  $core.int get centerPeakValue => $_getIZ(5);
  @$pb.TagNumber(6)
  set centerPeakValue($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCenterPeakValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearCenterPeakValue() => $_clearField(6);

  /// The camera exposure integration time for `image`.
  @$pb.TagNumber(7)
  $3.Duration get exposureTime => $_getN(6);
  @$pb.TagNumber(7)
  set exposureTime($3.Duration v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasExposureTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearExposureTime() => $_clearField(7);
  @$pb.TagNumber(7)
  $3.Duration ensureExposureTime() => $_ensure(6);

  /// Information about Cedar's performance.
  @$pb.TagNumber(8)
  ProcessingStats get processingStats => $_getN(7);
  @$pb.TagNumber(8)
  set processingStats(ProcessingStats v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasProcessingStats() => $_has(7);
  @$pb.TagNumber(8)
  void clearProcessingStats() => $_clearField(8);
  @$pb.TagNumber(8)
  ProcessingStats ensureProcessingStats() => $_ensure(7);

  /// The time at which `image` was captured.
  @$pb.TagNumber(9)
  $2.Timestamp get captureTime => $_getN(8);
  @$pb.TagNumber(9)
  set captureTime($2.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCaptureTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearCaptureTime() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureCaptureTime() => $_ensure(8);

  /// This is the estimated position of the brightest point. In full resolution
  /// image coordinates. Only present in `focus_assist_mode`.
  @$pb.TagNumber(12)
  ImageCoord get centerPeakPosition => $_getN(9);
  @$pb.TagNumber(12)
  set centerPeakPosition(ImageCoord v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCenterPeakPosition() => $_has(9);
  @$pb.TagNumber(12)
  void clearCenterPeakPosition() => $_clearField(12);
  @$pb.TagNumber(12)
  ImageCoord ensureCenterPeakPosition() => $_ensure(9);

  /// A small full resolution (usually; 2x binned for color cameras) crop of
  /// `image` centered at `center_peak_position`. Note that this image has
  /// stretch/gamma applied for better visibility of dark features. Only present
  /// in `focus_assist_mode`.
  @$pb.TagNumber(13)
  Image get centerPeakImage => $_getN(10);
  @$pb.TagNumber(13)
  set centerPeakImage(Image v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasCenterPeakImage() => $_has(10);
  @$pb.TagNumber(13)
  void clearCenterPeakImage() => $_clearField(13);
  @$pb.TagNumber(13)
  Image ensureCenterPeakImage() => $_ensure(10);

  /// The current plate solution. Omitted if no plate solve was attempted for
  /// this frame. Relevant in OPERATE mode and in SETUP mode when neither
  /// `focus_assist_mode` nor `daylight_mode` is present.
  /// Omitted if plate solving was not attempted or did not result in a
  /// solution.
  @$pb.TagNumber(17)
  PlateSolution get plateSolution => $_getN(11);
  @$pb.TagNumber(17)
  set plateSolution(PlateSolution v) { $_setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasPlateSolution() => $_has(11);
  @$pb.TagNumber(17)
  void clearPlateSolution() => $_clearField(17);
  @$pb.TagNumber(17)
  PlateSolution ensurePlateSolution() => $_ensure(11);

  /// The position in full resolution image coordinates of the captured
  /// boresight. If no boresight has been captured, is the image center. See
  /// ActionRequest.capture_boresight and designate_boresight.
  @$pb.TagNumber(21)
  ImageCoord get boresightPosition => $_getN(12);
  @$pb.TagNumber(21)
  set boresightPosition(ImageCoord v) { $_setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasBoresightPosition() => $_has(12);
  @$pb.TagNumber(21)
  void clearBoresightPosition() => $_clearField(21);
  @$pb.TagNumber(21)
  ImageCoord ensureBoresightPosition() => $_ensure(12);

  /// When transitioning from SETUP focus mode to another mode, Cedar does a
  /// brief sky/camera calibration. During calibration most FrameResult fields
  /// are omitted. Fields present are: server_information, fixed_settings,
  /// preferences, operation_settings, image, calibrating, and
  /// calibration_progress.
  @$pb.TagNumber(22)
  $core.bool get calibrating => $_getBF(13);
  @$pb.TagNumber(22)
  set calibrating($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(22)
  $core.bool hasCalibrating() => $_has(13);
  @$pb.TagNumber(22)
  void clearCalibrating() => $_clearField(22);

  /// When `calibrating` is true, this field is an estimate of the progress of
  /// the calibration, which can take several seconds.
  @$pb.TagNumber(23)
  $core.double get calibrationProgress => $_getN(14);
  @$pb.TagNumber(23)
  set calibrationProgress($core.double v) { $_setDouble(14, v); }
  @$pb.TagNumber(23)
  $core.bool hasCalibrationProgress() => $_has(14);
  @$pb.TagNumber(23)
  void clearCalibrationProgress() => $_clearField(23);

  /// If present, SkySafari or Cedar Sky is requesting that the telescope's
  /// pointing should be changed.
  @$pb.TagNumber(24)
  SlewRequest get slewRequest => $_getN(15);
  @$pb.TagNumber(24)
  set slewRequest(SlewRequest v) { $_setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasSlewRequest() => $_has(15);
  @$pb.TagNumber(24)
  void clearSlewRequest() => $_clearField(24);
  @$pb.TagNumber(24)
  SlewRequest ensureSlewRequest() => $_ensure(15);

  /// The current user interface preferences stored on the server.
  @$pb.TagNumber(25)
  Preferences get preferences => $_getN(16);
  @$pb.TagNumber(25)
  set preferences(Preferences v) { $_setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasPreferences() => $_has(16);
  @$pb.TagNumber(25)
  void clearPreferences() => $_clearField(25);
  @$pb.TagNumber(25)
  Preferences ensurePreferences() => $_ensure(16);

  /// Estimate of the RMS noise of the full-resolution image. In 8 bit ADU
  /// units.
  @$pb.TagNumber(26)
  $core.double get noiseEstimate => $_getN(17);
  @$pb.TagNumber(26)
  set noiseEstimate($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(26)
  $core.bool hasNoiseEstimate() => $_has(17);
  @$pb.TagNumber(26)
  void clearNoiseEstimate() => $_clearField(26);

  /// The current FixedSettings on the server.
  @$pb.TagNumber(27)
  FixedSettings get fixedSettings => $_getN(18);
  @$pb.TagNumber(27)
  set fixedSettings(FixedSettings v) { $_setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasFixedSettings() => $_has(18);
  @$pb.TagNumber(27)
  void clearFixedSettings() => $_clearField(27);
  @$pb.TagNumber(27)
  FixedSettings ensureFixedSettings() => $_ensure(18);

  /// If the boresight is close to the slew target, the server returns a full
  /// resolution (usually; 2x binned for color cameras) crop of 'image' centered
  /// at the 'boresight_position'. Note that this image has stretch/gamma applied
  /// for better visibility of dark features.
  @$pb.TagNumber(28)
  Image get boresightImage => $_getN(19);
  @$pb.TagNumber(28)
  set boresightImage(Image v) { $_setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasBoresightImage() => $_has(19);
  @$pb.TagNumber(28)
  void clearBoresightImage() => $_clearField(28);
  @$pb.TagNumber(28)
  Image ensureBoresightImage() => $_ensure(19);

  /// When the observer's geographic location is known, the `plate_solution`
  /// field is augmented with additional information. Also returned in SETUP
  /// alignment mode.
  /// Omitted if:
  /// - no plate solution was obtained, or
  /// - FixedSettings.observer_location is absent.
  @$pb.TagNumber(29)
  LocationBasedInfo get locationBasedInfo => $_getN(20);
  @$pb.TagNumber(29)
  set locationBasedInfo(LocationBasedInfo v) { $_setField(29, v); }
  @$pb.TagNumber(29)
  $core.bool hasLocationBasedInfo() => $_has(20);
  @$pb.TagNumber(29)
  void clearLocationBasedInfo() => $_clearField(29);
  @$pb.TagNumber(29)
  LocationBasedInfo ensureLocationBasedInfo() => $_ensure(20);

  /// Contains information, if available, about adjusting the equatorial mount's
  /// polar axis alignment.
  @$pb.TagNumber(30)
  PolarAlignAdvice get polarAlignAdvice => $_getN(21);
  @$pb.TagNumber(30)
  set polarAlignAdvice(PolarAlignAdvice v) { $_setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasPolarAlignAdvice() => $_has(21);
  @$pb.TagNumber(30)
  void clearPolarAlignAdvice() => $_clearField(30);
  @$pb.TagNumber(30)
  PolarAlignAdvice ensurePolarAlignAdvice() => $_ensure(21);

  /// Lists the sky catalog entries that are present in the `plate_solution`
  /// field of view. The `catalog_entry_match` field in `operation_settings`
  /// determines what entries are included, except in SETUP alignment mode where
  /// fixed criteria are used (bright named stars and planets).
  /// Empty if `plate_solution` is absent or failed or if Cedar Sky is not
  /// present.
  /// The FOV catalog entries that dominate their crowd and should be labelled.
  @$pb.TagNumber(31)
  $pb.PbList<FovCatalogEntry> get labeledCatalogEntries => $_getList(22);

  /// Information about Cedar-server.
  @$pb.TagNumber(32)
  ServerInformation get serverInformation => $_getN(23);
  @$pb.TagNumber(32)
  set serverInformation(ServerInformation v) { $_setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasServerInformation() => $_has(23);
  @$pb.TagNumber(32)
  void clearServerInformation() => $_clearField(32);
  @$pb.TagNumber(32)
  ServerInformation ensureServerInformation() => $_ensure(23);

  /// The decrowded FOV catalog entries that the UI can display, but should
  /// not label to avoid clutter.
  @$pb.TagNumber(33)
  $pb.PbList<FovCatalogEntry> get unlabeledCatalogEntries => $_getList(24);

  /// If FrameRequest.non_blocking is omitted or false, this field will be
  /// absent. If FrameRequest.non_blocking is true, this field will be true
  /// if a suitable result is ready, otherwise this field will be false in
  /// which case all other FrameResult fields should be ignored (aside from
  /// 'server_information', which is always populated).
  @$pb.TagNumber(34)
  $core.bool get hasResult => $_getBF(25);
  @$pb.TagNumber(34)
  set hasResult($core.bool v) { $_setBool(25, v); }
  @$pb.TagNumber(34)
  $core.bool hasHasResult() => $_has(25);
  @$pb.TagNumber(34)
  void clearHasResult() => $_clearField(34);
}

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.int? binningFactor,
    Rectangle? rectangle,
    $core.List<$core.int>? imageData,
    $core.double? rotationSizeRatio,
  }) {
    final $result = create();
    if (binningFactor != null) {
      $result.binningFactor = binningFactor;
    }
    if (rectangle != null) {
      $result.rectangle = rectangle;
    }
    if (imageData != null) {
      $result.imageData = imageData;
    }
    if (rotationSizeRatio != null) {
      $result.rotationSizeRatio = rotationSizeRatio;
    }
    return $result;
  }
  Image._() : super();
  factory Image.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Image.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Image', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'binningFactor', $pb.PbFieldType.O3)
    ..aOM<Rectangle>(2, _omitFieldNames ? '' : 'rectangle', subBuilder: Rectangle.create)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'imageData', $pb.PbFieldType.OY)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'rotationSizeRatio', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Image clone() => Image()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Image copyWith(void Function(Image) updates) => super.copyWith((message) => updates(message as Image)) as Image;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  Image createEmptyInstance() => create();
  static $pb.PbList<Image> createRepeated() => $pb.PbList<Image>();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  /// Whether the image is binned/sampled or full resolution. Values:
  /// 1: full resolution image from camera sensor.
  /// 2: 2x lower resolution than camera sensor (in both x and y axes).
  /// 4: 4x lower resolution than camera sensor.
  /// 8: 8x lower resolution than camera sensor.
  @$pb.TagNumber(1)
  $core.int get binningFactor => $_getIZ(0);
  @$pb.TagNumber(1)
  set binningFactor($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBinningFactor() => $_has(0);
  @$pb.TagNumber(1)
  void clearBinningFactor() => $_clearField(1);

  /// Specifies what part of the camera sensor this Image corresponds to, in full
  /// resolution units. If binning_factor is B, the `image_data` dimensions are
  /// rectangle.width/B, rectangle.height/B (floored).
  @$pb.TagNumber(2)
  Rectangle get rectangle => $_getN(1);
  @$pb.TagNumber(2)
  set rectangle(Rectangle v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRectangle() => $_has(1);
  @$pb.TagNumber(2)
  void clearRectangle() => $_clearField(2);
  @$pb.TagNumber(2)
  Rectangle ensureRectangle() => $_ensure(1);

  /// Must be a recognized file format, e.g. BMP or JPEG grayscale 8 bits per pixel.
  @$pb.TagNumber(3)
  $core.List<$core.int> get imageData => $_getN(2);
  @$pb.TagNumber(3)
  set imageData($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImageData() => $_has(2);
  @$pb.TagNumber(3)
  void clearImageData() => $_clearField(3);

  /// If image was rotated for display, this is the degree by which the image
  /// was shrunk to fit. Always >= 1.0.
  @$pb.TagNumber(4)
  $core.double get rotationSizeRatio => $_getN(3);
  @$pb.TagNumber(4)
  set rotationSizeRatio($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRotationSizeRatio() => $_has(3);
  @$pb.TagNumber(4)
  void clearRotationSizeRatio() => $_clearField(4);
}

/// Describes the position/size of an region within the camera's sensor. In
/// full resolution units.
class Rectangle extends $pb.GeneratedMessage {
  factory Rectangle({
    $core.int? originX,
    $core.int? originY,
    $core.int? width,
    $core.int? height,
  }) {
    final $result = create();
    if (originX != null) {
      $result.originX = originX;
    }
    if (originY != null) {
      $result.originY = originY;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  Rectangle._() : super();
  factory Rectangle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Rectangle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Rectangle', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'originX', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'originY', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Rectangle clone() => Rectangle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Rectangle copyWith(void Function(Rectangle) updates) => super.copyWith((message) => updates(message as Rectangle)) as Rectangle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Rectangle create() => Rectangle._();
  Rectangle createEmptyInstance() => create();
  static $pb.PbList<Rectangle> createRepeated() => $pb.PbList<Rectangle>();
  @$core.pragma('dart2js:noInline')
  static Rectangle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rectangle>(create);
  static Rectangle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get originX => $_getIZ(0);
  @$pb.TagNumber(1)
  set originX($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOriginX() => $_has(0);
  @$pb.TagNumber(1)
  void clearOriginX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get originY => $_getIZ(1);
  @$pb.TagNumber(2)
  set originY($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOriginY() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);
}

/// Summarizes a star-like spot found by the CedarDetect algorithm.
class StarCentroid extends $pb.GeneratedMessage {
  factory StarCentroid({
    ImageCoord? centroidPosition,
    $core.double? brightness,
    $core.int? numSaturated,
  }) {
    final $result = create();
    if (centroidPosition != null) {
      $result.centroidPosition = centroidPosition;
    }
    if (brightness != null) {
      $result.brightness = brightness;
    }
    if (numSaturated != null) {
      $result.numSaturated = numSaturated;
    }
    return $result;
  }
  StarCentroid._() : super();
  factory StarCentroid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StarCentroid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StarCentroid', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<ImageCoord>(1, _omitFieldNames ? '' : 'centroidPosition', subBuilder: ImageCoord.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'brightness', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'numSaturated', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StarCentroid clone() => StarCentroid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StarCentroid copyWith(void Function(StarCentroid) updates) => super.copyWith((message) => updates(message as StarCentroid)) as StarCentroid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StarCentroid create() => StarCentroid._();
  StarCentroid createEmptyInstance() => create();
  static $pb.PbList<StarCentroid> createRepeated() => $pb.PbList<StarCentroid>();
  @$core.pragma('dart2js:noInline')
  static StarCentroid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StarCentroid>(create);
  static StarCentroid? _defaultInstance;

  /// Location of star centroid in full resolution image coordinates.
  @$pb.TagNumber(1)
  ImageCoord get centroidPosition => $_getN(0);
  @$pb.TagNumber(1)
  set centroidPosition(ImageCoord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCentroidPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCentroidPosition() => $_clearField(1);
  @$pb.TagNumber(1)
  ImageCoord ensureCentroidPosition() => $_ensure(0);

  /// Sum of the uint8 pixel values of the star's region. The estimated
  /// background is subtracted.
  @$pb.TagNumber(4)
  $core.double get brightness => $_getN(1);
  @$pb.TagNumber(4)
  set brightness($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasBrightness() => $_has(1);
  @$pb.TagNumber(4)
  void clearBrightness() => $_clearField(4);

  /// Count of saturated pixel values.
  @$pb.TagNumber(6)
  $core.int get numSaturated => $_getIZ(2);
  @$pb.TagNumber(6)
  set numSaturated($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(6)
  $core.bool hasNumSaturated() => $_has(2);
  @$pb.TagNumber(6)
  void clearNumSaturated() => $_clearField(6);
}

class ImageCoord extends $pb.GeneratedMessage {
  factory ImageCoord({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  ImageCoord._() : super();
  factory ImageCoord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageCoord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageCoord', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageCoord clone() => ImageCoord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageCoord copyWith(void Function(ImageCoord) updates) => super.copyWith((message) => updates(message as ImageCoord)) as ImageCoord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageCoord create() => ImageCoord._();
  ImageCoord createEmptyInstance() => create();
  static $pb.PbList<ImageCoord> createRepeated() => $pb.PbList<ImageCoord>();
  @$core.pragma('dart2js:noInline')
  static ImageCoord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageCoord>(create);
  static ImageCoord? _defaultInstance;

  /// A location in full resolution image coordinates. (0.5, 0.5) corresponds to
  /// the center of the image's upper left pixel.
  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

class PlateSolution extends $pb.GeneratedMessage {
  factory PlateSolution({
    $4.CelestialCoord? imageSkyCoord,
    $core.double? roll,
    $core.double? fov,
    $core.double? distortion,
    $core.double? rmse,
    $core.double? p90Error,
    $core.double? maxError,
    $core.int? numMatches,
    $core.double? prob,
    $core.int? epochEquinox,
    $core.double? epochProperMotion,
    $3.Duration? solveTime,
    $core.Iterable<$4.CelestialCoord>? targetSkyCoord,
    $core.Iterable<ImageCoord>? targetPixel,
    $core.Iterable<StarInfo>? matchedStars,
    $core.Iterable<ImageCoord>? patternCentroids,
    $core.Iterable<StarInfo>? catalogStars,
    $core.Iterable<$core.double>? rotationMatrix,
  }) {
    final $result = create();
    if (imageSkyCoord != null) {
      $result.imageSkyCoord = imageSkyCoord;
    }
    if (roll != null) {
      $result.roll = roll;
    }
    if (fov != null) {
      $result.fov = fov;
    }
    if (distortion != null) {
      $result.distortion = distortion;
    }
    if (rmse != null) {
      $result.rmse = rmse;
    }
    if (p90Error != null) {
      $result.p90Error = p90Error;
    }
    if (maxError != null) {
      $result.maxError = maxError;
    }
    if (numMatches != null) {
      $result.numMatches = numMatches;
    }
    if (prob != null) {
      $result.prob = prob;
    }
    if (epochEquinox != null) {
      $result.epochEquinox = epochEquinox;
    }
    if (epochProperMotion != null) {
      $result.epochProperMotion = epochProperMotion;
    }
    if (solveTime != null) {
      $result.solveTime = solveTime;
    }
    if (targetSkyCoord != null) {
      $result.targetSkyCoord.addAll(targetSkyCoord);
    }
    if (targetPixel != null) {
      $result.targetPixel.addAll(targetPixel);
    }
    if (matchedStars != null) {
      $result.matchedStars.addAll(matchedStars);
    }
    if (patternCentroids != null) {
      $result.patternCentroids.addAll(patternCentroids);
    }
    if (catalogStars != null) {
      $result.catalogStars.addAll(catalogStars);
    }
    if (rotationMatrix != null) {
      $result.rotationMatrix.addAll(rotationMatrix);
    }
    return $result;
  }
  PlateSolution._() : super();
  factory PlateSolution.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlateSolution.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlateSolution', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<$4.CelestialCoord>(1, _omitFieldNames ? '' : 'imageSkyCoord', subBuilder: $4.CelestialCoord.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'roll', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'fov', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'distortion', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'rmse', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'p90Error', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'maxError', $pb.PbFieldType.OD)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'numMatches', $pb.PbFieldType.O3)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'prob', $pb.PbFieldType.OD)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'epochEquinox', $pb.PbFieldType.O3)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'epochProperMotion', $pb.PbFieldType.OF)
    ..aOM<$3.Duration>(12, _omitFieldNames ? '' : 'solveTime', subBuilder: $3.Duration.create)
    ..pc<$4.CelestialCoord>(13, _omitFieldNames ? '' : 'targetSkyCoord', $pb.PbFieldType.PM, subBuilder: $4.CelestialCoord.create)
    ..pc<ImageCoord>(14, _omitFieldNames ? '' : 'targetPixel', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..pc<StarInfo>(15, _omitFieldNames ? '' : 'matchedStars', $pb.PbFieldType.PM, subBuilder: StarInfo.create)
    ..pc<ImageCoord>(16, _omitFieldNames ? '' : 'patternCentroids', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..pc<StarInfo>(17, _omitFieldNames ? '' : 'catalogStars', $pb.PbFieldType.PM, subBuilder: StarInfo.create)
    ..p<$core.double>(18, _omitFieldNames ? '' : 'rotationMatrix', $pb.PbFieldType.KD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlateSolution clone() => PlateSolution()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlateSolution copyWith(void Function(PlateSolution) updates) => super.copyWith((message) => updates(message as PlateSolution)) as PlateSolution;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlateSolution create() => PlateSolution._();
  PlateSolution createEmptyInstance() => create();
  static $pb.PbList<PlateSolution> createRepeated() => $pb.PbList<PlateSolution>();
  @$core.pragma('dart2js:noInline')
  static PlateSolution getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlateSolution>(create);
  static PlateSolution? _defaultInstance;

  /// See tetra3.py for descriptions of fields.
  @$pb.TagNumber(1)
  $4.CelestialCoord get imageSkyCoord => $_getN(0);
  @$pb.TagNumber(1)
  set imageSkyCoord($4.CelestialCoord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasImageSkyCoord() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageSkyCoord() => $_clearField(1);
  @$pb.TagNumber(1)
  $4.CelestialCoord ensureImageSkyCoord() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get roll => $_getN(1);
  @$pb.TagNumber(2)
  set roll($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoll() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoll() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get fov => $_getN(2);
  @$pb.TagNumber(3)
  set fov($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFov() => $_has(2);
  @$pb.TagNumber(3)
  void clearFov() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get distortion => $_getN(3);
  @$pb.TagNumber(4)
  set distortion($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDistortion() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistortion() => $_clearField(4);

  /// Arcseconds.
  @$pb.TagNumber(5)
  $core.double get rmse => $_getN(4);
  @$pb.TagNumber(5)
  set rmse($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRmse() => $_has(4);
  @$pb.TagNumber(5)
  void clearRmse() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get p90Error => $_getN(5);
  @$pb.TagNumber(6)
  set p90Error($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasP90Error() => $_has(5);
  @$pb.TagNumber(6)
  void clearP90Error() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxError => $_getN(6);
  @$pb.TagNumber(7)
  set maxError($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxError() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxError() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get numMatches => $_getIZ(7);
  @$pb.TagNumber(8)
  set numMatches($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasNumMatches() => $_has(7);
  @$pb.TagNumber(8)
  void clearNumMatches() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get prob => $_getN(8);
  @$pb.TagNumber(9)
  set prob($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProb() => $_has(8);
  @$pb.TagNumber(9)
  void clearProb() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get epochEquinox => $_getIZ(9);
  @$pb.TagNumber(10)
  set epochEquinox($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasEpochEquinox() => $_has(9);
  @$pb.TagNumber(10)
  void clearEpochEquinox() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get epochProperMotion => $_getN(10);
  @$pb.TagNumber(11)
  set epochProperMotion($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasEpochProperMotion() => $_has(10);
  @$pb.TagNumber(11)
  void clearEpochProperMotion() => $_clearField(11);

  @$pb.TagNumber(12)
  $3.Duration get solveTime => $_getN(11);
  @$pb.TagNumber(12)
  set solveTime($3.Duration v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasSolveTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearSolveTime() => $_clearField(12);
  @$pb.TagNumber(12)
  $3.Duration ensureSolveTime() => $_ensure(11);

  /// Result of SolveExtension.target_pixel.
  @$pb.TagNumber(13)
  $pb.PbList<$4.CelestialCoord> get targetSkyCoord => $_getList(12);

  /// Result of SolveExtension.target_sky_coord. (-1,-1) if sky target is not in
  /// image.
  @$pb.TagNumber(14)
  $pb.PbList<ImageCoord> get targetPixel => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<StarInfo> get matchedStars => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<ImageCoord> get patternCentroids => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<StarInfo> get catalogStars => $_getList(16);

  /// 3x3 matrix in row-major order.
  @$pb.TagNumber(18)
  $pb.PbList<$core.double> get rotationMatrix => $_getList(17);
}

class StarInfo extends $pb.GeneratedMessage {
  factory StarInfo({
    ImageCoord? pixel,
    $4.CelestialCoord? skyCoord,
    $core.double? mag,
  }) {
    final $result = create();
    if (pixel != null) {
      $result.pixel = pixel;
    }
    if (skyCoord != null) {
      $result.skyCoord = skyCoord;
    }
    if (mag != null) {
      $result.mag = mag;
    }
    return $result;
  }
  StarInfo._() : super();
  factory StarInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StarInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StarInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<ImageCoord>(1, _omitFieldNames ? '' : 'pixel', subBuilder: ImageCoord.create)
    ..aOM<$4.CelestialCoord>(2, _omitFieldNames ? '' : 'skyCoord', subBuilder: $4.CelestialCoord.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'mag', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StarInfo clone() => StarInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StarInfo copyWith(void Function(StarInfo) updates) => super.copyWith((message) => updates(message as StarInfo)) as StarInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StarInfo create() => StarInfo._();
  StarInfo createEmptyInstance() => create();
  static $pb.PbList<StarInfo> createRepeated() => $pb.PbList<StarInfo>();
  @$core.pragma('dart2js:noInline')
  static StarInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StarInfo>(create);
  static StarInfo? _defaultInstance;

  @$pb.TagNumber(1)
  ImageCoord get pixel => $_getN(0);
  @$pb.TagNumber(1)
  set pixel(ImageCoord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPixel() => $_has(0);
  @$pb.TagNumber(1)
  void clearPixel() => $_clearField(1);
  @$pb.TagNumber(1)
  ImageCoord ensurePixel() => $_ensure(0);

  @$pb.TagNumber(2)
  $4.CelestialCoord get skyCoord => $_getN(1);
  @$pb.TagNumber(2)
  set skyCoord($4.CelestialCoord v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSkyCoord() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkyCoord() => $_clearField(2);
  @$pb.TagNumber(2)
  $4.CelestialCoord ensureSkyCoord() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get mag => $_getN(2);
  @$pb.TagNumber(3)
  set mag($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMag() => $_has(2);
  @$pb.TagNumber(3)
  void clearMag() => $_clearField(3);
}

/// Diagnostic information summarizing Cedar's performance.
class ProcessingStats extends $pb.GeneratedMessage {
  factory ProcessingStats({
    ValueStats? overallLatency,
    ValueStats? detectLatency,
    ValueStats? solveLatency,
    ValueStats? solveAttemptFraction,
    ValueStats? solveSuccessFraction,
    ValueStats? serveLatency,
  }) {
    final $result = create();
    if (overallLatency != null) {
      $result.overallLatency = overallLatency;
    }
    if (detectLatency != null) {
      $result.detectLatency = detectLatency;
    }
    if (solveLatency != null) {
      $result.solveLatency = solveLatency;
    }
    if (solveAttemptFraction != null) {
      $result.solveAttemptFraction = solveAttemptFraction;
    }
    if (solveSuccessFraction != null) {
      $result.solveSuccessFraction = solveSuccessFraction;
    }
    if (serveLatency != null) {
      $result.serveLatency = serveLatency;
    }
    return $result;
  }
  ProcessingStats._() : super();
  factory ProcessingStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProcessingStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProcessingStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<ValueStats>(2, _omitFieldNames ? '' : 'overallLatency', subBuilder: ValueStats.create)
    ..aOM<ValueStats>(3, _omitFieldNames ? '' : 'detectLatency', subBuilder: ValueStats.create)
    ..aOM<ValueStats>(4, _omitFieldNames ? '' : 'solveLatency', subBuilder: ValueStats.create)
    ..aOM<ValueStats>(5, _omitFieldNames ? '' : 'solveAttemptFraction', subBuilder: ValueStats.create)
    ..aOM<ValueStats>(6, _omitFieldNames ? '' : 'solveSuccessFraction', subBuilder: ValueStats.create)
    ..aOM<ValueStats>(7, _omitFieldNames ? '' : 'serveLatency', subBuilder: ValueStats.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProcessingStats clone() => ProcessingStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProcessingStats copyWith(void Function(ProcessingStats) updates) => super.copyWith((message) => updates(message as ProcessingStats)) as ProcessingStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProcessingStats create() => ProcessingStats._();
  ProcessingStats createEmptyInstance() => create();
  static $pb.PbList<ProcessingStats> createRepeated() => $pb.PbList<ProcessingStats>();
  @$core.pragma('dart2js:noInline')
  static ProcessingStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProcessingStats>(create);
  static ProcessingStats? _defaultInstance;

  /// Elapsed time (in seconds) between acquisition of an image (end of exposure)
  /// and completion of a plate solution for it. Skipped images (i.e. solution
  /// not attempted) do not contribute to this.
  @$pb.TagNumber(2)
  ValueStats get overallLatency => $_getN(0);
  @$pb.TagNumber(2)
  set overallLatency(ValueStats v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOverallLatency() => $_has(0);
  @$pb.TagNumber(2)
  void clearOverallLatency() => $_clearField(2);
  @$pb.TagNumber(2)
  ValueStats ensureOverallLatency() => $_ensure(0);

  /// How much time (in seconds) is spent detecting/centroiding stars.
  @$pb.TagNumber(3)
  ValueStats get detectLatency => $_getN(1);
  @$pb.TagNumber(3)
  set detectLatency(ValueStats v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDetectLatency() => $_has(1);
  @$pb.TagNumber(3)
  void clearDetectLatency() => $_clearField(3);
  @$pb.TagNumber(3)
  ValueStats ensureDetectLatency() => $_ensure(1);

  /// How much time (in seconds) is spent plate solving (when attempted).
  @$pb.TagNumber(4)
  ValueStats get solveLatency => $_getN(2);
  @$pb.TagNumber(4)
  set solveLatency(ValueStats v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSolveLatency() => $_has(2);
  @$pb.TagNumber(4)
  void clearSolveLatency() => $_clearField(4);
  @$pb.TagNumber(4)
  ValueStats ensureSolveLatency() => $_ensure(2);

  /// The fraction of images on which a plate solution is attempted. If too few
  /// stars are detected we skip solving. Only the 'mean' is meaningful.
  @$pb.TagNumber(5)
  ValueStats get solveAttemptFraction => $_getN(3);
  @$pb.TagNumber(5)
  set solveAttemptFraction(ValueStats v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSolveAttemptFraction() => $_has(3);
  @$pb.TagNumber(5)
  void clearSolveAttemptFraction() => $_clearField(5);
  @$pb.TagNumber(5)
  ValueStats ensureSolveAttemptFraction() => $_ensure(3);

  /// The fraction of plate solve attempts that succeed. Only the 'mean' is
  /// meaningful.
  @$pb.TagNumber(6)
  ValueStats get solveSuccessFraction => $_getN(4);
  @$pb.TagNumber(6)
  set solveSuccessFraction(ValueStats v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSolveSuccessFraction() => $_has(4);
  @$pb.TagNumber(6)
  void clearSolveSuccessFraction() => $_clearField(6);
  @$pb.TagNumber(6)
  ValueStats ensureSolveSuccessFraction() => $_ensure(4);

  /// How much time (in seconds) is spent preparing the FrameResult to be
  /// returned. This includes time spent e.g. applying gamma to the display
  /// image.
  @$pb.TagNumber(7)
  ValueStats get serveLatency => $_getN(5);
  @$pb.TagNumber(7)
  set serveLatency(ValueStats v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasServeLatency() => $_has(5);
  @$pb.TagNumber(7)
  void clearServeLatency() => $_clearField(7);
  @$pb.TagNumber(7)
  ValueStats ensureServeLatency() => $_ensure(5);
}

class ValueStats extends $pb.GeneratedMessage {
  factory ValueStats({
    DescriptiveStats? recent,
    DescriptiveStats? session,
  }) {
    final $result = create();
    if (recent != null) {
      $result.recent = recent;
    }
    if (session != null) {
      $result.session = session;
    }
    return $result;
  }
  ValueStats._() : super();
  factory ValueStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValueStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValueStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<DescriptiveStats>(1, _omitFieldNames ? '' : 'recent', subBuilder: DescriptiveStats.create)
    ..aOM<DescriptiveStats>(2, _omitFieldNames ? '' : 'session', subBuilder: DescriptiveStats.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValueStats clone() => ValueStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValueStats copyWith(void Function(ValueStats) updates) => super.copyWith((message) => updates(message as ValueStats)) as ValueStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValueStats create() => ValueStats._();
  ValueStats createEmptyInstance() => create();
  static $pb.PbList<ValueStats> createRepeated() => $pb.PbList<ValueStats>();
  @$core.pragma('dart2js:noInline')
  static ValueStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValueStats>(create);
  static ValueStats? _defaultInstance;

  /// Stats from the most recent 100 results. Omitted if there are no results
  /// yet.
  @$pb.TagNumber(1)
  DescriptiveStats get recent => $_getN(0);
  @$pb.TagNumber(1)
  set recent(DescriptiveStats v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecent() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecent() => $_clearField(1);
  @$pb.TagNumber(1)
  DescriptiveStats ensureRecent() => $_ensure(0);

  /// Stats from the beginning of the session, or since the last transition
  /// from SETUP mode to OPERATE mode.
  /// Omitted if there are no results since session start or reset.
  @$pb.TagNumber(2)
  DescriptiveStats get session => $_getN(1);
  @$pb.TagNumber(2)
  set session(DescriptiveStats v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearSession() => $_clearField(2);
  @$pb.TagNumber(2)
  DescriptiveStats ensureSession() => $_ensure(1);
}

/// See each item in ProcessingStats for units.
class DescriptiveStats extends $pb.GeneratedMessage {
  factory DescriptiveStats({
    $core.double? min,
    $core.double? max,
    $core.double? mean,
    $core.double? stddev,
    $core.double? median,
    $core.double? medianAbsoluteDeviation,
  }) {
    final $result = create();
    if (min != null) {
      $result.min = min;
    }
    if (max != null) {
      $result.max = max;
    }
    if (mean != null) {
      $result.mean = mean;
    }
    if (stddev != null) {
      $result.stddev = stddev;
    }
    if (median != null) {
      $result.median = median;
    }
    if (medianAbsoluteDeviation != null) {
      $result.medianAbsoluteDeviation = medianAbsoluteDeviation;
    }
    return $result;
  }
  DescriptiveStats._() : super();
  factory DescriptiveStats.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DescriptiveStats.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DescriptiveStats', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'mean', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'stddev', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'median', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'medianAbsoluteDeviation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DescriptiveStats clone() => DescriptiveStats()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DescriptiveStats copyWith(void Function(DescriptiveStats) updates) => super.copyWith((message) => updates(message as DescriptiveStats)) as DescriptiveStats;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DescriptiveStats create() => DescriptiveStats._();
  DescriptiveStats createEmptyInstance() => create();
  static $pb.PbList<DescriptiveStats> createRepeated() => $pb.PbList<DescriptiveStats>();
  @$core.pragma('dart2js:noInline')
  static DescriptiveStats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DescriptiveStats>(create);
  static DescriptiveStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get mean => $_getN(2);
  @$pb.TagNumber(3)
  set mean($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMean() => $_has(2);
  @$pb.TagNumber(3)
  void clearMean() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get stddev => $_getN(3);
  @$pb.TagNumber(4)
  set stddev($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStddev() => $_has(3);
  @$pb.TagNumber(4)
  void clearStddev() => $_clearField(4);

  /// Omitted for `session` stats.
  @$pb.TagNumber(5)
  $core.double get median => $_getN(4);
  @$pb.TagNumber(5)
  set median($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMedian() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedian() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get medianAbsoluteDeviation => $_getN(5);
  @$pb.TagNumber(6)
  set medianAbsoluteDeviation($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMedianAbsoluteDeviation() => $_has(5);
  @$pb.TagNumber(6)
  void clearMedianAbsoluteDeviation() => $_clearField(6);
}

class CalibrationData extends $pb.GeneratedMessage {
  factory CalibrationData({
    $2.Timestamp? calibrationTime,
    $3.Duration? targetExposureTime,
    $core.int? cameraOffset,
    $core.double? fovHorizontal,
    $core.double? lensDistortion,
    $core.double? lensFlMm,
    $core.double? pixelAngularSize,
    $core.double? matchMaxError,
    $core.bool? exposureCalibrationFailed,
    $core.bool? plateSolveFailed,
  }) {
    final $result = create();
    if (calibrationTime != null) {
      $result.calibrationTime = calibrationTime;
    }
    if (targetExposureTime != null) {
      $result.targetExposureTime = targetExposureTime;
    }
    if (cameraOffset != null) {
      $result.cameraOffset = cameraOffset;
    }
    if (fovHorizontal != null) {
      $result.fovHorizontal = fovHorizontal;
    }
    if (lensDistortion != null) {
      $result.lensDistortion = lensDistortion;
    }
    if (lensFlMm != null) {
      $result.lensFlMm = lensFlMm;
    }
    if (pixelAngularSize != null) {
      $result.pixelAngularSize = pixelAngularSize;
    }
    if (matchMaxError != null) {
      $result.matchMaxError = matchMaxError;
    }
    if (exposureCalibrationFailed != null) {
      $result.exposureCalibrationFailed = exposureCalibrationFailed;
    }
    if (plateSolveFailed != null) {
      $result.plateSolveFailed = plateSolveFailed;
    }
    return $result;
  }
  CalibrationData._() : super();
  factory CalibrationData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalibrationData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalibrationData', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<$2.Timestamp>(1, _omitFieldNames ? '' : 'calibrationTime', subBuilder: $2.Timestamp.create)
    ..aOM<$3.Duration>(2, _omitFieldNames ? '' : 'targetExposureTime', subBuilder: $3.Duration.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'cameraOffset', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'fovHorizontal', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'lensDistortion', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'lensFlMm', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'pixelAngularSize', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'matchMaxError', $pb.PbFieldType.OD)
    ..aOB(9, _omitFieldNames ? '' : 'exposureCalibrationFailed')
    ..aOB(10, _omitFieldNames ? '' : 'plateSolveFailed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalibrationData clone() => CalibrationData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalibrationData copyWith(void Function(CalibrationData) updates) => super.copyWith((message) => updates(message as CalibrationData)) as CalibrationData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalibrationData create() => CalibrationData._();
  CalibrationData createEmptyInstance() => create();
  static $pb.PbList<CalibrationData> createRepeated() => $pb.PbList<CalibrationData>();
  @$core.pragma('dart2js:noInline')
  static CalibrationData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalibrationData>(create);
  static CalibrationData? _defaultInstance;

  /// Omitted if a sky/camera calibration has not been attempted.
  @$pb.TagNumber(1)
  $2.Timestamp get calibrationTime => $_getN(0);
  @$pb.TagNumber(1)
  set calibrationTime($2.Timestamp v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCalibrationTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearCalibrationTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Timestamp ensureCalibrationTime() => $_ensure(0);

  /// Exposure time determined to yield the desired number of star detections
  /// during calibration.
  /// Operation mode varies the exposure duration around this value based on
  /// the current detected star count.
  /// If no calibration has succeeded, this will have reasonable default value
  /// based on setup mode's auto exposure.
  @$pb.TagNumber(2)
  $3.Duration get targetExposureTime => $_getN(1);
  @$pb.TagNumber(2)
  set targetExposureTime($3.Duration v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetExposureTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetExposureTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.Duration ensureTargetExposureTime() => $_ensure(1);

  /// The camera offset value [0..20] found to be needed to avoid black crush.
  /// Omitted if a sky/camera calibration has not succeeded.
  @$pb.TagNumber(3)
  $core.int get cameraOffset => $_getIZ(2);
  @$pb.TagNumber(3)
  set cameraOffset($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCameraOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearCameraOffset() => $_clearField(3);

  /// The angular size (degrees) of the camera's width (longer dimension)
  /// projected onto the sky.
  /// Omitted if a sky/camera calibration has not succeeded.
  @$pb.TagNumber(4)
  $core.double get fovHorizontal => $_getN(3);
  @$pb.TagNumber(4)
  set fovHorizontal($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFovHorizontal() => $_has(3);
  @$pb.TagNumber(4)
  void clearFovHorizontal() => $_clearField(4);

  /// The plate solver's estimate of the lens distortion (pincushion or barrel).
  /// Omitted if a sky/camera calibration has not succeeded.
  @$pb.TagNumber(5)
  $core.double get lensDistortion => $_getN(4);
  @$pb.TagNumber(5)
  set lensDistortion($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLensDistortion() => $_has(4);
  @$pb.TagNumber(5)
  void clearLensDistortion() => $_clearField(5);

  /// The lens focal length in millimeters, derived from `fov_horizontal`
  /// together with the camera's sensor's physical size.
  /// Omitted if a sky/camera calibration has not succeeded.
  @$pb.TagNumber(6)
  $core.double get lensFlMm => $_getN(5);
  @$pb.TagNumber(6)
  set lensFlMm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLensFlMm() => $_has(5);
  @$pb.TagNumber(6)
  void clearLensFlMm() => $_clearField(6);

  /// The angular size of a pixel, in degrees. This is for the field center, as
  /// the "pinhole" projection of sky angles onto a planar detector causes the
  /// pixel/angle scale to vary as you move away from the center.
  /// Omitted if a sky/camera calibration has not succeeded.
  @$pb.TagNumber(7)
  $core.double get pixelAngularSize => $_getN(6);
  @$pb.TagNumber(7)
  set pixelAngularSize($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPixelAngularSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPixelAngularSize() => $_clearField(7);

  /// The 'match_max_error' value that we pass to the plate solver.
  @$pb.TagNumber(8)
  $core.double get matchMaxError => $_getN(7);
  @$pb.TagNumber(8)
  set matchMaxError($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMatchMaxError() => $_has(7);
  @$pb.TagNumber(8)
  void clearMatchMaxError() => $_clearField(8);

  /// Indicates reason, if any, that the calibration failed.
  @$pb.TagNumber(9)
  $core.bool get exposureCalibrationFailed => $_getBF(8);
  @$pb.TagNumber(9)
  set exposureCalibrationFailed($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasExposureCalibrationFailed() => $_has(8);
  @$pb.TagNumber(9)
  void clearExposureCalibrationFailed() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get plateSolveFailed => $_getBF(9);
  @$pb.TagNumber(10)
  set plateSolveFailed($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPlateSolveFailed() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlateSolveFailed() => $_clearField(10);
}

/// When the observer's geographic location is known, the
/// FrameResult.plate_solution field is augmented with additional information.
class LocationBasedInfo extends $pb.GeneratedMessage {
  factory LocationBasedInfo({
    $core.double? zenithRollAngle,
    $core.double? altitude,
    $core.double? azimuth,
    $core.double? hourAngle,
  }) {
    final $result = create();
    if (zenithRollAngle != null) {
      $result.zenithRollAngle = zenithRollAngle;
    }
    if (altitude != null) {
      $result.altitude = altitude;
    }
    if (azimuth != null) {
      $result.azimuth = azimuth;
    }
    if (hourAngle != null) {
      $result.hourAngle = hourAngle;
    }
    return $result;
  }
  LocationBasedInfo._() : super();
  factory LocationBasedInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LocationBasedInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LocationBasedInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'zenithRollAngle', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'altitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'hourAngle', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LocationBasedInfo clone() => LocationBasedInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LocationBasedInfo copyWith(void Function(LocationBasedInfo) updates) => super.copyWith((message) => updates(message as LocationBasedInfo)) as LocationBasedInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocationBasedInfo create() => LocationBasedInfo._();
  LocationBasedInfo createEmptyInstance() => create();
  static $pb.PbList<LocationBasedInfo> createRepeated() => $pb.PbList<LocationBasedInfo>();
  @$core.pragma('dart2js:noInline')
  static LocationBasedInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocationBasedInfo>(create);
  static LocationBasedInfo? _defaultInstance;

  /// Similar to SolveResult.roll, except gives the position angle of the zenith
  /// relative to the boresight. Angle is measured in degrees, with zero being
  /// the image's "up" direction (towards y=0); a positive zenith roll angle
  /// means the zenith is counter-clockwise from image "up".
  @$pb.TagNumber(1)
  $core.double get zenithRollAngle => $_getN(0);
  @$pb.TagNumber(1)
  set zenithRollAngle($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZenithRollAngle() => $_has(0);
  @$pb.TagNumber(1)
  void clearZenithRollAngle() => $_clearField(1);

  /// Altitude (degrees, relative to the local horizon) of the boresight.
  @$pb.TagNumber(2)
  $core.double get altitude => $_getN(1);
  @$pb.TagNumber(2)
  set altitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAltitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearAltitude() => $_clearField(2);

  /// Azimuth (degrees, positive clockwise from north) of the boresight.
  @$pb.TagNumber(3)
  $core.double get azimuth => $_getN(2);
  @$pb.TagNumber(3)
  set azimuth($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAzimuth() => $_has(2);
  @$pb.TagNumber(3)
  void clearAzimuth() => $_clearField(3);

  /// Hour angle (degrees, -180..180). Negative hour angle means boresight
  /// is approaching the meridian from east; positive means boresight
  /// is moving away from the meridian towards west.
  @$pb.TagNumber(4)
  $core.double get hourAngle => $_getN(3);
  @$pb.TagNumber(4)
  set hourAngle($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHourAngle() => $_has(3);
  @$pb.TagNumber(4)
  void clearHourAngle() => $_clearField(4);
}

/// Describes a telescope motion request from SkySafari or Cedar Sky.
class SlewRequest extends $pb.GeneratedMessage {
  factory SlewRequest({
    $4.CelestialCoord? target,
    $core.double? targetDistance,
    $core.double? targetAngle,
    ImageCoord? imagePos,
    $core.double? offsetRotationAxis,
    $core.double? offsetTiltAxis,
    $1.CatalogEntry? targetCatalogEntry,
    $core.double? targetCatalogEntryDistance,
  }) {
    final $result = create();
    if (target != null) {
      $result.target = target;
    }
    if (targetDistance != null) {
      $result.targetDistance = targetDistance;
    }
    if (targetAngle != null) {
      $result.targetAngle = targetAngle;
    }
    if (imagePos != null) {
      $result.imagePos = imagePos;
    }
    if (offsetRotationAxis != null) {
      $result.offsetRotationAxis = offsetRotationAxis;
    }
    if (offsetTiltAxis != null) {
      $result.offsetTiltAxis = offsetTiltAxis;
    }
    if (targetCatalogEntry != null) {
      $result.targetCatalogEntry = targetCatalogEntry;
    }
    if (targetCatalogEntryDistance != null) {
      $result.targetCatalogEntryDistance = targetCatalogEntryDistance;
    }
    return $result;
  }
  SlewRequest._() : super();
  factory SlewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SlewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SlewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<$4.CelestialCoord>(1, _omitFieldNames ? '' : 'target', subBuilder: $4.CelestialCoord.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'targetDistance', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'targetAngle', $pb.PbFieldType.OD)
    ..aOM<ImageCoord>(4, _omitFieldNames ? '' : 'imagePos', subBuilder: ImageCoord.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'offsetRotationAxis', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'offsetTiltAxis', $pb.PbFieldType.OD)
    ..aOM<$1.CatalogEntry>(8, _omitFieldNames ? '' : 'targetCatalogEntry', subBuilder: $1.CatalogEntry.create)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'targetCatalogEntryDistance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SlewRequest clone() => SlewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SlewRequest copyWith(void Function(SlewRequest) updates) => super.copyWith((message) => updates(message as SlewRequest)) as SlewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SlewRequest create() => SlewRequest._();
  SlewRequest createEmptyInstance() => create();
  static $pb.PbList<SlewRequest> createRepeated() => $pb.PbList<SlewRequest>();
  @$core.pragma('dart2js:noInline')
  static SlewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SlewRequest>(create);
  static SlewRequest? _defaultInstance;

  /// Identifies the target coordinate of the telescope motion request.
  @$pb.TagNumber(1)
  $4.CelestialCoord get target => $_getN(0);
  @$pb.TagNumber(1)
  set target($4.CelestialCoord v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  $4.CelestialCoord ensureTarget() => $_ensure(0);

  /// The distance, in degrees, between the boresight and the target. Omitted
  /// if there is no valid plate solution.
  @$pb.TagNumber(2)
  $core.double get targetDistance => $_getN(1);
  @$pb.TagNumber(2)
  set targetDistance($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetDistance() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetDistance() => $_clearField(2);

  /// The position angle (degrees) from the boresight to the target. If the
  /// target is above the boresight in image coordinates, the position angle is
  /// zero. Positive target_angle values go counter-clockwise from image "up", so
  /// a target_angle value of 90 degrees means the target is to the left of the
  /// boresight in the image.
  /// Omitted if there is no valid plate solution.
  @$pb.TagNumber(3)
  $core.double get targetAngle => $_getN(2);
  @$pb.TagNumber(3)
  set targetAngle($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetAngle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetAngle() => $_clearField(3);

  /// Position of the target in FrameResult.image (in full image resolution
  /// coordinates).
  /// Omitted if the target is not in the field of view or there is no valid
  /// plate solution.
  @$pb.TagNumber(4)
  ImageCoord get imagePos => $_getN(3);
  @$pb.TagNumber(4)
  set imagePos(ImageCoord v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasImagePos() => $_has(3);
  @$pb.TagNumber(4)
  void clearImagePos() => $_clearField(4);
  @$pb.TagNumber(4)
  ImageCoord ensureImagePos() => $_ensure(3);

  /// To move the boresight to the target, this is the angle by which the
  /// telescope must be moved about the rotation axis (right ascension for
  /// equatorial mount; azimuth for alt/az mount). Degrees; positive is towards
  /// east in equatorial, clockwise (viewed from above) in alt/az. Omitted if
  /// alt/az mode and observer location has not been set.
  /// Range: -180..180
  @$pb.TagNumber(5)
  $core.double get offsetRotationAxis => $_getN(4);
  @$pb.TagNumber(5)
  set offsetRotationAxis($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOffsetRotationAxis() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffsetRotationAxis() => $_clearField(5);

  /// To move the boresight to the target, this is the angle by which the
  /// telescope must be moved about the other axis (declination for equatorial
  /// mount; altitude for alt/az mount). Degrees; positive is towards north pole
  /// in equatorial, towards zenith in alt/az. Omitted if alt/az mode and
  /// observer location has not been set.
  /// Range: -180..180
  @$pb.TagNumber(6)
  $core.double get offsetTiltAxis => $_getN(5);
  @$pb.TagNumber(6)
  set offsetTiltAxis($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOffsetTiltAxis() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffsetTiltAxis() => $_clearField(6);

  /// The Cedar Sky catalog entry, if any, for `target`.
  @$pb.TagNumber(8)
  $1.CatalogEntry get targetCatalogEntry => $_getN(6);
  @$pb.TagNumber(8)
  set targetCatalogEntry($1.CatalogEntry v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasTargetCatalogEntry() => $_has(6);
  @$pb.TagNumber(8)
  void clearTargetCatalogEntry() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.CatalogEntry ensureTargetCatalogEntry() => $_ensure(6);

  /// If `target_catalog_entry` is given, this field is the distance, in
  /// degrees, between `target` and `target_catalog_entry.coord`.
  @$pb.TagNumber(9)
  $core.double get targetCatalogEntryDistance => $_getN(7);
  @$pb.TagNumber(9)
  set targetCatalogEntryDistance($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasTargetCatalogEntryDistance() => $_has(7);
  @$pb.TagNumber(9)
  void clearTargetCatalogEntryDistance() => $_clearField(9);
}

/// Estimate of alt/az offset of mount's polar axis from celestial pole. Not
/// available if the telescope is not a clock-driven equatorial mount
/// (auto-detected) or if the observer's geographic location is not known. Note
/// that it is possible for one of alt or az correction to be supplied and the
/// other omitted.
class PolarAlignAdvice extends $pb.GeneratedMessage {
  factory PolarAlignAdvice({
    ErrorBoundedValue? azimuthCorrection,
    ErrorBoundedValue? altitudeCorrection,
  }) {
    final $result = create();
    if (azimuthCorrection != null) {
      $result.azimuthCorrection = azimuthCorrection;
    }
    if (altitudeCorrection != null) {
      $result.altitudeCorrection = altitudeCorrection;
    }
    return $result;
  }
  PolarAlignAdvice._() : super();
  factory PolarAlignAdvice.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PolarAlignAdvice.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PolarAlignAdvice', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<ErrorBoundedValue>(1, _omitFieldNames ? '' : 'azimuthCorrection', subBuilder: ErrorBoundedValue.create)
    ..aOM<ErrorBoundedValue>(2, _omitFieldNames ? '' : 'altitudeCorrection', subBuilder: ErrorBoundedValue.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PolarAlignAdvice clone() => PolarAlignAdvice()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PolarAlignAdvice copyWith(void Function(PolarAlignAdvice) updates) => super.copyWith((message) => updates(message as PolarAlignAdvice)) as PolarAlignAdvice;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolarAlignAdvice create() => PolarAlignAdvice._();
  PolarAlignAdvice createEmptyInstance() => create();
  static $pb.PbList<PolarAlignAdvice> createRepeated() => $pb.PbList<PolarAlignAdvice>();
  @$core.pragma('dart2js:noInline')
  static PolarAlignAdvice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolarAlignAdvice>(create);
  static PolarAlignAdvice? _defaultInstance;

  /// The amount by which the mount azimuth should be adjusted, in degrees.
  /// Positive is clockwise looking down at the mount from above; in northern
  /// (southern) hemisphere this is moving polar axis towards east (west).
  @$pb.TagNumber(1)
  ErrorBoundedValue get azimuthCorrection => $_getN(0);
  @$pb.TagNumber(1)
  set azimuthCorrection(ErrorBoundedValue v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAzimuthCorrection() => $_has(0);
  @$pb.TagNumber(1)
  void clearAzimuthCorrection() => $_clearField(1);
  @$pb.TagNumber(1)
  ErrorBoundedValue ensureAzimuthCorrection() => $_ensure(0);

  /// The amount by which the mount elevation should be adjusted, in degrees.
  /// Positive means raise the polar axis.
  @$pb.TagNumber(2)
  ErrorBoundedValue get altitudeCorrection => $_getN(1);
  @$pb.TagNumber(2)
  set altitudeCorrection(ErrorBoundedValue v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAltitudeCorrection() => $_has(1);
  @$pb.TagNumber(2)
  void clearAltitudeCorrection() => $_clearField(2);
  @$pb.TagNumber(2)
  ErrorBoundedValue ensureAltitudeCorrection() => $_ensure(1);
}

/// A value estimate +/- an error estimate.
class ErrorBoundedValue extends $pb.GeneratedMessage {
  factory ErrorBoundedValue({
    $core.double? value,
    $core.double? error,
  }) {
    final $result = create();
    if (value != null) {
      $result.value = value;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  ErrorBoundedValue._() : super();
  factory ErrorBoundedValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorBoundedValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorBoundedValue', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'error', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorBoundedValue clone() => ErrorBoundedValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorBoundedValue copyWith(void Function(ErrorBoundedValue) updates) => super.copyWith((message) => updates(message as ErrorBoundedValue)) as ErrorBoundedValue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorBoundedValue create() => ErrorBoundedValue._();
  ErrorBoundedValue createEmptyInstance() => create();
  static $pb.PbList<ErrorBoundedValue> createRepeated() => $pb.PbList<ErrorBoundedValue>();
  @$core.pragma('dart2js:noInline')
  static ErrorBoundedValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorBoundedValue>(create);
  static ErrorBoundedValue? _defaultInstance;

  /// The estimated value.
  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  /// Estimate of the RMS error of `value`.
  @$pb.TagNumber(2)
  $core.double get error => $_getN(1);
  @$pb.TagNumber(2)
  set error($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(1);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
}

/// Represents a Cedar-sky catalog item in the current FOV that satisfies
/// the `catalog_entry_match` criteria.
class FovCatalogEntry extends $pb.GeneratedMessage {
  factory FovCatalogEntry({
    $1.CatalogEntry? entry,
    ImageCoord? imagePos,
  }) {
    final $result = create();
    if (entry != null) {
      $result.entry = entry;
    }
    if (imagePos != null) {
      $result.imagePos = imagePos;
    }
    return $result;
  }
  FovCatalogEntry._() : super();
  factory FovCatalogEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FovCatalogEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FovCatalogEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOM<$1.CatalogEntry>(1, _omitFieldNames ? '' : 'entry', subBuilder: $1.CatalogEntry.create)
    ..aOM<ImageCoord>(2, _omitFieldNames ? '' : 'imagePos', subBuilder: ImageCoord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FovCatalogEntry clone() => FovCatalogEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FovCatalogEntry copyWith(void Function(FovCatalogEntry) updates) => super.copyWith((message) => updates(message as FovCatalogEntry)) as FovCatalogEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FovCatalogEntry create() => FovCatalogEntry._();
  FovCatalogEntry createEmptyInstance() => create();
  static $pb.PbList<FovCatalogEntry> createRepeated() => $pb.PbList<FovCatalogEntry>();
  @$core.pragma('dart2js:noInline')
  static FovCatalogEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FovCatalogEntry>(create);
  static FovCatalogEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CatalogEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry($1.CatalogEntry v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CatalogEntry ensureEntry() => $_ensure(0);

  @$pb.TagNumber(2)
  ImageCoord get imagePos => $_getN(1);
  @$pb.TagNumber(2)
  set imagePos(ImageCoord v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasImagePos() => $_has(1);
  @$pb.TagNumber(2)
  void clearImagePos() => $_clearField(2);
  @$pb.TagNumber(2)
  ImageCoord ensureImagePos() => $_ensure(1);
}

class ActionRequest extends $pb.GeneratedMessage {
  factory ActionRequest({
    $core.bool? captureBoresight,
    ImageCoord? designateBoresight,
    $core.bool? shutdownServer,
    $core.bool? stopSlew,
    $core.bool? saveImage,
    $4.CelestialCoord? initiateSlew,
    WiFiAccessPoint? updateWifiAccessPoint,
    $core.bool? restartServer,
    $core.bool? cancelCalibration,
    $core.bool? clearDontShows,
  }) {
    final $result = create();
    if (captureBoresight != null) {
      $result.captureBoresight = captureBoresight;
    }
    if (designateBoresight != null) {
      $result.designateBoresight = designateBoresight;
    }
    if (shutdownServer != null) {
      $result.shutdownServer = shutdownServer;
    }
    if (stopSlew != null) {
      $result.stopSlew = stopSlew;
    }
    if (saveImage != null) {
      $result.saveImage = saveImage;
    }
    if (initiateSlew != null) {
      $result.initiateSlew = initiateSlew;
    }
    if (updateWifiAccessPoint != null) {
      $result.updateWifiAccessPoint = updateWifiAccessPoint;
    }
    if (restartServer != null) {
      $result.restartServer = restartServer;
    }
    if (cancelCalibration != null) {
      $result.cancelCalibration = cancelCalibration;
    }
    if (clearDontShows != null) {
      $result.clearDontShows = clearDontShows;
    }
    return $result;
  }
  ActionRequest._() : super();
  factory ActionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ActionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'captureBoresight')
    ..aOM<ImageCoord>(2, _omitFieldNames ? '' : 'designateBoresight', subBuilder: ImageCoord.create)
    ..aOB(3, _omitFieldNames ? '' : 'shutdownServer')
    ..aOB(4, _omitFieldNames ? '' : 'stopSlew')
    ..aOB(5, _omitFieldNames ? '' : 'saveImage')
    ..aOM<$4.CelestialCoord>(6, _omitFieldNames ? '' : 'initiateSlew', subBuilder: $4.CelestialCoord.create)
    ..aOM<WiFiAccessPoint>(7, _omitFieldNames ? '' : 'updateWifiAccessPoint', subBuilder: WiFiAccessPoint.create)
    ..aOB(8, _omitFieldNames ? '' : 'restartServer')
    ..aOB(9, _omitFieldNames ? '' : 'cancelCalibration')
    ..aOB(10, _omitFieldNames ? '' : 'clearDontShows')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActionRequest clone() => ActionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActionRequest copyWith(void Function(ActionRequest) updates) => super.copyWith((message) => updates(message as ActionRequest)) as ActionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ActionRequest create() => ActionRequest._();
  ActionRequest createEmptyInstance() => create();
  static $pb.PbList<ActionRequest> createRepeated() => $pb.PbList<ActionRequest>();
  @$core.pragma('dart2js:noInline')
  static ActionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionRequest>(create);
  static ActionRequest? _defaultInstance;

  /// The `capture_boresight` function is used during an active slew to target.
  /// This lets the user update/refine the boresight offset when the user has
  /// centered the target in the telescope's field of view.
  @$pb.TagNumber(1)
  $core.bool get captureBoresight => $_getBF(0);
  @$pb.TagNumber(1)
  set captureBoresight($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCaptureBoresight() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaptureBoresight() => $_clearField(1);

  /// In SETUP alignment mode, this conveys which part of the image the user
  /// tapped to designate the telescope's FOV center (in daylight mode) or the
  /// x/y image position of the highlighted star/planet the user selected (not in
  /// daylight mode). The image coordinates are full resolution within
  /// FrameResult.image.
  @$pb.TagNumber(2)
  ImageCoord get designateBoresight => $_getN(1);
  @$pb.TagNumber(2)
  set designateBoresight(ImageCoord v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDesignateBoresight() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesignateBoresight() => $_clearField(2);
  @$pb.TagNumber(2)
  ImageCoord ensureDesignateBoresight() => $_ensure(1);

  /// Shut down the computer on which the Cedar server is running. Do this before
  /// unplugging the power!
  @$pb.TagNumber(3)
  $core.bool get shutdownServer => $_getBF(2);
  @$pb.TagNumber(3)
  set shutdownServer($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShutdownServer() => $_has(2);
  @$pb.TagNumber(3)
  void clearShutdownServer() => $_clearField(3);

  /// Tells SkySafari that the slew is finished (or discontinued).
  @$pb.TagNumber(4)
  $core.bool get stopSlew => $_getBF(3);
  @$pb.TagNumber(4)
  set stopSlew($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStopSlew() => $_has(3);
  @$pb.TagNumber(4)
  void clearStopSlew() => $_clearField(4);

  /// Save the current image for debugging. The image is saved in the run
  /// directory on the server with the current date/time incorporated into the
  /// filename.
  /// TODO: return filename? Provide rename action? Return image to be saved
  /// on client device?
  @$pb.TagNumber(5)
  $core.bool get saveImage => $_getBF(4);
  @$pb.TagNumber(5)
  set saveImage($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSaveImage() => $_has(4);
  @$pb.TagNumber(5)
  void clearSaveImage() => $_clearField(5);

  /// Cedar-aim is initiating a goto operation. This might be from a Cedar Sky
  /// catalog selection, or it might be a user-entered RA/Dec value.
  @$pb.TagNumber(6)
  $4.CelestialCoord get initiateSlew => $_getN(5);
  @$pb.TagNumber(6)
  set initiateSlew($4.CelestialCoord v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasInitiateSlew() => $_has(5);
  @$pb.TagNumber(6)
  void clearInitiateSlew() => $_clearField(6);
  @$pb.TagNumber(6)
  $4.CelestialCoord ensureInitiateSlew() => $_ensure(5);

  /// Update ssid, psk, and/or channel setting for Cedar server's
  /// WiFi access point. TODO: Switches to access point mode if currently
  /// in client mode.
  @$pb.TagNumber(7)
  WiFiAccessPoint get updateWifiAccessPoint => $_getN(6);
  @$pb.TagNumber(7)
  set updateWifiAccessPoint(WiFiAccessPoint v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdateWifiAccessPoint() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdateWifiAccessPoint() => $_clearField(7);
  @$pb.TagNumber(7)
  WiFiAccessPoint ensureUpdateWifiAccessPoint() => $_ensure(6);

  /// Reboot the computer on which the Cedar server is running.
  @$pb.TagNumber(8)
  $core.bool get restartServer => $_getBF(7);
  @$pb.TagNumber(8)
  set restartServer($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRestartServer() => $_has(7);
  @$pb.TagNumber(8)
  void clearRestartServer() => $_clearField(8);

  /// Cancels a calibration; no effect if no calibration is underway.
  @$pb.TagNumber(9)
  $core.bool get cancelCalibration => $_getBF(8);
  @$pb.TagNumber(9)
  set cancelCalibration($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCancelCalibration() => $_has(8);
  @$pb.TagNumber(9)
  void clearCancelCalibration() => $_clearField(9);

  /// Reset all Preferences.dont_show_xxx fields.
  @$pb.TagNumber(10)
  $core.bool get clearDontShows => $_getBF(9);
  @$pb.TagNumber(10)
  set clearDontShows($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasClearDontShows() => $_has(9);
  @$pb.TagNumber(10)
  void clearClearDontShows() => $_clearField(10);
}

class ServerLogRequest extends $pb.GeneratedMessage {
  factory ServerLogRequest({
    $core.int? logRequest,
  }) {
    final $result = create();
    if (logRequest != null) {
      $result.logRequest = logRequest;
    }
    return $result;
  }
  ServerLogRequest._() : super();
  factory ServerLogRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerLogRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerLogRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'logRequest', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerLogRequest clone() => ServerLogRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerLogRequest copyWith(void Function(ServerLogRequest) updates) => super.copyWith((message) => updates(message as ServerLogRequest)) as ServerLogRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerLogRequest create() => ServerLogRequest._();
  ServerLogRequest createEmptyInstance() => create();
  static $pb.PbList<ServerLogRequest> createRepeated() => $pb.PbList<ServerLogRequest>();
  @$core.pragma('dart2js:noInline')
  static ServerLogRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerLogRequest>(create);
  static ServerLogRequest? _defaultInstance;

  /// Specifies how many bytes (most recent) of the server log to retrieve.
  @$pb.TagNumber(1)
  $core.int get logRequest => $_getIZ(0);
  @$pb.TagNumber(1)
  set logRequest($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLogRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogRequest() => $_clearField(1);
}

class ServerLogResult extends $pb.GeneratedMessage {
  factory ServerLogResult({
    $core.String? logContent,
  }) {
    final $result = create();
    if (logContent != null) {
      $result.logContent = logContent;
    }
    return $result;
  }
  ServerLogResult._() : super();
  factory ServerLogResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerLogResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServerLogResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'logContent')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerLogResult clone() => ServerLogResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerLogResult copyWith(void Function(ServerLogResult) updates) => super.copyWith((message) => updates(message as ServerLogResult)) as ServerLogResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerLogResult create() => ServerLogResult._();
  ServerLogResult createEmptyInstance() => create();
  static $pb.PbList<ServerLogResult> createRepeated() => $pb.PbList<ServerLogResult>();
  @$core.pragma('dart2js:noInline')
  static ServerLogResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerLogResult>(create);
  static ServerLogResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get logContent => $_getSZ(0);
  @$pb.TagNumber(1)
  set logContent($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLogContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogContent() => $_clearField(1);
}

class EmptyMessage extends $pb.GeneratedMessage {
  factory EmptyMessage() => create();
  EmptyMessage._() : super();
  factory EmptyMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EmptyMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EmptyMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EmptyMessage clone() => EmptyMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EmptyMessage copyWith(void Function(EmptyMessage) updates) => super.copyWith((message) => updates(message as EmptyMessage)) as EmptyMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmptyMessage create() => EmptyMessage._();
  EmptyMessage createEmptyInstance() => create();
  static $pb.PbList<EmptyMessage> createRepeated() => $pb.PbList<EmptyMessage>();
  @$core.pragma('dart2js:noInline')
  static EmptyMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EmptyMessage>(create);
  static EmptyMessage? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
