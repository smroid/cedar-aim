//
//  Generated code. Do not modify.
//  source: cedar.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class FeatureLevel extends $pb.ProtobufEnum {
  static const FeatureLevel FEATURE_LEVEL_UNSPECIFIED = FeatureLevel._(0, _omitEnumNames ? '' : 'FEATURE_LEVEL_UNSPECIFIED');
  static const FeatureLevel DIY = FeatureLevel._(1, _omitEnumNames ? '' : 'DIY');
  static const FeatureLevel BASIC = FeatureLevel._(2, _omitEnumNames ? '' : 'BASIC');
  static const FeatureLevel PLUS = FeatureLevel._(3, _omitEnumNames ? '' : 'PLUS');

  static const $core.List<FeatureLevel> values = <FeatureLevel> [
    FEATURE_LEVEL_UNSPECIFIED,
    DIY,
    BASIC,
    PLUS,
  ];

  static final $core.Map<$core.int, FeatureLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeatureLevel? valueOf($core.int value) => _byValue[value];

  const FeatureLevel._($core.int v, $core.String n) : super(v, n);
}

class OperatingMode extends $pb.ProtobufEnum {
  static const OperatingMode MODE_UNSPECIFIED = OperatingMode._(0, _omitEnumNames ? '' : 'MODE_UNSPECIFIED');
  static const OperatingMode SETUP = OperatingMode._(1, _omitEnumNames ? '' : 'SETUP');
  static const OperatingMode OPERATE = OperatingMode._(2, _omitEnumNames ? '' : 'OPERATE');

  static const $core.List<OperatingMode> values = <OperatingMode> [
    MODE_UNSPECIFIED,
    SETUP,
    OPERATE,
  ];

  static final $core.Map<$core.int, OperatingMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OperatingMode? valueOf($core.int value) => _byValue[value];

  const OperatingMode._($core.int v, $core.String n) : super(v, n);
}

/// Reflects speed vs accuracy tradeoff in OPERATE mode.
class Accuracy extends $pb.ProtobufEnum {
  static const Accuracy ACCURACY_UNSPECIFIED = Accuracy._(0, _omitEnumNames ? '' : 'ACCURACY_UNSPECIFIED');
  static const Accuracy FASTER = Accuracy._(1, _omitEnumNames ? '' : 'FASTER');
  static const Accuracy BALANCED = Accuracy._(2, _omitEnumNames ? '' : 'BALANCED');
  static const Accuracy ACCURATE = Accuracy._(3, _omitEnumNames ? '' : 'ACCURATE');

  static const $core.List<Accuracy> values = <Accuracy> [
    ACCURACY_UNSPECIFIED,
    FASTER,
    BALANCED,
    ACCURATE,
  ];

  static final $core.Map<$core.int, Accuracy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Accuracy? valueOf($core.int value) => _byValue[value];

  const Accuracy._($core.int v, $core.String n) : super(v, n);
}

class CelestialCoordFormat extends $pb.ProtobufEnum {
  static const CelestialCoordFormat FORMAT_UNSPECIFIED = CelestialCoordFormat._(0, _omitEnumNames ? '' : 'FORMAT_UNSPECIFIED');
  static const CelestialCoordFormat DECIMAL = CelestialCoordFormat._(1, _omitEnumNames ? '' : 'DECIMAL');
  static const CelestialCoordFormat HMS_DMS = CelestialCoordFormat._(2, _omitEnumNames ? '' : 'HMS_DMS');

  static const $core.List<CelestialCoordFormat> values = <CelestialCoordFormat> [
    FORMAT_UNSPECIFIED,
    DECIMAL,
    HMS_DMS,
  ];

  static final $core.Map<$core.int, CelestialCoordFormat> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CelestialCoordFormat? valueOf($core.int value) => _byValue[value];

  const CelestialCoordFormat._($core.int v, $core.String n) : super(v, n);
}

class MountType extends $pb.ProtobufEnum {
  static const MountType MOUNT_UNSPECIFIED = MountType._(0, _omitEnumNames ? '' : 'MOUNT_UNSPECIFIED');
  static const MountType EQUATORIAL = MountType._(1, _omitEnumNames ? '' : 'EQUATORIAL');
  static const MountType ALT_AZ = MountType._(2, _omitEnumNames ? '' : 'ALT_AZ');

  static const $core.List<MountType> values = <MountType> [
    MOUNT_UNSPECIFIED,
    EQUATORIAL,
    ALT_AZ,
  ];

  static final $core.Map<$core.int, MountType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MountType? valueOf($core.int value) => _byValue[value];

  const MountType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
