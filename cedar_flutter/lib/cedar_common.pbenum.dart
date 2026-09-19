//
//  Generated code. Do not modify.
//  source: cedar_common.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class WifiMode extends $pb.ProtobufEnum {
  static const WifiMode WIFI_MODE_UNKNOWN = WifiMode._(0, _omitEnumNames ? '' : 'WIFI_MODE_UNKNOWN');
  static const WifiMode WIFI_MODE_ACCESS_POINT = WifiMode._(1, _omitEnumNames ? '' : 'WIFI_MODE_ACCESS_POINT');
  static const WifiMode WIFI_MODE_CLIENT = WifiMode._(2, _omitEnumNames ? '' : 'WIFI_MODE_CLIENT');
  static const WifiMode WIFI_MODE_INACTIVE = WifiMode._(3, _omitEnumNames ? '' : 'WIFI_MODE_INACTIVE');

  static const $core.List<WifiMode> values = <WifiMode> [
    WIFI_MODE_UNKNOWN,
    WIFI_MODE_ACCESS_POINT,
    WIFI_MODE_CLIENT,
    WIFI_MODE_INACTIVE,
  ];

  static final $core.Map<$core.int, WifiMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WifiMode? valueOf($core.int value) => _byValue[value];

  const WifiMode._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
