//
//  Generated code. Do not modify.
//  source: cedar_common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CelestialCoord extends $pb.GeneratedMessage {
  factory CelestialCoord({
    $core.double? ra,
    $core.double? dec,
  }) {
    final $result = create();
    if (ra != null) {
      $result.ra = ra;
    }
    if (dec != null) {
      $result.dec = dec;
    }
    return $result;
  }
  CelestialCoord._() : super();
  factory CelestialCoord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CelestialCoord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CelestialCoord', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_common'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ra', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dec', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CelestialCoord clone() => CelestialCoord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CelestialCoord copyWith(void Function(CelestialCoord) updates) => super.copyWith((message) => updates(message as CelestialCoord)) as CelestialCoord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CelestialCoord create() => CelestialCoord._();
  CelestialCoord createEmptyInstance() => create();
  static $pb.PbList<CelestialCoord> createRepeated() => $pb.PbList<CelestialCoord>();
  @$core.pragma('dart2js:noInline')
  static CelestialCoord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CelestialCoord>(create);
  static CelestialCoord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get ra => $_getN(0);
  @$pb.TagNumber(1)
  set ra($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRa() => $_has(0);
  @$pb.TagNumber(1)
  void clearRa() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get dec => $_getN(1);
  @$pb.TagNumber(2)
  set dec($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDec() => $_has(1);
  @$pb.TagNumber(2)
  void clearDec() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
