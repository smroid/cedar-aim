//
//  Generated code. Do not modify.
//  source: cedar_sky.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Ordering extends $pb.ProtobufEnum {
  static const Ordering UNSPECIFIED = Ordering._(0, _omitEnumNames ? '' : 'UNSPECIFIED');
  /// Brightest first.
  static const Ordering BRIGHTNESS = Ordering._(1, _omitEnumNames ? '' : 'BRIGHTNESS');
  /// Closest first. If no plate solution is available, reverts to brightness
  /// ordering.
  static const Ordering SKY_LOCATION = Ordering._(2, _omitEnumNames ? '' : 'SKY_LOCATION');
  /// Highest first. If observer geolocation is unknown, reverts to brightness
  /// ordering.
  static const Ordering ELEVATION = Ordering._(3, _omitEnumNames ? '' : 'ELEVATION');

  static const $core.List<Ordering> values = <Ordering> [
    UNSPECIFIED,
    BRIGHTNESS,
    SKY_LOCATION,
    ELEVATION,
  ];

  static final $core.Map<$core.int, Ordering> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Ordering? valueOf($core.int value) => _byValue[value];

  const Ordering._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
