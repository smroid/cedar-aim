// This is a generated file - do not edit.
//
// Generated from cedar_sky.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Ordering extends $pb.ProtobufEnum {
  static const Ordering UNSPECIFIED =
      Ordering._(0, _omitEnumNames ? '' : 'UNSPECIFIED');

  /// Brightest first.
  static const Ordering BRIGHTNESS =
      Ordering._(1, _omitEnumNames ? '' : 'BRIGHTNESS');

  /// Closest first. If no plate solution is available, reverts to brightness
  /// ordering.
  static const Ordering SKY_LOCATION =
      Ordering._(2, _omitEnumNames ? '' : 'SKY_LOCATION');

  /// Highest first. If observer geolocation is unknown, reverts to brightness
  /// ordering.
  static const Ordering ELEVATION =
      Ordering._(3, _omitEnumNames ? '' : 'ELEVATION');

  static const $core.List<Ordering> values = <Ordering>[
    UNSPECIFIED,
    BRIGHTNESS,
    SKY_LOCATION,
    ELEVATION,
  ];

  static final $core.List<Ordering?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Ordering? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Ordering._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
