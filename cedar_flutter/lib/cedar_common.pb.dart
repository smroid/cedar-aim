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
  }) {
    final result = create();
    if (ra != null) result.ra = ra;
    if (dec != null) result.dec = dec;
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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
