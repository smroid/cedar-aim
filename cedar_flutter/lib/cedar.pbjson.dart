// This is a generated file - do not edit.
//
// Generated from cedar.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use featureLevelDescriptor instead')
const FeatureLevel$json = {
  '1': 'FeatureLevel',
  '2': [
    {'1': 'FEATURE_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'DIY', '2': 1},
    {'1': 'BASIC', '2': 2},
    {'1': 'PLUS', '2': 3},
  ],
};

/// Descriptor for `FeatureLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List featureLevelDescriptor = $convert.base64Decode(
    'CgxGZWF0dXJlTGV2ZWwSHQoZRkVBVFVSRV9MRVZFTF9VTlNQRUNJRklFRBAAEgcKA0RJWRABEg'
    'kKBUJBU0lDEAISCAoEUExVUxAD');

@$core.Deprecated('Use imuTrackerStateDescriptor instead')
const ImuTrackerState$json = {
  '1': 'ImuTrackerState',
  '2': [
    {'1': 'TRACKER_STATE_UNKNOWN', '2': 0},
    {'1': 'MOTIONLESS', '2': 1},
    {'1': 'MOVING', '2': 2},
    {'1': 'LOST', '2': 3},
  ],
};

/// Descriptor for `ImuTrackerState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List imuTrackerStateDescriptor = $convert.base64Decode(
    'Cg9JbXVUcmFja2VyU3RhdGUSGQoVVFJBQ0tFUl9TVEFURV9VTktOT1dOEAASDgoKTU9USU9OTE'
    'VTUxABEgoKBk1PVklORxACEggKBExPU1QQAw==');

@$core.Deprecated('Use operatingModeDescriptor instead')
const OperatingMode$json = {
  '1': 'OperatingMode',
  '2': [
    {'1': 'MODE_UNSPECIFIED', '2': 0},
    {'1': 'SETUP', '2': 1},
    {'1': 'OPERATE', '2': 2},
  ],
};

/// Descriptor for `OperatingMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operatingModeDescriptor = $convert.base64Decode(
    'Cg1PcGVyYXRpbmdNb2RlEhQKEE1PREVfVU5TUEVDSUZJRUQQABIJCgVTRVRVUBABEgsKB09QRV'
    'JBVEUQAg==');

@$core.Deprecated('Use celestialCoordFormatDescriptor instead')
const CelestialCoordFormat$json = {
  '1': 'CelestialCoordFormat',
  '2': [
    {'1': 'FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'DECIMAL', '2': 1},
    {'1': 'HMS_DMS', '2': 2},
  ],
};

/// Descriptor for `CelestialCoordFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List celestialCoordFormatDescriptor = $convert.base64Decode(
    'ChRDZWxlc3RpYWxDb29yZEZvcm1hdBIWChJGT1JNQVRfVU5TUEVDSUZJRUQQABILCgdERUNJTU'
    'FMEAESCwoHSE1TX0RNUxAC');

@$core.Deprecated('Use mountTypeDescriptor instead')
const MountType$json = {
  '1': 'MountType',
  '2': [
    {'1': 'MOUNT_UNSPECIFIED', '2': 0},
    {'1': 'EQUATORIAL', '2': 1},
    {'1': 'ALT_AZ', '2': 2},
  ],
};

/// Descriptor for `MountType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mountTypeDescriptor = $convert.base64Decode(
    'CglNb3VudFR5cGUSFQoRTU9VTlRfVU5TUEVDSUZJRUQQABIOCgpFUVVBVE9SSUFMEAESCgoGQU'
    'xUX0FaEAI=');

@$core.Deprecated('Use displayOrientationDescriptor instead')
const DisplayOrientation$json = {
  '1': 'DisplayOrientation',
  '2': [
    {'1': 'ORIENTATION_UNSPECIFIED', '2': 0},
    {'1': 'LANDSCAPE', '2': 1},
    {'1': 'PORTRAIT', '2': 2},
  ],
};

/// Descriptor for `DisplayOrientation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List displayOrientationDescriptor = $convert.base64Decode(
    'ChJEaXNwbGF5T3JpZW50YXRpb24SGwoXT1JJRU5UQVRJT05fVU5TUEVDSUZJRUQQABINCglMQU'
    '5EU0NBUEUQARIMCghQT1JUUkFJVBAC');

@$core.Deprecated('Use calibrationFailureReasonDescriptor instead')
const CalibrationFailureReason$json = {
  '1': 'CalibrationFailureReason',
  '2': [
    {'1': 'REASON_UNSPECIFIED', '2': 0},
    {'1': 'TOO_FEW_STARS', '2': 1},
    {'1': 'BRIGHT_SKY', '2': 2},
    {'1': 'SOLVER_FAILED', '2': 3},
  ],
};

/// Descriptor for `CalibrationFailureReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List calibrationFailureReasonDescriptor =
    $convert.base64Decode(
        'ChhDYWxpYnJhdGlvbkZhaWx1cmVSZWFzb24SFgoSUkVBU09OX1VOU1BFQ0lGSUVEEAASEQoNVE'
        '9PX0ZFV19TVEFSUxABEg4KCkJSSUdIVF9TS1kQAhIRCg1TT0xWRVJfRkFJTEVEEAM=');

@$core.Deprecated('Use serverInformationDescriptor instead')
const ServerInformation$json = {
  '1': 'ServerInformation',
  '2': [
    {'1': 'product_name', '3': 1, '4': 1, '5': 9, '10': 'productName'},
    {'1': 'copyright', '3': 2, '4': 1, '5': 9, '10': 'copyright'},
    {
      '1': 'cedar_server_version',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'cedarServerVersion'
    },
    {
      '1': 'feature_level',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.cedar.FeatureLevel',
      '10': 'featureLevel'
    },
    {'1': 'processor_model', '3': 5, '4': 1, '5': 9, '10': 'processorModel'},
    {'1': 'os_version', '3': 6, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'serial_number', '3': 12, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'cpu_temperature', '3': 7, '4': 1, '5': 2, '10': 'cpuTemperature'},
    {
      '1': 'server_time',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'serverTime'
    },
    {
      '1': 'camera',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.cedar.CameraModel',
      '9': 0,
      '10': 'camera',
      '17': true
    },
    {
      '1': 'imu_model',
      '3': 14,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'imuModel',
      '17': true
    },
    {
      '1': 'imu',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImuState',
      '9': 2,
      '10': 'imu',
      '17': true
    },
    {
      '1': 'imu_angular_speed',
      '3': 16,
      '4': 1,
      '5': 1,
      '9': 3,
      '10': 'imuAngularSpeed',
      '17': true
    },
    {
      '1': 'imu_tracker_state',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.cedar.ImuTrackerState',
      '9': 4,
      '10': 'imuTrackerState',
      '17': true
    },
    {
      '1': 'wifi_access_point',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.cedar.WiFiAccessPoint',
      '9': 5,
      '10': 'wifiAccessPoint',
      '17': true
    },
    {'1': 'demo_image_names', '3': 11, '4': 3, '5': 9, '10': 'demoImageNames'},
  ],
  '8': [
    {'1': '_camera'},
    {'1': '_imu_model'},
    {'1': '_imu'},
    {'1': '_imu_angular_speed'},
    {'1': '_imu_tracker_state'},
    {'1': '_wifi_access_point'},
  ],
};

/// Descriptor for `ServerInformation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverInformationDescriptor = $convert.base64Decode(
    'ChFTZXJ2ZXJJbmZvcm1hdGlvbhIhCgxwcm9kdWN0X25hbWUYASABKAlSC3Byb2R1Y3ROYW1lEh'
    'wKCWNvcHlyaWdodBgCIAEoCVIJY29weXJpZ2h0EjAKFGNlZGFyX3NlcnZlcl92ZXJzaW9uGAMg'
    'ASgJUhJjZWRhclNlcnZlclZlcnNpb24SOAoNZmVhdHVyZV9sZXZlbBgEIAEoDjITLmNlZGFyLk'
    'ZlYXR1cmVMZXZlbFIMZmVhdHVyZUxldmVsEicKD3Byb2Nlc3Nvcl9tb2RlbBgFIAEoCVIOcHJv'
    'Y2Vzc29yTW9kZWwSHQoKb3NfdmVyc2lvbhgGIAEoCVIJb3NWZXJzaW9uEiMKDXNlcmlhbF9udW'
    '1iZXIYDCABKAlSDHNlcmlhbE51bWJlchInCg9jcHVfdGVtcGVyYXR1cmUYByABKAJSDmNwdVRl'
    'bXBlcmF0dXJlEjsKC3NlcnZlcl90aW1lGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIKc2VydmVyVGltZRIvCgZjYW1lcmEYCSABKAsyEi5jZWRhci5DYW1lcmFNb2RlbEgAUgZj'
    'YW1lcmGIAQESIAoJaW11X21vZGVsGA4gASgJSAFSCGltdU1vZGVsiAEBEiYKA2ltdRgNIAEoCz'
    'IPLmNlZGFyLkltdVN0YXRlSAJSA2ltdYgBARIvChFpbXVfYW5ndWxhcl9zcGVlZBgQIAEoAUgD'
    'Ug9pbXVBbmd1bGFyU3BlZWSIAQESRwoRaW11X3RyYWNrZXJfc3RhdGUYDyABKA4yFi5jZWRhci'
    '5JbXVUcmFja2VyU3RhdGVIBFIPaW11VHJhY2tlclN0YXRliAEBEkcKEXdpZmlfYWNjZXNzX3Bv'
    'aW50GAogASgLMhYuY2VkYXIuV2lGaUFjY2Vzc1BvaW50SAVSD3dpZmlBY2Nlc3NQb2ludIgBAR'
    'IoChBkZW1vX2ltYWdlX25hbWVzGAsgAygJUg5kZW1vSW1hZ2VOYW1lc0IJCgdfY2FtZXJhQgwK'
    'Cl9pbXVfbW9kZWxCBgoEX2ltdUIUChJfaW11X2FuZ3VsYXJfc3BlZWRCFAoSX2ltdV90cmFja2'
    'VyX3N0YXRlQhQKEl93aWZpX2FjY2Vzc19wb2ludA==');

@$core.Deprecated('Use cameraModelDescriptor instead')
const CameraModel$json = {
  '1': 'CameraModel',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
    {
      '1': 'model_detail',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'modelDetail',
      '17': true
    },
    {'1': 'image_width', '3': 2, '4': 1, '5': 5, '10': 'imageWidth'},
    {'1': 'image_height', '3': 3, '4': 1, '5': 5, '10': 'imageHeight'},
  ],
  '8': [
    {'1': '_model_detail'},
  ],
};

/// Descriptor for `CameraModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraModelDescriptor = $convert.base64Decode(
    'CgtDYW1lcmFNb2RlbBIUCgVtb2RlbBgBIAEoCVIFbW9kZWwSJgoMbW9kZWxfZGV0YWlsGAQgAS'
    'gJSABSC21vZGVsRGV0YWlsiAEBEh8KC2ltYWdlX3dpZHRoGAIgASgFUgppbWFnZVdpZHRoEiEK'
    'DGltYWdlX2hlaWdodBgDIAEoBVILaW1hZ2VIZWlnaHRCDwoNX21vZGVsX2RldGFpbA==');

@$core.Deprecated('Use imuStateDescriptor instead')
const ImuState$json = {
  '1': 'ImuState',
  '2': [
    {'1': 'accel_x', '3': 1, '4': 1, '5': 1, '10': 'accelX'},
    {'1': 'accel_y', '3': 2, '4': 1, '5': 1, '10': 'accelY'},
    {'1': 'accel_z', '3': 3, '4': 1, '5': 1, '10': 'accelZ'},
    {'1': 'angle_rate_x', '3': 4, '4': 1, '5': 1, '10': 'angleRateX'},
    {'1': 'angle_rate_y', '3': 5, '4': 1, '5': 1, '10': 'angleRateY'},
    {'1': 'angle_rate_z', '3': 6, '4': 1, '5': 1, '10': 'angleRateZ'},
  ],
};

/// Descriptor for `ImuState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imuStateDescriptor = $convert.base64Decode(
    'CghJbXVTdGF0ZRIXCgdhY2NlbF94GAEgASgBUgZhY2NlbFgSFwoHYWNjZWxfeRgCIAEoAVIGYW'
    'NjZWxZEhcKB2FjY2VsX3oYAyABKAFSBmFjY2VsWhIgCgxhbmdsZV9yYXRlX3gYBCABKAFSCmFu'
    'Z2xlUmF0ZVgSIAoMYW5nbGVfcmF0ZV95GAUgASgBUgphbmdsZVJhdGVZEiAKDGFuZ2xlX3JhdG'
    'VfehgGIAEoAVIKYW5nbGVSYXRlWg==');

@$core.Deprecated('Use wiFiAccessPointDescriptor instead')
const WiFiAccessPoint$json = {
  '1': 'WiFiAccessPoint',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ssid', '17': true},
    {'1': 'psk', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'psk', '17': true},
    {
      '1': 'channel',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 2,
      '10': 'channel',
      '17': true
    },
  ],
  '8': [
    {'1': '_ssid'},
    {'1': '_psk'},
    {'1': '_channel'},
  ],
};

/// Descriptor for `WiFiAccessPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wiFiAccessPointDescriptor = $convert.base64Decode(
    'Cg9XaUZpQWNjZXNzUG9pbnQSFwoEc3NpZBgBIAEoCUgAUgRzc2lkiAEBEhUKA3BzaxgCIAEoCU'
    'gBUgNwc2uIAQESHQoHY2hhbm5lbBgDIAEoBUgCUgdjaGFubmVsiAEBQgcKBV9zc2lkQgYKBF9w'
    'c2tCCgoIX2NoYW5uZWw=');

@$core.Deprecated('Use fixedSettingsDescriptor instead')
const FixedSettings$json = {
  '1': 'FixedSettings',
  '2': [
    {
      '1': 'observer_location',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.LatLong',
      '9': 0,
      '10': 'observerLocation',
      '17': true
    },
    {
      '1': 'current_time',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 1,
      '10': 'currentTime',
      '17': true
    },
    {
      '1': 'session_name',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'sessionName',
      '17': true
    },
    {
      '1': 'max_exposure_time',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '9': 3,
      '10': 'maxExposureTime',
      '17': true
    },
  ],
  '8': [
    {'1': '_observer_location'},
    {'1': '_current_time'},
    {'1': '_session_name'},
    {'1': '_max_exposure_time'},
  ],
};

/// Descriptor for `FixedSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fixedSettingsDescriptor = $convert.base64Decode(
    'Cg1GaXhlZFNldHRpbmdzEkAKEW9ic2VydmVyX2xvY2F0aW9uGAIgASgLMg4uY2VkYXIuTGF0TG'
    '9uZ0gAUhBvYnNlcnZlckxvY2F0aW9uiAEBEkIKDGN1cnJlbnRfdGltZRgEIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBIAVILY3VycmVudFRpbWWIAQESJgoMc2Vzc2lvbl9uYW1lGA'
    'UgASgJSAJSC3Nlc3Npb25OYW1liAEBEkoKEW1heF9leHBvc3VyZV90aW1lGAYgASgLMhkuZ29v'
    'Z2xlLnByb3RvYnVmLkR1cmF0aW9uSANSD21heEV4cG9zdXJlVGltZYgBAUIUChJfb2JzZXJ2ZX'
    'JfbG9jYXRpb25CDwoNX2N1cnJlbnRfdGltZUIPCg1fc2Vzc2lvbl9uYW1lQhQKEl9tYXhfZXhw'
    'b3N1cmVfdGltZQ==');

@$core.Deprecated('Use latLongDescriptor instead')
const LatLong$json = {
  '1': 'LatLong',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `LatLong`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latLongDescriptor = $convert.base64Decode(
    'CgdMYXRMb25nEhoKCGxhdGl0dWRlGAEgASgBUghsYXRpdHVkZRIcCglsb25naXR1ZGUYAiABKA'
    'FSCWxvbmdpdHVkZQ==');

@$core.Deprecated('Use operationSettingsDescriptor instead')
const OperationSettings$json = {
  '1': 'OperationSettings',
  '2': [
    {
      '1': 'operating_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.cedar.OperatingMode',
      '9': 0,
      '10': 'operatingMode',
      '17': true
    },
    {
      '1': 'daylight_mode',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'daylightMode',
      '17': true
    },
    {
      '1': 'focus_assist_mode',
      '3': 14,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'focusAssistMode',
      '17': true
    },
    {
      '1': 'log_dwelled_positions',
      '3': 10,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'logDwelledPositions',
      '17': true
    },
    {
      '1': 'catalog_entry_match',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.CatalogEntryMatch',
      '9': 4,
      '10': 'catalogEntryMatch',
      '17': true
    },
    {
      '1': 'demo_image_filename',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'demoImageFilename',
      '17': true
    },
    {
      '1': 'use_imu',
      '3': 15,
      '4': 1,
      '5': 8,
      '9': 6,
      '10': 'useImu',
      '17': true
    },
  ],
  '8': [
    {'1': '_operating_mode'},
    {'1': '_daylight_mode'},
    {'1': '_focus_assist_mode'},
    {'1': '_log_dwelled_positions'},
    {'1': '_catalog_entry_match'},
    {'1': '_demo_image_filename'},
    {'1': '_use_imu'},
  ],
  '9': [
    {'1': 3, '2': 4},
    {'1': 5, '2': 6},
    {'1': 7, '2': 8},
    {'1': 8, '2': 9},
    {'1': 13, '2': 14},
  ],
};

/// Descriptor for `OperationSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationSettingsDescriptor = $convert.base64Decode(
    'ChFPcGVyYXRpb25TZXR0aW5ncxJACg5vcGVyYXRpbmdfbW9kZRgEIAEoDjIULmNlZGFyLk9wZX'
    'JhdGluZ01vZGVIAFINb3BlcmF0aW5nTW9kZYgBARIoCg1kYXlsaWdodF9tb2RlGAEgASgISAFS'
    'DGRheWxpZ2h0TW9kZYgBARIvChFmb2N1c19hc3Npc3RfbW9kZRgOIAEoCEgCUg9mb2N1c0Fzc2'
    'lzdE1vZGWIAQESNwoVbG9nX2R3ZWxsZWRfcG9zaXRpb25zGAogASgISANSE2xvZ0R3ZWxsZWRQ'
    'b3NpdGlvbnOIAQESUQoTY2F0YWxvZ19lbnRyeV9tYXRjaBgLIAEoCzIcLmNlZGFyX3NreS5DYX'
    'RhbG9nRW50cnlNYXRjaEgEUhFjYXRhbG9nRW50cnlNYXRjaIgBARIzChNkZW1vX2ltYWdlX2Zp'
    'bGVuYW1lGAwgASgJSAVSEWRlbW9JbWFnZUZpbGVuYW1liAEBEhwKB3VzZV9pbXUYDyABKAhIBl'
    'IGdXNlSW11iAEBQhEKD19vcGVyYXRpbmdfbW9kZUIQCg5fZGF5bGlnaHRfbW9kZUIUChJfZm9j'
    'dXNfYXNzaXN0X21vZGVCGAoWX2xvZ19kd2VsbGVkX3Bvc2l0aW9uc0IWChRfY2F0YWxvZ19lbn'
    'RyeV9tYXRjaEIWChRfZGVtb19pbWFnZV9maWxlbmFtZUIKCghfdXNlX2ltdUoECAMQBEoECAUQ'
    'BkoECAcQCEoECAgQCUoECA0QDg==');

@$core.Deprecated('Use preferencesDescriptor instead')
const Preferences$json = {
  '1': 'Preferences',
  '2': [
    {
      '1': 'celestial_coord_format',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.cedar.CelestialCoordFormat',
      '9': 0,
      '10': 'celestialCoordFormat',
      '17': true
    },
    {
      '1': 'eyepiece_fov',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'eyepieceFov',
      '17': true
    },
    {
      '1': 'night_vision_theme',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 2,
      '10': 'nightVisionTheme',
      '17': true
    },
    {
      '1': 'hide_app_bar',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'hideAppBar',
      '17': true
    },
    {
      '1': 'mount_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.cedar.MountType',
      '9': 4,
      '10': 'mountType',
      '17': true
    },
    {
      '1': 'observer_location',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.cedar.LatLong',
      '9': 5,
      '10': 'observerLocation',
      '17': true
    },
    {
      '1': 'catalog_entry_match',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.CatalogEntryMatch',
      '9': 6,
      '10': 'catalogEntryMatch',
      '17': true
    },
    {
      '1': 'max_distance_active',
      '3': 15,
      '4': 1,
      '5': 8,
      '9': 7,
      '10': 'maxDistanceActive',
      '17': true
    },
    {
      '1': 'max_distance',
      '3': 12,
      '4': 1,
      '5': 1,
      '9': 8,
      '10': 'maxDistance',
      '17': true
    },
    {
      '1': 'min_elevation_active',
      '3': 16,
      '4': 1,
      '5': 8,
      '9': 9,
      '10': 'minElevationActive',
      '17': true
    },
    {
      '1': 'min_elevation',
      '3': 13,
      '4': 1,
      '5': 1,
      '9': 10,
      '10': 'minElevation',
      '17': true
    },
    {
      '1': 'ordering',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.cedar_sky.Ordering',
      '9': 11,
      '10': 'ordering',
      '17': true
    },
    {
      '1': 'advanced',
      '3': 17,
      '4': 1,
      '5': 8,
      '9': 12,
      '10': 'advanced',
      '17': true
    },
    {
      '1': 'text_size_index',
      '3': 18,
      '4': 1,
      '5': 5,
      '9': 13,
      '10': 'textSizeIndex',
      '17': true
    },
    {
      '1': 'boresight_pixel',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '9': 14,
      '10': 'boresightPixel',
      '17': true
    },
    {
      '1': 'right_handed',
      '3': 21,
      '4': 1,
      '5': 8,
      '9': 15,
      '10': 'rightHanded',
      '17': true
    },
    {
      '1': 'celestial_coord_choice',
      '3': 22,
      '4': 1,
      '5': 9,
      '9': 16,
      '10': 'celestialCoordChoice',
      '17': true
    },
    {
      '1': 'perf_gauge_choice',
      '3': 33,
      '4': 1,
      '5': 9,
      '9': 17,
      '10': 'perfGaugeChoice',
      '17': true
    },
    {
      '1': 'screen_always_on',
      '3': 23,
      '4': 1,
      '5': 8,
      '9': 18,
      '10': 'screenAlwaysOn',
      '17': true
    },
    {'1': 'dont_show_items', '3': 32, '4': 3, '5': 9, '10': 'dontShowItems'},
    {
      '1': 'use_bluetooth',
      '3': 34,
      '4': 1,
      '5': 8,
      '9': 19,
      '10': 'useBluetooth',
      '17': true
    },
  ],
  '8': [
    {'1': '_celestial_coord_format'},
    {'1': '_eyepiece_fov'},
    {'1': '_night_vision_theme'},
    {'1': '_hide_app_bar'},
    {'1': '_mount_type'},
    {'1': '_observer_location'},
    {'1': '_catalog_entry_match'},
    {'1': '_max_distance_active'},
    {'1': '_max_distance'},
    {'1': '_min_elevation_active'},
    {'1': '_min_elevation'},
    {'1': '_ordering'},
    {'1': '_advanced'},
    {'1': '_text_size_index'},
    {'1': '_boresight_pixel'},
    {'1': '_right_handed'},
    {'1': '_celestial_coord_choice'},
    {'1': '_perf_gauge_choice'},
    {'1': '_screen_always_on'},
    {'1': '_use_bluetooth'},
  ],
  '9': [
    {'1': 4, '2': 5},
    {'1': 8, '2': 9},
    {'1': 9, '2': 10},
    {'1': 20, '2': 21},
    {'1': 24, '2': 25},
    {'1': 25, '2': 26},
    {'1': 26, '2': 27},
    {'1': 27, '2': 28},
    {'1': 28, '2': 29},
    {'1': 29, '2': 30},
    {'1': 30, '2': 31},
    {'1': 31, '2': 32},
  ],
};

/// Descriptor for `Preferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preferencesDescriptor = $convert.base64Decode(
    'CgtQcmVmZXJlbmNlcxJWChZjZWxlc3RpYWxfY29vcmRfZm9ybWF0GAEgASgOMhsuY2VkYXIuQ2'
    'VsZXN0aWFsQ29vcmRGb3JtYXRIAFIUY2VsZXN0aWFsQ29vcmRGb3JtYXSIAQESJgoMZXllcGll'
    'Y2VfZm92GAIgASgBSAFSC2V5ZXBpZWNlRm92iAEBEjEKEm5pZ2h0X3Zpc2lvbl90aGVtZRgDIA'
    'EoCEgCUhBuaWdodFZpc2lvblRoZW1liAEBEiUKDGhpZGVfYXBwX2JhchgFIAEoCEgDUgpoaWRl'
    'QXBwQmFyiAEBEjQKCm1vdW50X3R5cGUYBiABKA4yEC5jZWRhci5Nb3VudFR5cGVIBFIJbW91bn'
    'RUeXBliAEBEkAKEW9ic2VydmVyX2xvY2F0aW9uGAcgASgLMg4uY2VkYXIuTGF0TG9uZ0gFUhBv'
    'YnNlcnZlckxvY2F0aW9uiAEBElEKE2NhdGFsb2dfZW50cnlfbWF0Y2gYCyABKAsyHC5jZWRhcl'
    '9za3kuQ2F0YWxvZ0VudHJ5TWF0Y2hIBlIRY2F0YWxvZ0VudHJ5TWF0Y2iIAQESMwoTbWF4X2Rp'
    'c3RhbmNlX2FjdGl2ZRgPIAEoCEgHUhFtYXhEaXN0YW5jZUFjdGl2ZYgBARImCgxtYXhfZGlzdG'
    'FuY2UYDCABKAFICFILbWF4RGlzdGFuY2WIAQESNQoUbWluX2VsZXZhdGlvbl9hY3RpdmUYECAB'
    'KAhICVISbWluRWxldmF0aW9uQWN0aXZliAEBEigKDW1pbl9lbGV2YXRpb24YDSABKAFIClIMbW'
    'luRWxldmF0aW9uiAEBEjQKCG9yZGVyaW5nGA4gASgOMhMuY2VkYXJfc2t5Lk9yZGVyaW5nSAtS'
    'CG9yZGVyaW5niAEBEh8KCGFkdmFuY2VkGBEgASgISAxSCGFkdmFuY2VkiAEBEisKD3RleHRfc2'
    'l6ZV9pbmRleBgSIAEoBUgNUg10ZXh0U2l6ZUluZGV4iAEBEj8KD2JvcmVzaWdodF9waXhlbBgT'
    'IAEoCzIRLmNlZGFyLkltYWdlQ29vcmRIDlIOYm9yZXNpZ2h0UGl4ZWyIAQESJgoMcmlnaHRfaG'
    'FuZGVkGBUgASgISA9SC3JpZ2h0SGFuZGVkiAEBEjkKFmNlbGVzdGlhbF9jb29yZF9jaG9pY2UY'
    'FiABKAlIEFIUY2VsZXN0aWFsQ29vcmRDaG9pY2WIAQESLwoRcGVyZl9nYXVnZV9jaG9pY2UYIS'
    'ABKAlIEVIPcGVyZkdhdWdlQ2hvaWNliAEBEi0KEHNjcmVlbl9hbHdheXNfb24YFyABKAhIElIO'
    'c2NyZWVuQWx3YXlzT26IAQESJgoPZG9udF9zaG93X2l0ZW1zGCAgAygJUg1kb250U2hvd0l0ZW'
    '1zEigKDXVzZV9ibHVldG9vdGgYIiABKAhIE1IMdXNlQmx1ZXRvb3RoiAEBQhkKF19jZWxlc3Rp'
    'YWxfY29vcmRfZm9ybWF0Qg8KDV9leWVwaWVjZV9mb3ZCFQoTX25pZ2h0X3Zpc2lvbl90aGVtZU'
    'IPCg1faGlkZV9hcHBfYmFyQg0KC19tb3VudF90eXBlQhQKEl9vYnNlcnZlcl9sb2NhdGlvbkIW'
    'ChRfY2F0YWxvZ19lbnRyeV9tYXRjaEIWChRfbWF4X2Rpc3RhbmNlX2FjdGl2ZUIPCg1fbWF4X2'
    'Rpc3RhbmNlQhcKFV9taW5fZWxldmF0aW9uX2FjdGl2ZUIQCg5fbWluX2VsZXZhdGlvbkILCglf'
    'b3JkZXJpbmdCCwoJX2FkdmFuY2VkQhIKEF90ZXh0X3NpemVfaW5kZXhCEgoQX2JvcmVzaWdodF'
    '9waXhlbEIPCg1fcmlnaHRfaGFuZGVkQhkKF19jZWxlc3RpYWxfY29vcmRfY2hvaWNlQhQKEl9w'
    'ZXJmX2dhdWdlX2Nob2ljZUITChFfc2NyZWVuX2Fsd2F5c19vbkIQCg5fdXNlX2JsdWV0b290aE'
    'oECAQQBUoECAgQCUoECAkQCkoECBQQFUoECBgQGUoECBkQGkoECBoQG0oECBsQHEoECBwQHUoE'
    'CB0QHkoECB4QH0oECB8QIA==');

@$core.Deprecated('Use frameRequestDescriptor instead')
const FrameRequest$json = {
  '1': 'FrameRequest',
  '2': [
    {
      '1': 'prev_frame_id',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'prevFrameId',
      '17': true
    },
    {
      '1': 'non_blocking',
      '3': 2,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'nonBlocking',
      '17': true
    },
    {
      '1': 'display_orientation',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.cedar.DisplayOrientation',
      '9': 2,
      '10': 'displayOrientation',
      '17': true
    },
  ],
  '8': [
    {'1': '_prev_frame_id'},
    {'1': '_non_blocking'},
    {'1': '_display_orientation'},
  ],
};

/// Descriptor for `FrameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameRequestDescriptor = $convert.base64Decode(
    'CgxGcmFtZVJlcXVlc3QSJwoNcHJldl9mcmFtZV9pZBgBIAEoBUgAUgtwcmV2RnJhbWVJZIgBAR'
    'ImCgxub25fYmxvY2tpbmcYAiABKAhIAVILbm9uQmxvY2tpbmeIAQESTwoTZGlzcGxheV9vcmll'
    'bnRhdGlvbhgDIAEoDjIZLmNlZGFyLkRpc3BsYXlPcmllbnRhdGlvbkgCUhJkaXNwbGF5T3JpZW'
    '50YXRpb26IAQFCEAoOX3ByZXZfZnJhbWVfaWRCDwoNX25vbl9ibG9ja2luZ0IWChRfZGlzcGxh'
    'eV9vcmllbnRhdGlvbg==');

@$core.Deprecated('Use frameResultDescriptor instead')
const FrameResult$json = {
  '1': 'FrameResult',
  '2': [
    {
      '1': 'has_result',
      '3': 34,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'hasResult',
      '17': true
    },
    {'1': 'frame_id', '3': 1, '4': 1, '5': 5, '10': 'frameId'},
    {
      '1': 'server_information',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.cedar.ServerInformation',
      '10': 'serverInformation'
    },
    {
      '1': 'fixed_settings',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.cedar.FixedSettings',
      '10': 'fixedSettings'
    },
    {
      '1': 'preferences',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.cedar.Preferences',
      '10': 'preferences'
    },
    {
      '1': 'operation_settings',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.OperationSettings',
      '10': 'operationSettings'
    },
    {
      '1': 'calibration_data',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.cedar.CalibrationData',
      '10': 'calibrationData'
    },
    {'1': 'image', '3': 3, '4': 1, '5': 11, '6': '.cedar.Image', '10': 'image'},
    {
      '1': 'exposure_time',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'exposureTime'
    },
    {
      '1': 'capture_time',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'captureTime'
    },
    {
      '1': 'star_candidates',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.cedar.StarCentroid',
      '10': 'starCandidates'
    },
    {
      '1': 'star_count_moving_average',
      '3': 35,
      '4': 1,
      '5': 1,
      '10': 'starCountMovingAverage'
    },
    {
      '1': 'plate_solution',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.cedar.PlateSolution',
      '9': 1,
      '10': 'plateSolution',
      '17': true
    },
    {'1': 'noise_estimate', '3': 26, '4': 1, '5': 1, '10': 'noiseEstimate'},
    {
      '1': 'processing_stats',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.cedar.ProcessingStats',
      '10': 'processingStats'
    },
    {
      '1': 'boresight_position',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'boresightPosition'
    },
    {'1': 'calibrating', '3': 22, '4': 1, '5': 8, '10': 'calibrating'},
    {
      '1': 'calibration_progress',
      '3': 23,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'calibrationProgress',
      '17': true
    },
    {
      '1': 'center_peak_position',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '9': 3,
      '10': 'centerPeakPosition',
      '17': true
    },
    {
      '1': 'center_peak_value',
      '3': 6,
      '4': 1,
      '5': 5,
      '9': 4,
      '10': 'centerPeakValue',
      '17': true
    },
    {
      '1': 'center_peak_image',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.cedar.Image',
      '9': 5,
      '10': 'centerPeakImage',
      '17': true
    },
    {
      '1': 'contrast_ratio',
      '3': 36,
      '4': 1,
      '5': 1,
      '9': 6,
      '10': 'contrastRatio',
      '17': true
    },
    {
      '1': 'daylight_focus_zoom_image',
      '3': 37,
      '4': 1,
      '5': 11,
      '6': '.cedar.Image',
      '9': 7,
      '10': 'daylightFocusZoomImage',
      '17': true
    },
    {
      '1': 'location_based_info',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.cedar.LocationBasedInfo',
      '9': 8,
      '10': 'locationBasedInfo',
      '17': true
    },
    {
      '1': 'slew_request',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.cedar.SlewRequest',
      '9': 9,
      '10': 'slewRequest',
      '17': true
    },
    {
      '1': 'boresight_image',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.cedar.Image',
      '9': 10,
      '10': 'boresightImage',
      '17': true
    },
    {
      '1': 'polar_align_advice',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.cedar.PolarAlignAdvice',
      '10': 'polarAlignAdvice'
    },
    {
      '1': 'labeled_catalog_entries',
      '3': 31,
      '4': 3,
      '5': 11,
      '6': '.cedar.FovCatalogEntry',
      '10': 'labeledCatalogEntries'
    },
    {
      '1': 'unlabeled_catalog_entries',
      '3': 33,
      '4': 3,
      '5': 11,
      '6': '.cedar.FovCatalogEntry',
      '10': 'unlabeledCatalogEntries'
    },
  ],
  '8': [
    {'1': '_has_result'},
    {'1': '_plate_solution'},
    {'1': '_calibration_progress'},
    {'1': '_center_peak_position'},
    {'1': '_center_peak_value'},
    {'1': '_center_peak_image'},
    {'1': '_contrast_ratio'},
    {'1': '_daylight_focus_zoom_image'},
    {'1': '_location_based_info'},
    {'1': '_slew_request'},
    {'1': '_boresight_image'},
  ],
  '9': [
    {'1': 10, '2': 11},
    {'1': 11, '2': 12},
  ],
};

/// Descriptor for `FrameResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameResultDescriptor = $convert.base64Decode(
    'CgtGcmFtZVJlc3VsdBIiCgpoYXNfcmVzdWx0GCIgASgISABSCWhhc1Jlc3VsdIgBARIZCghmcm'
    'FtZV9pZBgBIAEoBVIHZnJhbWVJZBJHChJzZXJ2ZXJfaW5mb3JtYXRpb24YICABKAsyGC5jZWRh'
    'ci5TZXJ2ZXJJbmZvcm1hdGlvblIRc2VydmVySW5mb3JtYXRpb24SOwoOZml4ZWRfc2V0dGluZ3'
    'MYGyABKAsyFC5jZWRhci5GaXhlZFNldHRpbmdzUg1maXhlZFNldHRpbmdzEjQKC3ByZWZlcmVu'
    'Y2VzGBkgASgLMhIuY2VkYXIuUHJlZmVyZW5jZXNSC3ByZWZlcmVuY2VzEkcKEm9wZXJhdGlvbl'
    '9zZXR0aW5ncxgCIAEoCzIYLmNlZGFyLk9wZXJhdGlvblNldHRpbmdzUhFvcGVyYXRpb25TZXR0'
    'aW5ncxJBChBjYWxpYnJhdGlvbl9kYXRhGAUgASgLMhYuY2VkYXIuQ2FsaWJyYXRpb25EYXRhUg'
    '9jYWxpYnJhdGlvbkRhdGESIgoFaW1hZ2UYAyABKAsyDC5jZWRhci5JbWFnZVIFaW1hZ2USPgoN'
    'ZXhwb3N1cmVfdGltZRgHIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvblIMZXhwb3N1cm'
    'VUaW1lEj0KDGNhcHR1cmVfdGltZRgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'C2NhcHR1cmVUaW1lEjwKD3N0YXJfY2FuZGlkYXRlcxgEIAMoCzITLmNlZGFyLlN0YXJDZW50cm'
    '9pZFIOc3RhckNhbmRpZGF0ZXMSOQoZc3Rhcl9jb3VudF9tb3ZpbmdfYXZlcmFnZRgjIAEoAVIW'
    'c3RhckNvdW50TW92aW5nQXZlcmFnZRJACg5wbGF0ZV9zb2x1dGlvbhgRIAEoCzIULmNlZGFyLl'
    'BsYXRlU29sdXRpb25IAVINcGxhdGVTb2x1dGlvbogBARIlCg5ub2lzZV9lc3RpbWF0ZRgaIAEo'
    'AVINbm9pc2VFc3RpbWF0ZRJBChBwcm9jZXNzaW5nX3N0YXRzGAggASgLMhYuY2VkYXIuUHJvY2'
    'Vzc2luZ1N0YXRzUg9wcm9jZXNzaW5nU3RhdHMSQAoSYm9yZXNpZ2h0X3Bvc2l0aW9uGBUgASgL'
    'MhEuY2VkYXIuSW1hZ2VDb29yZFIRYm9yZXNpZ2h0UG9zaXRpb24SIAoLY2FsaWJyYXRpbmcYFi'
    'ABKAhSC2NhbGlicmF0aW5nEjYKFGNhbGlicmF0aW9uX3Byb2dyZXNzGBcgASgBSAJSE2NhbGli'
    'cmF0aW9uUHJvZ3Jlc3OIAQESSAoUY2VudGVyX3BlYWtfcG9zaXRpb24YDCABKAsyES5jZWRhci'
    '5JbWFnZUNvb3JkSANSEmNlbnRlclBlYWtQb3NpdGlvbogBARIvChFjZW50ZXJfcGVha192YWx1'
    'ZRgGIAEoBUgEUg9jZW50ZXJQZWFrVmFsdWWIAQESPQoRY2VudGVyX3BlYWtfaW1hZ2UYDSABKA'
    'syDC5jZWRhci5JbWFnZUgFUg9jZW50ZXJQZWFrSW1hZ2WIAQESKgoOY29udHJhc3RfcmF0aW8Y'
    'JCABKAFIBlINY29udHJhc3RSYXRpb4gBARJMChlkYXlsaWdodF9mb2N1c196b29tX2ltYWdlGC'
    'UgASgLMgwuY2VkYXIuSW1hZ2VIB1IWZGF5bGlnaHRGb2N1c1pvb21JbWFnZYgBARJNChNsb2Nh'
    'dGlvbl9iYXNlZF9pbmZvGB0gASgLMhguY2VkYXIuTG9jYXRpb25CYXNlZEluZm9ICFIRbG9jYX'
    'Rpb25CYXNlZEluZm+IAQESOgoMc2xld19yZXF1ZXN0GBggASgLMhIuY2VkYXIuU2xld1JlcXVl'
    'c3RICVILc2xld1JlcXVlc3SIAQESOgoPYm9yZXNpZ2h0X2ltYWdlGBwgASgLMgwuY2VkYXIuSW'
    '1hZ2VIClIOYm9yZXNpZ2h0SW1hZ2WIAQESRQoScG9sYXJfYWxpZ25fYWR2aWNlGB4gASgLMhcu'
    'Y2VkYXIuUG9sYXJBbGlnbkFkdmljZVIQcG9sYXJBbGlnbkFkdmljZRJOChdsYWJlbGVkX2NhdG'
    'Fsb2dfZW50cmllcxgfIAMoCzIWLmNlZGFyLkZvdkNhdGFsb2dFbnRyeVIVbGFiZWxlZENhdGFs'
    'b2dFbnRyaWVzElIKGXVubGFiZWxlZF9jYXRhbG9nX2VudHJpZXMYISADKAsyFi5jZWRhci5Gb3'
    'ZDYXRhbG9nRW50cnlSF3VubGFiZWxlZENhdGFsb2dFbnRyaWVzQg0KC19oYXNfcmVzdWx0QhEK'
    'D19wbGF0ZV9zb2x1dGlvbkIXChVfY2FsaWJyYXRpb25fcHJvZ3Jlc3NCFwoVX2NlbnRlcl9wZW'
    'FrX3Bvc2l0aW9uQhQKEl9jZW50ZXJfcGVha192YWx1ZUIUChJfY2VudGVyX3BlYWtfaW1hZ2VC'
    'EQoPX2NvbnRyYXN0X3JhdGlvQhwKGl9kYXlsaWdodF9mb2N1c196b29tX2ltYWdlQhYKFF9sb2'
    'NhdGlvbl9iYXNlZF9pbmZvQg8KDV9zbGV3X3JlcXVlc3RCEgoQX2JvcmVzaWdodF9pbWFnZUoE'
    'CAoQC0oECAsQDA==');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'binning_factor', '3': 1, '4': 1, '5': 5, '10': 'binningFactor'},
    {
      '1': 'rectangle',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.Rectangle',
      '10': 'rectangle'
    },
    {'1': 'image_data', '3': 3, '4': 1, '5': 12, '10': 'imageData'},
    {
      '1': 'rotation_size_ratio',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'rotationSizeRatio'
    },
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIlCg5iaW5uaW5nX2ZhY3RvchgBIAEoBVINYmlubmluZ0ZhY3RvchIuCglyZWN0YW'
    '5nbGUYAiABKAsyEC5jZWRhci5SZWN0YW5nbGVSCXJlY3RhbmdsZRIdCgppbWFnZV9kYXRhGAMg'
    'ASgMUglpbWFnZURhdGESLgoTcm90YXRpb25fc2l6ZV9yYXRpbxgEIAEoAVIRcm90YXRpb25TaX'
    'plUmF0aW8=');

@$core.Deprecated('Use rectangleDescriptor instead')
const Rectangle$json = {
  '1': 'Rectangle',
  '2': [
    {'1': 'origin_x', '3': 1, '4': 1, '5': 5, '10': 'originX'},
    {'1': 'origin_y', '3': 2, '4': 1, '5': 5, '10': 'originY'},
    {'1': 'width', '3': 3, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
  ],
};

/// Descriptor for `Rectangle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rectangleDescriptor = $convert.base64Decode(
    'CglSZWN0YW5nbGUSGQoIb3JpZ2luX3gYASABKAVSB29yaWdpblgSGQoIb3JpZ2luX3kYAiABKA'
    'VSB29yaWdpblkSFAoFd2lkdGgYAyABKAVSBXdpZHRoEhYKBmhlaWdodBgEIAEoBVIGaGVpZ2h0');

@$core.Deprecated('Use starCentroidDescriptor instead')
const StarCentroid$json = {
  '1': 'StarCentroid',
  '2': [
    {
      '1': 'centroid_position',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'centroidPosition'
    },
    {'1': 'brightness', '3': 4, '4': 1, '5': 1, '10': 'brightness'},
    {'1': 'num_saturated', '3': 6, '4': 1, '5': 5, '10': 'numSaturated'},
  ],
};

/// Descriptor for `StarCentroid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List starCentroidDescriptor = $convert.base64Decode(
    'CgxTdGFyQ2VudHJvaWQSPgoRY2VudHJvaWRfcG9zaXRpb24YASABKAsyES5jZWRhci5JbWFnZU'
    'Nvb3JkUhBjZW50cm9pZFBvc2l0aW9uEh4KCmJyaWdodG5lc3MYBCABKAFSCmJyaWdodG5lc3MS'
    'IwoNbnVtX3NhdHVyYXRlZBgGIAEoBVIMbnVtU2F0dXJhdGVk');

@$core.Deprecated('Use imageCoordDescriptor instead')
const ImageCoord$json = {
  '1': 'ImageCoord',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `ImageCoord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageCoordDescriptor = $convert
    .base64Decode('CgpJbWFnZUNvb3JkEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use plateSolutionDescriptor instead')
const PlateSolution$json = {
  '1': 'PlateSolution',
  '2': [
    {
      '1': 'image_sky_coord',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '10': 'imageSkyCoord'
    },
    {'1': 'roll', '3': 2, '4': 1, '5': 1, '10': 'roll'},
    {'1': 'fov', '3': 3, '4': 1, '5': 1, '10': 'fov'},
    {
      '1': 'distortion',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'distortion',
      '17': true
    },
    {'1': 'rmse', '3': 5, '4': 1, '5': 1, '10': 'rmse'},
    {'1': 'p90_error', '3': 6, '4': 1, '5': 1, '10': 'p90Error'},
    {'1': 'max_error', '3': 7, '4': 1, '5': 1, '10': 'maxError'},
    {'1': 'num_matches', '3': 8, '4': 1, '5': 5, '10': 'numMatches'},
    {'1': 'prob', '3': 9, '4': 1, '5': 1, '10': 'prob'},
    {'1': 'epoch_equinox', '3': 10, '4': 1, '5': 5, '10': 'epochEquinox'},
    {
      '1': 'epoch_proper_motion',
      '3': 11,
      '4': 1,
      '5': 2,
      '10': 'epochProperMotion'
    },
    {
      '1': 'solve_time',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '10': 'solveTime'
    },
    {
      '1': 'target_sky_coord',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '10': 'targetSkyCoord'
    },
    {
      '1': 'target_pixel',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'targetPixel'
    },
    {
      '1': 'matched_stars',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.cedar.StarInfo',
      '10': 'matchedStars'
    },
    {
      '1': 'pattern_centroids',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'patternCentroids'
    },
    {
      '1': 'catalog_stars',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.cedar.StarInfo',
      '10': 'catalogStars'
    },
    {'1': 'rotation_matrix', '3': 18, '4': 3, '5': 1, '10': 'rotationMatrix'},
    {
      '1': 'solution_from_imu',
      '3': 19,
      '4': 1,
      '5': 8,
      '10': 'solutionFromImu'
    },
  ],
  '8': [
    {'1': '_distortion'},
  ],
};

/// Descriptor for `PlateSolution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List plateSolutionDescriptor = $convert.base64Decode(
    'Cg1QbGF0ZVNvbHV0aW9uEkQKD2ltYWdlX3NreV9jb29yZBgBIAEoCzIcLmNlZGFyX2NvbW1vbi'
    '5DZWxlc3RpYWxDb29yZFINaW1hZ2VTa3lDb29yZBISCgRyb2xsGAIgASgBUgRyb2xsEhAKA2Zv'
    'dhgDIAEoAVIDZm92EiMKCmRpc3RvcnRpb24YBCABKAFIAFIKZGlzdG9ydGlvbogBARISCgRybX'
    'NlGAUgASgBUgRybXNlEhsKCXA5MF9lcnJvchgGIAEoAVIIcDkwRXJyb3ISGwoJbWF4X2Vycm9y'
    'GAcgASgBUghtYXhFcnJvchIfCgtudW1fbWF0Y2hlcxgIIAEoBVIKbnVtTWF0Y2hlcxISCgRwcm'
    '9iGAkgASgBUgRwcm9iEiMKDWVwb2NoX2VxdWlub3gYCiABKAVSDGVwb2NoRXF1aW5veBIuChNl'
    'cG9jaF9wcm9wZXJfbW90aW9uGAsgASgCUhFlcG9jaFByb3Blck1vdGlvbhI4Cgpzb2x2ZV90aW'
    '1lGAwgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uUglzb2x2ZVRpbWUSRgoQdGFyZ2V0'
    'X3NreV9jb29yZBgNIAMoCzIcLmNlZGFyX2NvbW1vbi5DZWxlc3RpYWxDb29yZFIOdGFyZ2V0U2'
    't5Q29vcmQSNAoMdGFyZ2V0X3BpeGVsGA4gAygLMhEuY2VkYXIuSW1hZ2VDb29yZFILdGFyZ2V0'
    'UGl4ZWwSNAoNbWF0Y2hlZF9zdGFycxgPIAMoCzIPLmNlZGFyLlN0YXJJbmZvUgxtYXRjaGVkU3'
    'RhcnMSPgoRcGF0dGVybl9jZW50cm9pZHMYECADKAsyES5jZWRhci5JbWFnZUNvb3JkUhBwYXR0'
    'ZXJuQ2VudHJvaWRzEjQKDWNhdGFsb2dfc3RhcnMYESADKAsyDy5jZWRhci5TdGFySW5mb1IMY2'
    'F0YWxvZ1N0YXJzEicKD3JvdGF0aW9uX21hdHJpeBgSIAMoAVIOcm90YXRpb25NYXRyaXgSKgoR'
    'c29sdXRpb25fZnJvbV9pbXUYEyABKAhSD3NvbHV0aW9uRnJvbUltdUINCgtfZGlzdG9ydGlvbg'
    '==');

@$core.Deprecated('Use starInfoDescriptor instead')
const StarInfo$json = {
  '1': 'StarInfo',
  '2': [
    {
      '1': 'pixel',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'pixel'
    },
    {
      '1': 'sky_coord',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '10': 'skyCoord'
    },
    {'1': 'mag', '3': 3, '4': 1, '5': 2, '10': 'mag'},
  ],
};

/// Descriptor for `StarInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List starInfoDescriptor = $convert.base64Decode(
    'CghTdGFySW5mbxInCgVwaXhlbBgBIAEoCzIRLmNlZGFyLkltYWdlQ29vcmRSBXBpeGVsEjkKCX'
    'NreV9jb29yZBgCIAEoCzIcLmNlZGFyX2NvbW1vbi5DZWxlc3RpYWxDb29yZFIIc2t5Q29vcmQS'
    'EAoDbWFnGAMgASgCUgNtYWc=');

@$core.Deprecated('Use processingStatsDescriptor instead')
const ProcessingStats$json = {
  '1': 'ProcessingStats',
  '2': [
    {
      '1': 'acquire_latency',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'acquireLatency'
    },
    {
      '1': 'detect_latency',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'detectLatency'
    },
    {
      '1': 'solve_latency',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'solveLatency'
    },
    {
      '1': 'solve_attempt_fraction',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'solveAttemptFraction'
    },
    {
      '1': 'solve_success_fraction',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'solveSuccessFraction'
    },
    {
      '1': 'serve_latency',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'serveLatency'
    },
    {
      '1': 'solve_interval',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.cedar.ValueStats',
      '10': 'solveInterval'
    },
  ],
  '9': [
    {'1': 1, '2': 2},
    {'1': 2, '2': 3},
  ],
};

/// Descriptor for `ProcessingStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processingStatsDescriptor = $convert.base64Decode(
    'Cg9Qcm9jZXNzaW5nU3RhdHMSOgoPYWNxdWlyZV9sYXRlbmN5GAkgASgLMhEuY2VkYXIuVmFsdW'
    'VTdGF0c1IOYWNxdWlyZUxhdGVuY3kSOAoOZGV0ZWN0X2xhdGVuY3kYAyABKAsyES5jZWRhci5W'
    'YWx1ZVN0YXRzUg1kZXRlY3RMYXRlbmN5EjYKDXNvbHZlX2xhdGVuY3kYBCABKAsyES5jZWRhci'
    '5WYWx1ZVN0YXRzUgxzb2x2ZUxhdGVuY3kSRwoWc29sdmVfYXR0ZW1wdF9mcmFjdGlvbhgFIAEo'
    'CzIRLmNlZGFyLlZhbHVlU3RhdHNSFHNvbHZlQXR0ZW1wdEZyYWN0aW9uEkcKFnNvbHZlX3N1Y2'
    'Nlc3NfZnJhY3Rpb24YBiABKAsyES5jZWRhci5WYWx1ZVN0YXRzUhRzb2x2ZVN1Y2Nlc3NGcmFj'
    'dGlvbhI2Cg1zZXJ2ZV9sYXRlbmN5GAcgASgLMhEuY2VkYXIuVmFsdWVTdGF0c1IMc2VydmVMYX'
    'RlbmN5EjgKDnNvbHZlX2ludGVydmFsGAggASgLMhEuY2VkYXIuVmFsdWVTdGF0c1INc29sdmVJ'
    'bnRlcnZhbEoECAEQAkoECAIQAw==');

@$core.Deprecated('Use valueStatsDescriptor instead')
const ValueStats$json = {
  '1': 'ValueStats',
  '2': [
    {
      '1': 'recent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar.DescriptiveStats',
      '9': 0,
      '10': 'recent',
      '17': true
    },
    {
      '1': 'session',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.DescriptiveStats',
      '9': 1,
      '10': 'session',
      '17': true
    },
  ],
  '8': [
    {'1': '_recent'},
    {'1': '_session'},
  ],
};

/// Descriptor for `ValueStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List valueStatsDescriptor = $convert.base64Decode(
    'CgpWYWx1ZVN0YXRzEjQKBnJlY2VudBgBIAEoCzIXLmNlZGFyLkRlc2NyaXB0aXZlU3RhdHNIAF'
    'IGcmVjZW50iAEBEjYKB3Nlc3Npb24YAiABKAsyFy5jZWRhci5EZXNjcmlwdGl2ZVN0YXRzSAFS'
    'B3Nlc3Npb26IAQFCCQoHX3JlY2VudEIKCghfc2Vzc2lvbg==');

@$core.Deprecated('Use descriptiveStatsDescriptor instead')
const DescriptiveStats$json = {
  '1': 'DescriptiveStats',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
    {'1': 'mean', '3': 3, '4': 1, '5': 1, '10': 'mean'},
    {'1': 'stddev', '3': 4, '4': 1, '5': 1, '10': 'stddev'},
    {'1': 'median', '3': 5, '4': 1, '5': 1, '9': 0, '10': 'median', '17': true},
    {
      '1': 'median_absolute_deviation',
      '3': 6,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'medianAbsoluteDeviation',
      '17': true
    },
  ],
  '8': [
    {'1': '_median'},
    {'1': '_median_absolute_deviation'},
  ],
};

/// Descriptor for `DescriptiveStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List descriptiveStatsDescriptor = $convert.base64Decode(
    'ChBEZXNjcmlwdGl2ZVN0YXRzEhAKA21pbhgBIAEoAVIDbWluEhAKA21heBgCIAEoAVIDbWF4Eh'
    'IKBG1lYW4YAyABKAFSBG1lYW4SFgoGc3RkZGV2GAQgASgBUgZzdGRkZXYSGwoGbWVkaWFuGAUg'
    'ASgBSABSBm1lZGlhbogBARI/ChltZWRpYW5fYWJzb2x1dGVfZGV2aWF0aW9uGAYgASgBSAFSF2'
    '1lZGlhbkFic29sdXRlRGV2aWF0aW9uiAEBQgkKB19tZWRpYW5CHAoaX21lZGlhbl9hYnNvbHV0'
    'ZV9kZXZpYXRpb24=');

@$core.Deprecated('Use calibrationDataDescriptor instead')
const CalibrationData$json = {
  '1': 'CalibrationData',
  '2': [
    {
      '1': 'calibration_time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'calibrationTime',
      '17': true
    },
    {
      '1': 'calibration_failure_reason',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.cedar.CalibrationFailureReason',
      '9': 1,
      '10': 'calibrationFailureReason',
      '17': true
    },
    {
      '1': 'target_exposure_time',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Duration',
      '9': 2,
      '10': 'targetExposureTime',
      '17': true
    },
    {
      '1': 'camera_offset',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'cameraOffset',
      '17': true
    },
    {
      '1': 'fov_horizontal',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 4,
      '10': 'fovHorizontal',
      '17': true
    },
    {
      '1': 'fov_vertical',
      '3': 11,
      '4': 1,
      '5': 1,
      '9': 5,
      '10': 'fovVertical',
      '17': true
    },
    {
      '1': 'lens_distortion',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 6,
      '10': 'lensDistortion',
      '17': true
    },
    {
      '1': 'match_max_error',
      '3': 8,
      '4': 1,
      '5': 1,
      '9': 7,
      '10': 'matchMaxError',
      '17': true
    },
    {
      '1': 'lens_fl_mm',
      '3': 6,
      '4': 1,
      '5': 1,
      '9': 8,
      '10': 'lensFlMm',
      '17': true
    },
    {
      '1': 'pixel_angular_size',
      '3': 7,
      '4': 1,
      '5': 1,
      '9': 9,
      '10': 'pixelAngularSize',
      '17': true
    },
    {
      '1': 'gyro_zero_bias_x',
      '3': 15,
      '4': 1,
      '5': 1,
      '9': 10,
      '10': 'gyroZeroBiasX',
      '17': true
    },
    {
      '1': 'gyro_zero_bias_y',
      '3': 16,
      '4': 1,
      '5': 1,
      '9': 11,
      '10': 'gyroZeroBiasY',
      '17': true
    },
    {
      '1': 'gyro_zero_bias_z',
      '3': 17,
      '4': 1,
      '5': 1,
      '9': 12,
      '10': 'gyroZeroBiasZ',
      '17': true
    },
    {
      '1': 'gyro_transform_error_fraction',
      '3': 18,
      '4': 1,
      '5': 1,
      '9': 13,
      '10': 'gyroTransformErrorFraction',
      '17': true
    },
    {
      '1': 'camera_view_gyro_axis',
      '3': 19,
      '4': 1,
      '5': 9,
      '9': 14,
      '10': 'cameraViewGyroAxis',
      '17': true
    },
    {
      '1': 'camera_view_misalignment',
      '3': 20,
      '4': 1,
      '5': 1,
      '9': 15,
      '10': 'cameraViewMisalignment',
      '17': true
    },
    {
      '1': 'camera_up_gyro_axis',
      '3': 21,
      '4': 1,
      '5': 9,
      '9': 16,
      '10': 'cameraUpGyroAxis',
      '17': true
    },
    {
      '1': 'camera_up_misalignment',
      '3': 22,
      '4': 1,
      '5': 1,
      '9': 17,
      '10': 'cameraUpMisalignment',
      '17': true
    },
  ],
  '8': [
    {'1': '_calibration_time'},
    {'1': '_calibration_failure_reason'},
    {'1': '_target_exposure_time'},
    {'1': '_camera_offset'},
    {'1': '_fov_horizontal'},
    {'1': '_fov_vertical'},
    {'1': '_lens_distortion'},
    {'1': '_match_max_error'},
    {'1': '_lens_fl_mm'},
    {'1': '_pixel_angular_size'},
    {'1': '_gyro_zero_bias_x'},
    {'1': '_gyro_zero_bias_y'},
    {'1': '_gyro_zero_bias_z'},
    {'1': '_gyro_transform_error_fraction'},
    {'1': '_camera_view_gyro_axis'},
    {'1': '_camera_view_misalignment'},
    {'1': '_camera_up_gyro_axis'},
    {'1': '_camera_up_misalignment'},
  ],
  '9': [
    {'1': 9, '2': 10},
    {'1': 10, '2': 11},
    {'1': 13, '2': 14},
    {'1': 14, '2': 15},
  ],
};

/// Descriptor for `CalibrationData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calibrationDataDescriptor = $convert.base64Decode(
    'Cg9DYWxpYnJhdGlvbkRhdGESSgoQY2FsaWJyYXRpb25fdGltZRgBIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBIAFIPY2FsaWJyYXRpb25UaW1liAEBEmIKGmNhbGlicmF0aW9uX2Zh'
    'aWx1cmVfcmVhc29uGAwgASgOMh8uY2VkYXIuQ2FsaWJyYXRpb25GYWlsdXJlUmVhc29uSAFSGG'
    'NhbGlicmF0aW9uRmFpbHVyZVJlYXNvbogBARJQChR0YXJnZXRfZXhwb3N1cmVfdGltZRgCIAEo'
    'CzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJhdGlvbkgCUhJ0YXJnZXRFeHBvc3VyZVRpbWWIAQESKA'
    'oNY2FtZXJhX29mZnNldBgDIAEoBUgDUgxjYW1lcmFPZmZzZXSIAQESKgoOZm92X2hvcml6b250'
    'YWwYBCABKAFIBFINZm92SG9yaXpvbnRhbIgBARImCgxmb3ZfdmVydGljYWwYCyABKAFIBVILZm'
    '92VmVydGljYWyIAQESLAoPbGVuc19kaXN0b3J0aW9uGAUgASgBSAZSDmxlbnNEaXN0b3J0aW9u'
    'iAEBEisKD21hdGNoX21heF9lcnJvchgIIAEoAUgHUg1tYXRjaE1heEVycm9yiAEBEiEKCmxlbn'
    'NfZmxfbW0YBiABKAFICFIIbGVuc0ZsTW2IAQESMQoScGl4ZWxfYW5ndWxhcl9zaXplGAcgASgB'
    'SAlSEHBpeGVsQW5ndWxhclNpemWIAQESLAoQZ3lyb196ZXJvX2JpYXNfeBgPIAEoAUgKUg1neX'
    'JvWmVyb0JpYXNYiAEBEiwKEGd5cm9femVyb19iaWFzX3kYECABKAFIC1INZ3lyb1plcm9CaWFz'
    'WYgBARIsChBneXJvX3plcm9fYmlhc196GBEgASgBSAxSDWd5cm9aZXJvQmlhc1qIAQESRgodZ3'
    'lyb190cmFuc2Zvcm1fZXJyb3JfZnJhY3Rpb24YEiABKAFIDVIaZ3lyb1RyYW5zZm9ybUVycm9y'
    'RnJhY3Rpb26IAQESNgoVY2FtZXJhX3ZpZXdfZ3lyb19heGlzGBMgASgJSA5SEmNhbWVyYVZpZX'
    'dHeXJvQXhpc4gBARI9ChhjYW1lcmFfdmlld19taXNhbGlnbm1lbnQYFCABKAFID1IWY2FtZXJh'
    'Vmlld01pc2FsaWdubWVudIgBARIyChNjYW1lcmFfdXBfZ3lyb19heGlzGBUgASgJSBBSEGNhbW'
    'VyYVVwR3lyb0F4aXOIAQESOQoWY2FtZXJhX3VwX21pc2FsaWdubWVudBgWIAEoAUgRUhRjYW1l'
    'cmFVcE1pc2FsaWdubWVudIgBAUITChFfY2FsaWJyYXRpb25fdGltZUIdChtfY2FsaWJyYXRpb2'
    '5fZmFpbHVyZV9yZWFzb25CFwoVX3RhcmdldF9leHBvc3VyZV90aW1lQhAKDl9jYW1lcmFfb2Zm'
    'c2V0QhEKD19mb3ZfaG9yaXpvbnRhbEIPCg1fZm92X3ZlcnRpY2FsQhIKEF9sZW5zX2Rpc3Rvcn'
    'Rpb25CEgoQX21hdGNoX21heF9lcnJvckINCgtfbGVuc19mbF9tbUIVChNfcGl4ZWxfYW5ndWxh'
    'cl9zaXplQhMKEV9neXJvX3plcm9fYmlhc194QhMKEV9neXJvX3plcm9fYmlhc195QhMKEV9neX'
    'JvX3plcm9fYmlhc196QiAKHl9neXJvX3RyYW5zZm9ybV9lcnJvcl9mcmFjdGlvbkIYChZfY2Ft'
    'ZXJhX3ZpZXdfZ3lyb19heGlzQhsKGV9jYW1lcmFfdmlld19taXNhbGlnbm1lbnRCFgoUX2NhbW'
    'VyYV91cF9neXJvX2F4aXNCGQoXX2NhbWVyYV91cF9taXNhbGlnbm1lbnRKBAgJEApKBAgKEAtK'
    'BAgNEA5KBAgOEA8=');

@$core.Deprecated('Use locationBasedInfoDescriptor instead')
const LocationBasedInfo$json = {
  '1': 'LocationBasedInfo',
  '2': [
    {'1': 'zenith_roll_angle', '3': 1, '4': 1, '5': 1, '10': 'zenithRollAngle'},
    {'1': 'altitude', '3': 2, '4': 1, '5': 1, '10': 'altitude'},
    {'1': 'azimuth', '3': 3, '4': 1, '5': 1, '10': 'azimuth'},
    {'1': 'hour_angle', '3': 4, '4': 1, '5': 1, '10': 'hourAngle'},
  ],
};

/// Descriptor for `LocationBasedInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationBasedInfoDescriptor = $convert.base64Decode(
    'ChFMb2NhdGlvbkJhc2VkSW5mbxIqChF6ZW5pdGhfcm9sbF9hbmdsZRgBIAEoAVIPemVuaXRoUm'
    '9sbEFuZ2xlEhoKCGFsdGl0dWRlGAIgASgBUghhbHRpdHVkZRIYCgdhemltdXRoGAMgASgBUgdh'
    'emltdXRoEh0KCmhvdXJfYW5nbGUYBCABKAFSCWhvdXJBbmdsZQ==');

@$core.Deprecated('Use slewRequestDescriptor instead')
const SlewRequest$json = {
  '1': 'SlewRequest',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '10': 'target'
    },
    {
      '1': 'target_catalog_entry',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.CatalogEntry',
      '9': 0,
      '10': 'targetCatalogEntry',
      '17': true
    },
    {
      '1': 'target_catalog_entry_distance',
      '3': 9,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'targetCatalogEntryDistance',
      '17': true
    },
    {
      '1': 'target_distance',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'targetDistance',
      '17': true
    },
    {
      '1': 'target_angle',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 3,
      '10': 'targetAngle',
      '17': true
    },
    {
      '1': 'offset_rotation_axis',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 4,
      '10': 'offsetRotationAxis',
      '17': true
    },
    {
      '1': 'offset_tilt_axis',
      '3': 6,
      '4': 1,
      '5': 1,
      '9': 5,
      '10': 'offsetTiltAxis',
      '17': true
    },
    {
      '1': 'image_pos',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '9': 6,
      '10': 'imagePos',
      '17': true
    },
  ],
  '8': [
    {'1': '_target_catalog_entry'},
    {'1': '_target_catalog_entry_distance'},
    {'1': '_target_distance'},
    {'1': '_target_angle'},
    {'1': '_offset_rotation_axis'},
    {'1': '_offset_tilt_axis'},
    {'1': '_image_pos'},
  ],
  '9': [
    {'1': 7, '2': 8},
  ],
};

/// Descriptor for `SlewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slewRequestDescriptor = $convert.base64Decode(
    'CgtTbGV3UmVxdWVzdBI0CgZ0YXJnZXQYASABKAsyHC5jZWRhcl9jb21tb24uQ2VsZXN0aWFsQ2'
    '9vcmRSBnRhcmdldBJOChR0YXJnZXRfY2F0YWxvZ19lbnRyeRgIIAEoCzIXLmNlZGFyX3NreS5D'
    'YXRhbG9nRW50cnlIAFISdGFyZ2V0Q2F0YWxvZ0VudHJ5iAEBEkYKHXRhcmdldF9jYXRhbG9nX2'
    'VudHJ5X2Rpc3RhbmNlGAkgASgBSAFSGnRhcmdldENhdGFsb2dFbnRyeURpc3RhbmNliAEBEiwK'
    'D3RhcmdldF9kaXN0YW5jZRgCIAEoAUgCUg50YXJnZXREaXN0YW5jZYgBARImCgx0YXJnZXRfYW'
    '5nbGUYAyABKAFIA1ILdGFyZ2V0QW5nbGWIAQESNQoUb2Zmc2V0X3JvdGF0aW9uX2F4aXMYBSAB'
    'KAFIBFISb2Zmc2V0Um90YXRpb25BeGlziAEBEi0KEG9mZnNldF90aWx0X2F4aXMYBiABKAFIBV'
    'IOb2Zmc2V0VGlsdEF4aXOIAQESMwoJaW1hZ2VfcG9zGAQgASgLMhEuY2VkYXIuSW1hZ2VDb29y'
    'ZEgGUghpbWFnZVBvc4gBAUIXChVfdGFyZ2V0X2NhdGFsb2dfZW50cnlCIAoeX3RhcmdldF9jYX'
    'RhbG9nX2VudHJ5X2Rpc3RhbmNlQhIKEF90YXJnZXRfZGlzdGFuY2VCDwoNX3RhcmdldF9hbmds'
    'ZUIXChVfb2Zmc2V0X3JvdGF0aW9uX2F4aXNCEwoRX29mZnNldF90aWx0X2F4aXNCDAoKX2ltYW'
    'dlX3Bvc0oECAcQCA==');

@$core.Deprecated('Use polarAlignAdviceDescriptor instead')
const PolarAlignAdvice$json = {
  '1': 'PolarAlignAdvice',
  '2': [
    {
      '1': 'azimuth_correction',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar.ErrorBoundedValue',
      '9': 0,
      '10': 'azimuthCorrection',
      '17': true
    },
    {
      '1': 'altitude_correction',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.ErrorBoundedValue',
      '9': 1,
      '10': 'altitudeCorrection',
      '17': true
    },
  ],
  '8': [
    {'1': '_azimuth_correction'},
    {'1': '_altitude_correction'},
  ],
};

/// Descriptor for `PolarAlignAdvice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polarAlignAdviceDescriptor = $convert.base64Decode(
    'ChBQb2xhckFsaWduQWR2aWNlEkwKEmF6aW11dGhfY29ycmVjdGlvbhgBIAEoCzIYLmNlZGFyLk'
    'Vycm9yQm91bmRlZFZhbHVlSABSEWF6aW11dGhDb3JyZWN0aW9uiAEBEk4KE2FsdGl0dWRlX2Nv'
    'cnJlY3Rpb24YAiABKAsyGC5jZWRhci5FcnJvckJvdW5kZWRWYWx1ZUgBUhJhbHRpdHVkZUNvcn'
    'JlY3Rpb26IAQFCFQoTX2F6aW11dGhfY29ycmVjdGlvbkIWChRfYWx0aXR1ZGVfY29ycmVjdGlv'
    'bg==');

@$core.Deprecated('Use errorBoundedValueDescriptor instead')
const ErrorBoundedValue$json = {
  '1': 'ErrorBoundedValue',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '10': 'value'},
    {'1': 'error', '3': 2, '4': 1, '5': 1, '10': 'error'},
  ],
};

/// Descriptor for `ErrorBoundedValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorBoundedValueDescriptor = $convert.base64Decode(
    'ChFFcnJvckJvdW5kZWRWYWx1ZRIUCgV2YWx1ZRgBIAEoAVIFdmFsdWUSFAoFZXJyb3IYAiABKA'
    'FSBWVycm9y');

@$core.Deprecated('Use fovCatalogEntryDescriptor instead')
const FovCatalogEntry$json = {
  '1': 'FovCatalogEntry',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.CatalogEntry',
      '10': 'entry'
    },
    {
      '1': 'image_pos',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '10': 'imagePos'
    },
  ],
};

/// Descriptor for `FovCatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fovCatalogEntryDescriptor = $convert.base64Decode(
    'Cg9Gb3ZDYXRhbG9nRW50cnkSLQoFZW50cnkYASABKAsyFy5jZWRhcl9za3kuQ2F0YWxvZ0VudH'
    'J5UgVlbnRyeRIuCglpbWFnZV9wb3MYAiABKAsyES5jZWRhci5JbWFnZUNvb3JkUghpbWFnZVBv'
    'cw==');

@$core.Deprecated('Use actionRequestDescriptor instead')
const ActionRequest$json = {
  '1': 'ActionRequest',
  '2': [
    {
      '1': 'cancel_calibration',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'cancelCalibration',
      '17': true
    },
    {
      '1': 'capture_boresight',
      '3': 1,
      '4': 1,
      '5': 8,
      '9': 1,
      '10': 'captureBoresight',
      '17': true
    },
    {
      '1': 'designate_boresight',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '9': 2,
      '10': 'designateBoresight',
      '17': true
    },
    {
      '1': 'shutdown_server',
      '3': 3,
      '4': 1,
      '5': 8,
      '9': 3,
      '10': 'shutdownServer',
      '17': true
    },
    {
      '1': 'restart_server',
      '3': 8,
      '4': 1,
      '5': 8,
      '9': 4,
      '10': 'restartServer',
      '17': true
    },
    {
      '1': 'initiate_slew',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '9': 5,
      '10': 'initiateSlew',
      '17': true
    },
    {
      '1': 'stop_slew',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 6,
      '10': 'stopSlew',
      '17': true
    },
    {
      '1': 'save_image',
      '3': 5,
      '4': 1,
      '5': 8,
      '9': 7,
      '10': 'saveImage',
      '17': true
    },
    {
      '1': 'update_wifi_access_point',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.cedar.WiFiAccessPoint',
      '9': 8,
      '10': 'updateWifiAccessPoint',
      '17': true
    },
    {
      '1': 'clear_dont_show_items',
      '3': 10,
      '4': 1,
      '5': 8,
      '9': 9,
      '10': 'clearDontShowItems',
      '17': true
    },
    {
      '1': 'designate_daylight_focus_region',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.cedar.ImageCoord',
      '9': 10,
      '10': 'designateDaylightFocusRegion',
      '17': true
    },
    {
      '1': 'crash_server',
      '3': 12,
      '4': 1,
      '5': 8,
      '9': 11,
      '10': 'crashServer',
      '17': true
    },
  ],
  '8': [
    {'1': '_cancel_calibration'},
    {'1': '_capture_boresight'},
    {'1': '_designate_boresight'},
    {'1': '_shutdown_server'},
    {'1': '_restart_server'},
    {'1': '_initiate_slew'},
    {'1': '_stop_slew'},
    {'1': '_save_image'},
    {'1': '_update_wifi_access_point'},
    {'1': '_clear_dont_show_items'},
    {'1': '_designate_daylight_focus_region'},
    {'1': '_crash_server'},
  ],
};

/// Descriptor for `ActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionRequestDescriptor = $convert.base64Decode(
    'Cg1BY3Rpb25SZXF1ZXN0EjIKEmNhbmNlbF9jYWxpYnJhdGlvbhgJIAEoCEgAUhFjYW5jZWxDYW'
    'xpYnJhdGlvbogBARIwChFjYXB0dXJlX2JvcmVzaWdodBgBIAEoCEgBUhBjYXB0dXJlQm9yZXNp'
    'Z2h0iAEBEkcKE2Rlc2lnbmF0ZV9ib3Jlc2lnaHQYAiABKAsyES5jZWRhci5JbWFnZUNvb3JkSA'
    'JSEmRlc2lnbmF0ZUJvcmVzaWdodIgBARIsCg9zaHV0ZG93bl9zZXJ2ZXIYAyABKAhIA1IOc2h1'
    'dGRvd25TZXJ2ZXKIAQESKgoOcmVzdGFydF9zZXJ2ZXIYCCABKAhIBFINcmVzdGFydFNlcnZlco'
    'gBARJGCg1pbml0aWF0ZV9zbGV3GAYgASgLMhwuY2VkYXJfY29tbW9uLkNlbGVzdGlhbENvb3Jk'
    'SAVSDGluaXRpYXRlU2xld4gBARIgCglzdG9wX3NsZXcYBCABKAhIBlIIc3RvcFNsZXeIAQESIg'
    'oKc2F2ZV9pbWFnZRgFIAEoCEgHUglzYXZlSW1hZ2WIAQESVAoYdXBkYXRlX3dpZmlfYWNjZXNz'
    'X3BvaW50GAcgASgLMhYuY2VkYXIuV2lGaUFjY2Vzc1BvaW50SAhSFXVwZGF0ZVdpZmlBY2Nlc3'
    'NQb2ludIgBARI2ChVjbGVhcl9kb250X3Nob3dfaXRlbXMYCiABKAhICVISY2xlYXJEb250U2hv'
    'd0l0ZW1ziAEBEl0KH2Rlc2lnbmF0ZV9kYXlsaWdodF9mb2N1c19yZWdpb24YCyABKAsyES5jZW'
    'Rhci5JbWFnZUNvb3JkSApSHGRlc2lnbmF0ZURheWxpZ2h0Rm9jdXNSZWdpb26IAQESJgoMY3Jh'
    'c2hfc2VydmVyGAwgASgISAtSC2NyYXNoU2VydmVyiAEBQhUKE19jYW5jZWxfY2FsaWJyYXRpb2'
    '5CFAoSX2NhcHR1cmVfYm9yZXNpZ2h0QhYKFF9kZXNpZ25hdGVfYm9yZXNpZ2h0QhIKEF9zaHV0'
    'ZG93bl9zZXJ2ZXJCEQoPX3Jlc3RhcnRfc2VydmVyQhAKDl9pbml0aWF0ZV9zbGV3QgwKCl9zdG'
    '9wX3NsZXdCDQoLX3NhdmVfaW1hZ2VCGwoZX3VwZGF0ZV93aWZpX2FjY2Vzc19wb2ludEIYChZf'
    'Y2xlYXJfZG9udF9zaG93X2l0ZW1zQiIKIF9kZXNpZ25hdGVfZGF5bGlnaHRfZm9jdXNfcmVnaW'
    '9uQg8KDV9jcmFzaF9zZXJ2ZXI=');

@$core.Deprecated('Use serverLogRequestDescriptor instead')
const ServerLogRequest$json = {
  '1': 'ServerLogRequest',
  '2': [
    {'1': 'log_request', '3': 1, '4': 1, '5': 5, '10': 'logRequest'},
  ],
};

/// Descriptor for `ServerLogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverLogRequestDescriptor = $convert.base64Decode(
    'ChBTZXJ2ZXJMb2dSZXF1ZXN0Eh8KC2xvZ19yZXF1ZXN0GAEgASgFUgpsb2dSZXF1ZXN0');

@$core.Deprecated('Use serverLogResultDescriptor instead')
const ServerLogResult$json = {
  '1': 'ServerLogResult',
  '2': [
    {'1': 'log_content', '3': 1, '4': 1, '5': 9, '10': 'logContent'},
  ],
};

/// Descriptor for `ServerLogResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverLogResultDescriptor = $convert.base64Decode(
    'Cg9TZXJ2ZXJMb2dSZXN1bHQSHwoLbG9nX2NvbnRlbnQYASABKAlSCmxvZ0NvbnRlbnQ=');

@$core.Deprecated('Use emptyMessageDescriptor instead')
const EmptyMessage$json = {
  '1': 'EmptyMessage',
};

/// Descriptor for `EmptyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyMessageDescriptor =
    $convert.base64Decode('CgxFbXB0eU1lc3NhZ2U=');

@$core.Deprecated('Use getBluetoothNameResponseDescriptor instead')
const GetBluetoothNameResponse$json = {
  '1': 'GetBluetoothNameResponse',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `GetBluetoothNameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBluetoothNameResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRCbHVldG9vdGhOYW1lUmVzcG9uc2USEgoEbmFtZRgBIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use startBondingResponseDescriptor instead')
const StartBondingResponse$json = {
  '1': 'StartBondingResponse',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {
      '1': 'passkey',
      '3': 2,
      '4': 1,
      '5': 13,
      '9': 1,
      '10': 'passkey',
      '17': true
    },
  ],
  '8': [
    {'1': '_name'},
    {'1': '_passkey'},
  ],
};

/// Descriptor for `StartBondingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startBondingResponseDescriptor = $convert.base64Decode(
    'ChRTdGFydEJvbmRpbmdSZXNwb25zZRIXCgRuYW1lGAEgASgJSABSBG5hbWWIAQESHQoHcGFzc2'
    'tleRgCIAEoDUgBUgdwYXNza2V5iAEBQgcKBV9uYW1lQgoKCF9wYXNza2V5');

@$core.Deprecated('Use bondedDeviceDescriptor instead')
const BondedDevice$json = {
  '1': 'BondedDevice',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `BondedDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bondedDeviceDescriptor = $convert.base64Decode(
    'CgxCb25kZWREZXZpY2USEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgdhZGRyZXNzGAIgASgJUgdhZG'
    'RyZXNz');

@$core.Deprecated('Use getBondedDevicesResponseDescriptor instead')
const GetBondedDevicesResponse$json = {
  '1': 'GetBondedDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cedar.BondedDevice',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `GetBondedDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBondedDevicesResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRCb25kZWREZXZpY2VzUmVzcG9uc2USLQoHZGV2aWNlcxgBIAMoCzITLmNlZGFyLkJvbm'
        'RlZERldmljZVIHZGV2aWNlcw==');

@$core.Deprecated('Use removeBondRequestDescriptor instead')
const RemoveBondRequest$json = {
  '1': 'RemoveBondRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `RemoveBondRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeBondRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVCb25kUmVxdWVzdBIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNz');
