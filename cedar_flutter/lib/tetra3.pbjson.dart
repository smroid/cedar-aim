//
//  Generated code. Do not modify.
//  source: tetra3.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use solveStatusDescriptor instead')
const SolveStatus$json = {
  '1': 'SolveStatus',
  '2': [
    {'1': 'UNSPECIFIED', '2': 0},
    {'1': 'MATCH_FOUND', '2': 1},
    {'1': 'NO_MATCH', '2': 2},
    {'1': 'TIMEOUT', '2': 3},
    {'1': 'CANCELLED', '2': 4},
    {'1': 'TOO_FEW', '2': 5},
  ],
};

/// Descriptor for `SolveStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List solveStatusDescriptor = $convert.base64Decode(
    'CgtTb2x2ZVN0YXR1cxIPCgtVTlNQRUNJRklFRBAAEg8KC01BVENIX0ZPVU5EEAESDAoITk9fTU'
    'FUQ0gQAhILCgdUSU1FT1VUEAMSDQoJQ0FOQ0VMTEVEEAQSCwoHVE9PX0ZFVxAF');

@$core.Deprecated('Use solveRequestDescriptor instead')
const SolveRequest$json = {
  '1': 'SolveRequest',
  '2': [
    {'1': 'star_centroids', '3': 1, '4': 3, '5': 11, '6': '.tetra3_server.ImageCoord', '10': 'starCentroids'},
    {'1': 'image_width', '3': 2, '4': 1, '5': 5, '10': 'imageWidth'},
    {'1': 'image_height', '3': 3, '4': 1, '5': 5, '10': 'imageHeight'},
    {'1': 'fov_estimate', '3': 4, '4': 1, '5': 1, '9': 0, '10': 'fovEstimate', '17': true},
    {'1': 'fov_max_error', '3': 5, '4': 1, '5': 1, '9': 1, '10': 'fovMaxError', '17': true},
    {'1': 'match_radius', '3': 7, '4': 1, '5': 1, '9': 2, '10': 'matchRadius', '17': true},
    {'1': 'match_threshold', '3': 8, '4': 1, '5': 1, '9': 3, '10': 'matchThreshold', '17': true},
    {'1': 'solve_timeout', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 4, '10': 'solveTimeout', '17': true},
    {'1': 'target_pixels', '3': 9, '4': 3, '5': 11, '6': '.tetra3_server.ImageCoord', '10': 'targetPixels'},
    {'1': 'target_sky_coords', '3': 14, '4': 3, '5': 11, '6': '.tetra3_server.CelestialCoord', '10': 'targetSkyCoords'},
    {'1': 'distortion', '3': 10, '4': 1, '5': 1, '9': 5, '10': 'distortion', '17': true},
    {'1': 'return_matches', '3': 11, '4': 1, '5': 8, '10': 'returnMatches'},
    {'1': 'return_rotation_matrix', '3': 15, '4': 1, '5': 8, '10': 'returnRotationMatrix'},
    {'1': 'match_max_error', '3': 12, '4': 1, '5': 1, '9': 6, '10': 'matchMaxError', '17': true},
  ],
  '8': [
    {'1': '_fov_estimate'},
    {'1': '_fov_max_error'},
    {'1': '_match_radius'},
    {'1': '_match_threshold'},
    {'1': '_solve_timeout'},
    {'1': '_distortion'},
    {'1': '_match_max_error'},
  ],
};

/// Descriptor for `SolveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solveRequestDescriptor = $convert.base64Decode(
    'CgxTb2x2ZVJlcXVlc3QSQAoOc3Rhcl9jZW50cm9pZHMYASADKAsyGS50ZXRyYTNfc2VydmVyLk'
    'ltYWdlQ29vcmRSDXN0YXJDZW50cm9pZHMSHwoLaW1hZ2Vfd2lkdGgYAiABKAVSCmltYWdlV2lk'
    'dGgSIQoMaW1hZ2VfaGVpZ2h0GAMgASgFUgtpbWFnZUhlaWdodBImCgxmb3ZfZXN0aW1hdGUYBC'
    'ABKAFIAFILZm92RXN0aW1hdGWIAQESJwoNZm92X21heF9lcnJvchgFIAEoAUgBUgtmb3ZNYXhF'
    'cnJvcogBARImCgxtYXRjaF9yYWRpdXMYByABKAFIAlILbWF0Y2hSYWRpdXOIAQESLAoPbWF0Y2'
    'hfdGhyZXNob2xkGAggASgBSANSDm1hdGNoVGhyZXNob2xkiAEBEkMKDXNvbHZlX3RpbWVvdXQY'
    'DSABKAsyGS5nb29nbGUucHJvdG9idWYuRHVyYXRpb25IBFIMc29sdmVUaW1lb3V0iAEBEj4KDX'
    'RhcmdldF9waXhlbHMYCSADKAsyGS50ZXRyYTNfc2VydmVyLkltYWdlQ29vcmRSDHRhcmdldFBp'
    'eGVscxJJChF0YXJnZXRfc2t5X2Nvb3JkcxgOIAMoCzIdLnRldHJhM19zZXJ2ZXIuQ2VsZXN0aW'
    'FsQ29vcmRSD3RhcmdldFNreUNvb3JkcxIjCgpkaXN0b3J0aW9uGAogASgBSAVSCmRpc3RvcnRp'
    'b26IAQESJQoOcmV0dXJuX21hdGNoZXMYCyABKAhSDXJldHVybk1hdGNoZXMSNAoWcmV0dXJuX3'
    'JvdGF0aW9uX21hdHJpeBgPIAEoCFIUcmV0dXJuUm90YXRpb25NYXRyaXgSKwoPbWF0Y2hfbWF4'
    'X2Vycm9yGAwgASgBSAZSDW1hdGNoTWF4RXJyb3KIAQFCDwoNX2Zvdl9lc3RpbWF0ZUIQCg5fZm'
    '92X21heF9lcnJvckIPCg1fbWF0Y2hfcmFkaXVzQhIKEF9tYXRjaF90aHJlc2hvbGRCEAoOX3Nv'
    'bHZlX3RpbWVvdXRCDQoLX2Rpc3RvcnRpb25CEgoQX21hdGNoX21heF9lcnJvcg==');

@$core.Deprecated('Use solveResultDescriptor instead')
const SolveResult$json = {
  '1': 'SolveResult',
  '2': [
    {'1': 'image_center_coords', '3': 1, '4': 1, '5': 11, '6': '.tetra3_server.CelestialCoord', '9': 0, '10': 'imageCenterCoords', '17': true},
    {'1': 'roll', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'roll', '17': true},
    {'1': 'fov', '3': 3, '4': 1, '5': 1, '9': 2, '10': 'fov', '17': true},
    {'1': 'distortion', '3': 4, '4': 1, '5': 1, '9': 3, '10': 'distortion', '17': true},
    {'1': 'rmse', '3': 5, '4': 1, '5': 1, '9': 4, '10': 'rmse', '17': true},
    {'1': 'p90e', '3': 18, '4': 1, '5': 1, '9': 5, '10': 'p90e', '17': true},
    {'1': 'maxe', '3': 19, '4': 1, '5': 1, '9': 6, '10': 'maxe', '17': true},
    {'1': 'matches', '3': 6, '4': 1, '5': 5, '9': 7, '10': 'matches', '17': true},
    {'1': 'prob', '3': 7, '4': 1, '5': 1, '9': 8, '10': 'prob', '17': true},
    {'1': 'epoch_equinox', '3': 8, '4': 1, '5': 1, '9': 9, '10': 'epochEquinox', '17': true},
    {'1': 'epoch_proper_motion', '3': 9, '4': 1, '5': 1, '9': 10, '10': 'epochProperMotion', '17': true},
    {'1': 'solve_time', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'solveTime'},
    {'1': 'cache_hit_fraction', '3': 11, '4': 1, '5': 1, '9': 11, '10': 'cacheHitFraction', '17': true},
    {'1': 'target_coords', '3': 12, '4': 3, '5': 11, '6': '.tetra3_server.CelestialCoord', '10': 'targetCoords'},
    {'1': 'target_sky_to_image_coords', '3': 15, '4': 3, '5': 11, '6': '.tetra3_server.ImageCoord', '10': 'targetSkyToImageCoords'},
    {'1': 'matched_stars', '3': 13, '4': 3, '5': 11, '6': '.tetra3_server.MatchedStar', '10': 'matchedStars'},
    {'1': 'pattern_centroids', '3': 16, '4': 3, '5': 11, '6': '.tetra3_server.ImageCoord', '10': 'patternCentroids'},
    {'1': 'rotation_matrix', '3': 17, '4': 1, '5': 11, '6': '.tetra3_server.RotationMatrix', '9': 12, '10': 'rotationMatrix', '17': true},
    {'1': 'status', '3': 14, '4': 1, '5': 14, '6': '.tetra3_server.SolveStatus', '9': 13, '10': 'status', '17': true},
  ],
  '8': [
    {'1': '_image_center_coords'},
    {'1': '_roll'},
    {'1': '_fov'},
    {'1': '_distortion'},
    {'1': '_rmse'},
    {'1': '_p90e'},
    {'1': '_maxe'},
    {'1': '_matches'},
    {'1': '_prob'},
    {'1': '_epoch_equinox'},
    {'1': '_epoch_proper_motion'},
    {'1': '_cache_hit_fraction'},
    {'1': '_rotation_matrix'},
    {'1': '_status'},
  ],
};

/// Descriptor for `SolveResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solveResultDescriptor = $convert.base64Decode(
    'CgtTb2x2ZVJlc3VsdBJSChNpbWFnZV9jZW50ZXJfY29vcmRzGAEgASgLMh0udGV0cmEzX3Nlcn'
    'Zlci5DZWxlc3RpYWxDb29yZEgAUhFpbWFnZUNlbnRlckNvb3Jkc4gBARIXCgRyb2xsGAIgASgB'
    'SAFSBHJvbGyIAQESFQoDZm92GAMgASgBSAJSA2ZvdogBARIjCgpkaXN0b3J0aW9uGAQgASgBSA'
    'NSCmRpc3RvcnRpb26IAQESFwoEcm1zZRgFIAEoAUgEUgRybXNliAEBEhcKBHA5MGUYEiABKAFI'
    'BVIEcDkwZYgBARIXCgRtYXhlGBMgASgBSAZSBG1heGWIAQESHQoHbWF0Y2hlcxgGIAEoBUgHUg'
    'dtYXRjaGVziAEBEhcKBHByb2IYByABKAFICFIEcHJvYogBARIoCg1lcG9jaF9lcXVpbm94GAgg'
    'ASgBSAlSDGVwb2NoRXF1aW5veIgBARIzChNlcG9jaF9wcm9wZXJfbW90aW9uGAkgASgBSApSEW'
    'Vwb2NoUHJvcGVyTW90aW9uiAEBEjgKCnNvbHZlX3RpbWUYCiABKAsyGS5nb29nbGUucHJvdG9i'
    'dWYuRHVyYXRpb25SCXNvbHZlVGltZRIxChJjYWNoZV9oaXRfZnJhY3Rpb24YCyABKAFIC1IQY2'
    'FjaGVIaXRGcmFjdGlvbogBARJCCg10YXJnZXRfY29vcmRzGAwgAygLMh0udGV0cmEzX3NlcnZl'
    'ci5DZWxlc3RpYWxDb29yZFIMdGFyZ2V0Q29vcmRzElUKGnRhcmdldF9za3lfdG9faW1hZ2VfY2'
    '9vcmRzGA8gAygLMhkudGV0cmEzX3NlcnZlci5JbWFnZUNvb3JkUhZ0YXJnZXRTa3lUb0ltYWdl'
    'Q29vcmRzEj8KDW1hdGNoZWRfc3RhcnMYDSADKAsyGi50ZXRyYTNfc2VydmVyLk1hdGNoZWRTdG'
    'FyUgxtYXRjaGVkU3RhcnMSRgoRcGF0dGVybl9jZW50cm9pZHMYECADKAsyGS50ZXRyYTNfc2Vy'
    'dmVyLkltYWdlQ29vcmRSEHBhdHRlcm5DZW50cm9pZHMSSwoPcm90YXRpb25fbWF0cml4GBEgAS'
    'gLMh0udGV0cmEzX3NlcnZlci5Sb3RhdGlvbk1hdHJpeEgMUg5yb3RhdGlvbk1hdHJpeIgBARI3'
    'CgZzdGF0dXMYDiABKA4yGi50ZXRyYTNfc2VydmVyLlNvbHZlU3RhdHVzSA1SBnN0YXR1c4gBAU'
    'IWChRfaW1hZ2VfY2VudGVyX2Nvb3Jkc0IHCgVfcm9sbEIGCgRfZm92Qg0KC19kaXN0b3J0aW9u'
    'QgcKBV9ybXNlQgcKBV9wOTBlQgcKBV9tYXhlQgoKCF9tYXRjaGVzQgcKBV9wcm9iQhAKDl9lcG'
    '9jaF9lcXVpbm94QhYKFF9lcG9jaF9wcm9wZXJfbW90aW9uQhUKE19jYWNoZV9oaXRfZnJhY3Rp'
    'b25CEgoQX3JvdGF0aW9uX21hdHJpeEIJCgdfc3RhdHVz');

@$core.Deprecated('Use imageCoordDescriptor instead')
const ImageCoord$json = {
  '1': 'ImageCoord',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `ImageCoord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageCoordDescriptor = $convert.base64Decode(
    'CgpJbWFnZUNvb3JkEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use celestialCoordDescriptor instead')
const CelestialCoord$json = {
  '1': 'CelestialCoord',
  '2': [
    {'1': 'ra', '3': 1, '4': 1, '5': 1, '10': 'ra'},
    {'1': 'dec', '3': 2, '4': 1, '5': 1, '10': 'dec'},
  ],
};

/// Descriptor for `CelestialCoord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List celestialCoordDescriptor = $convert.base64Decode(
    'Cg5DZWxlc3RpYWxDb29yZBIOCgJyYRgBIAEoAVICcmESEAoDZGVjGAIgASgBUgNkZWM=');

@$core.Deprecated('Use matchedStarDescriptor instead')
const MatchedStar$json = {
  '1': 'MatchedStar',
  '2': [
    {'1': 'celestial_coord', '3': 1, '4': 1, '5': 11, '6': '.tetra3_server.CelestialCoord', '10': 'celestialCoord'},
    {'1': 'magnitude', '3': 2, '4': 1, '5': 1, '10': 'magnitude'},
    {'1': 'image_coord', '3': 3, '4': 1, '5': 11, '6': '.tetra3_server.ImageCoord', '10': 'imageCoord'},
    {'1': 'cat_id', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'catId', '17': true},
  ],
  '8': [
    {'1': '_cat_id'},
  ],
};

/// Descriptor for `MatchedStar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchedStarDescriptor = $convert.base64Decode(
    'CgtNYXRjaGVkU3RhchJGCg9jZWxlc3RpYWxfY29vcmQYASABKAsyHS50ZXRyYTNfc2VydmVyLk'
    'NlbGVzdGlhbENvb3JkUg5jZWxlc3RpYWxDb29yZBIcCgltYWduaXR1ZGUYAiABKAFSCW1hZ25p'
    'dHVkZRI6CgtpbWFnZV9jb29yZBgDIAEoCzIZLnRldHJhM19zZXJ2ZXIuSW1hZ2VDb29yZFIKaW'
    '1hZ2VDb29yZBIaCgZjYXRfaWQYBCABKAlIAFIFY2F0SWSIAQFCCQoHX2NhdF9pZA==');

@$core.Deprecated('Use rotationMatrixDescriptor instead')
const RotationMatrix$json = {
  '1': 'RotationMatrix',
  '2': [
    {'1': 'matrix_elements', '3': 1, '4': 3, '5': 1, '10': 'matrixElements'},
  ],
};

/// Descriptor for `RotationMatrix`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rotationMatrixDescriptor = $convert.base64Decode(
    'Cg5Sb3RhdGlvbk1hdHJpeBInCg9tYXRyaXhfZWxlbWVudHMYASADKAFSDm1hdHJpeEVsZW1lbn'
    'Rz');

