//
//  Generated code. Do not modify.
//  source: tetra3.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SolveStatus extends $pb.ProtobufEnum {
  static const SolveStatus UNSPECIFIED = SolveStatus._(0, _omitEnumNames ? '' : 'UNSPECIFIED');
  static const SolveStatus MATCH_FOUND = SolveStatus._(1, _omitEnumNames ? '' : 'MATCH_FOUND');
  static const SolveStatus NO_MATCH = SolveStatus._(2, _omitEnumNames ? '' : 'NO_MATCH');
  static const SolveStatus TIMEOUT = SolveStatus._(3, _omitEnumNames ? '' : 'TIMEOUT');
  static const SolveStatus CANCELLED = SolveStatus._(4, _omitEnumNames ? '' : 'CANCELLED');
  static const SolveStatus TOO_FEW = SolveStatus._(5, _omitEnumNames ? '' : 'TOO_FEW');

  static const $core.List<SolveStatus> values = <SolveStatus> [
    UNSPECIFIED,
    MATCH_FOUND,
    NO_MATCH,
    TIMEOUT,
    CANCELLED,
    TOO_FEW,
  ];

  static final $core.Map<$core.int, SolveStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SolveStatus? valueOf($core.int value) => _byValue[value];

  const SolveStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
