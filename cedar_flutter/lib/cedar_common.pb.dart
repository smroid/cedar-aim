// This is a generated file - do not edit.
//
// Generated from cedar_common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CelestialCoord extends $pb.GeneratedMessage {
  factory CelestialCoord({
    $core.double? ra,
    $core.double? dec,
    $core.double? epoch,
  }) {
    final result = create();
    if (ra != null) result.ra = ra;
    if (dec != null) result.dec = dec;
    if (epoch != null) result.epoch = epoch;
    return result;
  }

  CelestialCoord._();

  factory CelestialCoord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CelestialCoord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CelestialCoord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_common'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ra', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dec', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'epoch', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CelestialCoord clone() => CelestialCoord()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CelestialCoord copyWith(void Function(CelestialCoord) updates) =>
      super.copyWith((message) => updates(message as CelestialCoord))
          as CelestialCoord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CelestialCoord create() => CelestialCoord._();
  @$core.override
  CelestialCoord createEmptyInstance() => create();
  static $pb.PbList<CelestialCoord> createRepeated() =>
      $pb.PbList<CelestialCoord>();
  @$core.pragma('dart2js:noInline')
  static CelestialCoord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CelestialCoord>(create);
  static CelestialCoord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get ra => $_getN(0);
  @$pb.TagNumber(1)
  set ra($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRa() => $_has(0);
  @$pb.TagNumber(1)
  void clearRa() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get dec => $_getN(1);
  @$pb.TagNumber(2)
  set dec($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDec() => $_has(1);
  @$pb.TagNumber(2)
  void clearDec() => $_clearField(2);

  /// Epoch as a Julian year (e.g. 2000.0 for J2000). Defaults to 2000.0 if
  /// omitted.
  @$pb.TagNumber(3)
  $core.double get epoch => $_getN(2);
  @$pb.TagNumber(3)
  set epoch($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEpoch() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpoch() => $_clearField(3);
}

class HorizonCoord extends $pb.GeneratedMessage {
  factory HorizonCoord({
    $core.double? altitude,
    $core.double? azimuth,
    $core.double? epoch,
  }) {
    final result = create();
    if (altitude != null) result.altitude = altitude;
    if (azimuth != null) result.azimuth = azimuth;
    if (epoch != null) result.epoch = epoch;
    return result;
  }

  HorizonCoord._();

  factory HorizonCoord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HorizonCoord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HorizonCoord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_common'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'altitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'epoch', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HorizonCoord clone() => HorizonCoord()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HorizonCoord copyWith(void Function(HorizonCoord) updates) =>
      super.copyWith((message) => updates(message as HorizonCoord))
          as HorizonCoord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HorizonCoord create() => HorizonCoord._();
  @$core.override
  HorizonCoord createEmptyInstance() => create();
  static $pb.PbList<HorizonCoord> createRepeated() =>
      $pb.PbList<HorizonCoord>();
  @$core.pragma('dart2js:noInline')
  static HorizonCoord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HorizonCoord>(create);
  static HorizonCoord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get altitude => $_getN(0);
  @$pb.TagNumber(1)
  set altitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAltitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearAltitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get azimuth => $_getN(1);
  @$pb.TagNumber(2)
  set azimuth($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAzimuth() => $_has(1);
  @$pb.TagNumber(2)
  void clearAzimuth() => $_clearField(2);

  /// Meaningful only when calling the ConvertToCelestial() RPC. Determines what
  /// the epoch will be in the returned CelestialCoord.
  @$pb.TagNumber(3)
  $core.double get epoch => $_getN(2);
  @$pb.TagNumber(3)
  set epoch($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEpoch() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpoch() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
