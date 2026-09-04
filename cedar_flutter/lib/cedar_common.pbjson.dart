// This is a generated file - do not edit.
//
// Generated from cedar_common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use celestialCoordDescriptor instead')
const CelestialCoord$json = {
  '1': 'CelestialCoord',
  '2': [
    {'1': 'ra', '3': 1, '4': 1, '5': 1, '10': 'ra'},
    {'1': 'dec', '3': 2, '4': 1, '5': 1, '10': 'dec'},
    {'1': 'epoch', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'epoch', '17': true},
  ],
  '8': [
    {'1': '_epoch'},
  ],
};

/// Descriptor for `CelestialCoord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List celestialCoordDescriptor = $convert.base64Decode(
    'Cg5DZWxlc3RpYWxDb29yZBIOCgJyYRgBIAEoAVICcmESEAoDZGVjGAIgASgBUgNkZWMSGQoFZX'
    'BvY2gYAyABKAFIAFIFZXBvY2iIAQFCCAoGX2Vwb2No');

@$core.Deprecated('Use horizonCoordDescriptor instead')
const HorizonCoord$json = {
  '1': 'HorizonCoord',
  '2': [
    {'1': 'altitude', '3': 1, '4': 1, '5': 1, '10': 'altitude'},
    {'1': 'azimuth', '3': 2, '4': 1, '5': 1, '10': 'azimuth'},
    {'1': 'epoch', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'epoch', '17': true},
  ],
  '8': [
    {'1': '_epoch'},
  ],
};

/// Descriptor for `HorizonCoord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List horizonCoordDescriptor = $convert.base64Decode(
    'CgxIb3Jpem9uQ29vcmQSGgoIYWx0aXR1ZGUYASABKAFSCGFsdGl0dWRlEhgKB2F6aW11dGgYAi'
    'ABKAFSB2F6aW11dGgSGQoFZXBvY2gYAyABKAFIAFIFZXBvY2iIAQFCCAoGX2Vwb2No');
