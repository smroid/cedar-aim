//
//  Generated code. Do not modify.
//  source: cedar.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

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

@$core.Deprecated('Use accuracyDescriptor instead')
const Accuracy$json = {
  '1': 'Accuracy',
  '2': [
    {'1': 'ACCURACY_UNSPECIFIED', '2': 0},
    {'1': 'FASTER', '2': 1},
    {'1': 'BALANCED', '2': 2},
    {'1': 'ACCURATE', '2': 3},
  ],
};

/// Descriptor for `Accuracy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accuracyDescriptor = $convert.base64Decode(
    'CghBY2N1cmFjeRIYChRBQ0NVUkFDWV9VTlNQRUNJRklFRBAAEgoKBkZBU1RFUhABEgwKCEJBTE'
    'FOQ0VEEAISDAoIQUNDVVJBVEUQAw==');

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

@$core.Deprecated('Use serverInformationDescriptor instead')
const ServerInformation$json = {
  '1': 'ServerInformation',
  '2': [
    {'1': 'product_name', '3': 1, '4': 1, '5': 9, '10': 'productName'},
    {'1': 'copyright', '3': 2, '4': 1, '5': 9, '10': 'copyright'},
    {'1': 'cedar_server_version', '3': 3, '4': 1, '5': 9, '10': 'cedarServerVersion'},
    {'1': 'feature_level', '3': 4, '4': 1, '5': 14, '6': '.cedar.FeatureLevel', '10': 'featureLevel'},
    {'1': 'processor_model', '3': 5, '4': 1, '5': 9, '10': 'processorModel'},
    {'1': 'os_version', '3': 6, '4': 1, '5': 9, '10': 'osVersion'},
    {'1': 'serial_number', '3': 12, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'cpu_temperature', '3': 7, '4': 1, '5': 2, '10': 'cpuTemperature'},
    {'1': 'server_time', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'serverTime'},
    {'1': 'camera', '3': 9, '4': 1, '5': 11, '6': '.cedar.CameraModel', '9': 0, '10': 'camera', '17': true},
    {'1': 'wifi_access_point', '3': 10, '4': 1, '5': 11, '6': '.cedar.WiFiAccessPoint', '9': 1, '10': 'wifiAccessPoint', '17': true},
  ],
  '8': [
    {'1': '_camera'},
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
    'YW1lcmGIAQESRwoRd2lmaV9hY2Nlc3NfcG9pbnQYCiABKAsyFi5jZWRhci5XaUZpQWNjZXNzUG'
    '9pbnRIAVIPd2lmaUFjY2Vzc1BvaW50iAEBQgkKB19jYW1lcmFCFAoSX3dpZmlfYWNjZXNzX3Bv'
    'aW50');

@$core.Deprecated('Use cameraModelDescriptor instead')
const CameraModel$json = {
  '1': 'CameraModel',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
    {'1': 'image_width', '3': 2, '4': 1, '5': 5, '10': 'imageWidth'},
    {'1': 'image_height', '3': 3, '4': 1, '5': 5, '10': 'imageHeight'},
  ],
};

/// Descriptor for `CameraModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cameraModelDescriptor = $convert.base64Decode(
    'CgtDYW1lcmFNb2RlbBIUCgVtb2RlbBgBIAEoCVIFbW9kZWwSHwoLaW1hZ2Vfd2lkdGgYAiABKA'
    'VSCmltYWdlV2lkdGgSIQoMaW1hZ2VfaGVpZ2h0GAMgASgFUgtpbWFnZUhlaWdodA==');

@$core.Deprecated('Use wiFiAccessPointDescriptor instead')
const WiFiAccessPoint$json = {
  '1': 'WiFiAccessPoint',
  '2': [
    {'1': 'ssid', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ssid', '17': true},
    {'1': 'psk', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'psk', '17': true},
    {'1': 'channel', '3': 3, '4': 1, '5': 5, '9': 2, '10': 'channel', '17': true},
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
    {'1': 'observer_location', '3': 2, '4': 1, '5': 11, '6': '.cedar.LatLong', '9': 0, '10': 'observerLocation', '17': true},
    {'1': 'current_time', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 1, '10': 'currentTime', '17': true},
    {'1': 'session_name', '3': 5, '4': 1, '5': 9, '9': 2, '10': 'sessionName', '17': true},
    {'1': 'max_exposure_time', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 3, '10': 'maxExposureTime', '17': true},
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
    {'1': 'operating_mode', '3': 4, '4': 1, '5': 14, '6': '.cedar.OperatingMode', '9': 0, '10': 'operatingMode', '17': true},
    {'1': 'daylight_mode', '3': 1, '4': 1, '5': 8, '9': 1, '10': 'daylightMode', '17': true},
    {'1': 'focus_assist_mode', '3': 14, '4': 1, '5': 8, '9': 2, '10': 'focusAssistMode', '17': true},
    {'1': 'exposure_time', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 3, '10': 'exposureTime', '17': true},
    {'1': 'accuracy', '3': 3, '4': 1, '5': 14, '6': '.cedar.Accuracy', '9': 4, '10': 'accuracy', '17': true},
    {'1': 'update_interval', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 5, '10': 'updateInterval', '17': true},
    {'1': 'dwell_update_interval', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 6, '10': 'dwellUpdateInterval', '17': true},
    {'1': 'log_dwelled_positions', '3': 10, '4': 1, '5': 8, '9': 7, '10': 'logDwelledPositions', '17': true},
    {'1': 'catalog_entry_match', '3': 11, '4': 1, '5': 11, '6': '.cedar_sky.CatalogEntryMatch', '9': 8, '10': 'catalogEntryMatch', '17': true},
    {'1': 'demo_image_filename', '3': 12, '4': 1, '5': 9, '9': 9, '10': 'demoImageFilename', '17': true},
    {'1': 'invert_camera', '3': 13, '4': 1, '5': 8, '9': 10, '10': 'invertCamera', '17': true},
  ],
  '8': [
    {'1': '_operating_mode'},
    {'1': '_daylight_mode'},
    {'1': '_focus_assist_mode'},
    {'1': '_exposure_time'},
    {'1': '_accuracy'},
    {'1': '_update_interval'},
    {'1': '_dwell_update_interval'},
    {'1': '_log_dwelled_positions'},
    {'1': '_catalog_entry_match'},
    {'1': '_demo_image_filename'},
    {'1': '_invert_camera'},
  ],
};

/// Descriptor for `OperationSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationSettingsDescriptor = $convert.base64Decode(
    'ChFPcGVyYXRpb25TZXR0aW5ncxJACg5vcGVyYXRpbmdfbW9kZRgEIAEoDjIULmNlZGFyLk9wZX'
    'JhdGluZ01vZGVIAFINb3BlcmF0aW5nTW9kZYgBARIoCg1kYXlsaWdodF9tb2RlGAEgASgISAFS'
    'DGRheWxpZ2h0TW9kZYgBARIvChFmb2N1c19hc3Npc3RfbW9kZRgOIAEoCEgCUg9mb2N1c0Fzc2'
    'lzdE1vZGWIAQESQwoNZXhwb3N1cmVfdGltZRgFIAEoCzIZLmdvb2dsZS5wcm90b2J1Zi5EdXJh'
    'dGlvbkgDUgxleHBvc3VyZVRpbWWIAQESMAoIYWNjdXJhY3kYAyABKA4yDy5jZWRhci5BY2N1cm'
    'FjeUgEUghhY2N1cmFjeYgBARJHCg91cGRhdGVfaW50ZXJ2YWwYByABKAsyGS5nb29nbGUucHJv'
    'dG9idWYuRHVyYXRpb25IBVIOdXBkYXRlSW50ZXJ2YWyIAQESUgoVZHdlbGxfdXBkYXRlX2ludG'
    'VydmFsGAggASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uSAZSE2R3ZWxsVXBkYXRlSW50'
    'ZXJ2YWyIAQESNwoVbG9nX2R3ZWxsZWRfcG9zaXRpb25zGAogASgISAdSE2xvZ0R3ZWxsZWRQb3'
    'NpdGlvbnOIAQESUQoTY2F0YWxvZ19lbnRyeV9tYXRjaBgLIAEoCzIcLmNlZGFyX3NreS5DYXRh'
    'bG9nRW50cnlNYXRjaEgIUhFjYXRhbG9nRW50cnlNYXRjaIgBARIzChNkZW1vX2ltYWdlX2ZpbG'
    'VuYW1lGAwgASgJSAlSEWRlbW9JbWFnZUZpbGVuYW1liAEBEigKDWludmVydF9jYW1lcmEYDSAB'
    'KAhIClIMaW52ZXJ0Q2FtZXJhiAEBQhEKD19vcGVyYXRpbmdfbW9kZUIQCg5fZGF5bGlnaHRfbW'
    '9kZUIUChJfZm9jdXNfYXNzaXN0X21vZGVCEAoOX2V4cG9zdXJlX3RpbWVCCwoJX2FjY3VyYWN5'
    'QhIKEF91cGRhdGVfaW50ZXJ2YWxCGAoWX2R3ZWxsX3VwZGF0ZV9pbnRlcnZhbEIYChZfbG9nX2'
    'R3ZWxsZWRfcG9zaXRpb25zQhYKFF9jYXRhbG9nX2VudHJ5X21hdGNoQhYKFF9kZW1vX2ltYWdl'
    'X2ZpbGVuYW1lQhAKDl9pbnZlcnRfY2FtZXJh');

@$core.Deprecated('Use preferencesDescriptor instead')
const Preferences$json = {
  '1': 'Preferences',
  '2': [
    {'1': 'celestial_coord_format', '3': 1, '4': 1, '5': 14, '6': '.cedar.CelestialCoordFormat', '9': 0, '10': 'celestialCoordFormat', '17': true},
    {'1': 'eyepiece_fov', '3': 2, '4': 1, '5': 1, '9': 1, '10': 'eyepieceFov', '17': true},
    {'1': 'night_vision_theme', '3': 3, '4': 1, '5': 8, '9': 2, '10': 'nightVisionTheme', '17': true},
    {'1': 'hide_app_bar', '3': 5, '4': 1, '5': 8, '9': 3, '10': 'hideAppBar', '17': true},
    {'1': 'mount_type', '3': 6, '4': 1, '5': 14, '6': '.cedar.MountType', '9': 4, '10': 'mountType', '17': true},
    {'1': 'observer_location', '3': 7, '4': 1, '5': 11, '6': '.cedar.LatLong', '9': 5, '10': 'observerLocation', '17': true},
    {'1': 'accuracy', '3': 8, '4': 1, '5': 14, '6': '.cedar.Accuracy', '9': 6, '10': 'accuracy', '17': true},
    {'1': 'update_interval', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 7, '10': 'updateInterval', '17': true},
    {'1': 'catalog_entry_match', '3': 11, '4': 1, '5': 11, '6': '.cedar_sky.CatalogEntryMatch', '9': 8, '10': 'catalogEntryMatch', '17': true},
    {'1': 'max_distance_active', '3': 15, '4': 1, '5': 8, '9': 9, '10': 'maxDistanceActive', '17': true},
    {'1': 'max_distance', '3': 12, '4': 1, '5': 1, '9': 10, '10': 'maxDistance', '17': true},
    {'1': 'min_elevation_active', '3': 16, '4': 1, '5': 8, '9': 11, '10': 'minElevationActive', '17': true},
    {'1': 'min_elevation', '3': 13, '4': 1, '5': 1, '9': 12, '10': 'minElevation', '17': true},
    {'1': 'ordering', '3': 14, '4': 1, '5': 14, '6': '.cedar_sky.Ordering', '9': 13, '10': 'ordering', '17': true},
    {'1': 'advanced', '3': 17, '4': 1, '5': 8, '9': 14, '10': 'advanced', '17': true},
    {'1': 'text_size_index', '3': 18, '4': 1, '5': 5, '9': 15, '10': 'textSizeIndex', '17': true},
    {'1': 'boresight_pixel', '3': 19, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '9': 16, '10': 'boresightPixel', '17': true},
    {'1': 'invert_camera', '3': 20, '4': 1, '5': 8, '9': 17, '10': 'invertCamera', '17': true},
  ],
  '8': [
    {'1': '_celestial_coord_format'},
    {'1': '_eyepiece_fov'},
    {'1': '_night_vision_theme'},
    {'1': '_hide_app_bar'},
    {'1': '_mount_type'},
    {'1': '_observer_location'},
    {'1': '_accuracy'},
    {'1': '_update_interval'},
    {'1': '_catalog_entry_match'},
    {'1': '_max_distance_active'},
    {'1': '_max_distance'},
    {'1': '_min_elevation_active'},
    {'1': '_min_elevation'},
    {'1': '_ordering'},
    {'1': '_advanced'},
    {'1': '_text_size_index'},
    {'1': '_boresight_pixel'},
    {'1': '_invert_camera'},
  ],
  '9': [
    {'1': 4, '2': 5},
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
    'YnNlcnZlckxvY2F0aW9uiAEBEjAKCGFjY3VyYWN5GAggASgOMg8uY2VkYXIuQWNjdXJhY3lIBl'
    'IIYWNjdXJhY3mIAQESRwoPdXBkYXRlX2ludGVydmFsGAkgASgLMhkuZ29vZ2xlLnByb3RvYnVm'
    'LkR1cmF0aW9uSAdSDnVwZGF0ZUludGVydmFsiAEBElEKE2NhdGFsb2dfZW50cnlfbWF0Y2gYCy'
    'ABKAsyHC5jZWRhcl9za3kuQ2F0YWxvZ0VudHJ5TWF0Y2hICFIRY2F0YWxvZ0VudHJ5TWF0Y2iI'
    'AQESMwoTbWF4X2Rpc3RhbmNlX2FjdGl2ZRgPIAEoCEgJUhFtYXhEaXN0YW5jZUFjdGl2ZYgBAR'
    'ImCgxtYXhfZGlzdGFuY2UYDCABKAFIClILbWF4RGlzdGFuY2WIAQESNQoUbWluX2VsZXZhdGlv'
    'bl9hY3RpdmUYECABKAhIC1ISbWluRWxldmF0aW9uQWN0aXZliAEBEigKDW1pbl9lbGV2YXRpb2'
    '4YDSABKAFIDFIMbWluRWxldmF0aW9uiAEBEjQKCG9yZGVyaW5nGA4gASgOMhMuY2VkYXJfc2t5'
    'Lk9yZGVyaW5nSA1SCG9yZGVyaW5niAEBEh8KCGFkdmFuY2VkGBEgASgISA5SCGFkdmFuY2VkiA'
    'EBEisKD3RleHRfc2l6ZV9pbmRleBgSIAEoBUgPUg10ZXh0U2l6ZUluZGV4iAEBEj8KD2JvcmVz'
    'aWdodF9waXhlbBgTIAEoCzIRLmNlZGFyLkltYWdlQ29vcmRIEFIOYm9yZXNpZ2h0UGl4ZWyIAQ'
    'ESKAoNaW52ZXJ0X2NhbWVyYRgUIAEoCEgRUgxpbnZlcnRDYW1lcmGIAQFCGQoXX2NlbGVzdGlh'
    'bF9jb29yZF9mb3JtYXRCDwoNX2V5ZXBpZWNlX2ZvdkIVChNfbmlnaHRfdmlzaW9uX3RoZW1lQg'
    '8KDV9oaWRlX2FwcF9iYXJCDQoLX21vdW50X3R5cGVCFAoSX29ic2VydmVyX2xvY2F0aW9uQgsK'
    'CV9hY2N1cmFjeUISChBfdXBkYXRlX2ludGVydmFsQhYKFF9jYXRhbG9nX2VudHJ5X21hdGNoQh'
    'YKFF9tYXhfZGlzdGFuY2VfYWN0aXZlQg8KDV9tYXhfZGlzdGFuY2VCFwoVX21pbl9lbGV2YXRp'
    'b25fYWN0aXZlQhAKDl9taW5fZWxldmF0aW9uQgsKCV9vcmRlcmluZ0ILCglfYWR2YW5jZWRCEg'
    'oQX3RleHRfc2l6ZV9pbmRleEISChBfYm9yZXNpZ2h0X3BpeGVsQhAKDl9pbnZlcnRfY2FtZXJh'
    'SgQIBBAF');

@$core.Deprecated('Use frameRequestDescriptor instead')
const FrameRequest$json = {
  '1': 'FrameRequest',
  '2': [
    {'1': 'prev_frame_id', '3': 1, '4': 1, '5': 5, '9': 0, '10': 'prevFrameId', '17': true},
  ],
  '8': [
    {'1': '_prev_frame_id'},
  ],
};

/// Descriptor for `FrameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameRequestDescriptor = $convert.base64Decode(
    'CgxGcmFtZVJlcXVlc3QSJwoNcHJldl9mcmFtZV9pZBgBIAEoBUgAUgtwcmV2RnJhbWVJZIgBAU'
    'IQCg5fcHJldl9mcmFtZV9pZA==');

@$core.Deprecated('Use frameResultDescriptor instead')
const FrameResult$json = {
  '1': 'FrameResult',
  '2': [
    {'1': 'frame_id', '3': 1, '4': 1, '5': 5, '10': 'frameId'},
    {'1': 'server_information', '3': 32, '4': 1, '5': 11, '6': '.cedar.ServerInformation', '10': 'serverInformation'},
    {'1': 'fixed_settings', '3': 27, '4': 1, '5': 11, '6': '.cedar.FixedSettings', '10': 'fixedSettings'},
    {'1': 'preferences', '3': 25, '4': 1, '5': 11, '6': '.cedar.Preferences', '10': 'preferences'},
    {'1': 'operation_settings', '3': 2, '4': 1, '5': 11, '6': '.cedar.OperationSettings', '10': 'operationSettings'},
    {'1': 'calibration_data', '3': 5, '4': 1, '5': 11, '6': '.cedar.CalibrationData', '10': 'calibrationData'},
    {'1': 'image', '3': 3, '4': 1, '5': 11, '6': '.cedar.Image', '10': 'image'},
    {'1': 'exposure_time', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '10': 'exposureTime'},
    {'1': 'capture_time', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'captureTime'},
    {'1': 'camera_temperature_celsius', '3': 10, '4': 1, '5': 1, '10': 'cameraTemperatureCelsius'},
    {'1': 'star_candidates', '3': 4, '4': 3, '5': 11, '6': '.cedar.StarCentroid', '10': 'starCandidates'},
    {'1': 'plate_solution', '3': 17, '4': 1, '5': 11, '6': '.tetra3_server.SolveResult', '9': 0, '10': 'plateSolution', '17': true},
    {'1': 'noise_estimate', '3': 26, '4': 1, '5': 1, '10': 'noiseEstimate'},
    {'1': 'processing_stats', '3': 8, '4': 1, '5': 11, '6': '.cedar.ProcessingStats', '10': 'processingStats'},
    {'1': 'boresight_position', '3': 21, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '10': 'boresightPosition'},
    {'1': 'calibrating', '3': 22, '4': 1, '5': 8, '10': 'calibrating'},
    {'1': 'calibration_progress', '3': 23, '4': 1, '5': 1, '9': 1, '10': 'calibrationProgress', '17': true},
    {'1': 'center_peak_position', '3': 12, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '9': 2, '10': 'centerPeakPosition', '17': true},
    {'1': 'center_peak_value', '3': 6, '4': 1, '5': 5, '9': 3, '10': 'centerPeakValue', '17': true},
    {'1': 'center_peak_image', '3': 13, '4': 1, '5': 11, '6': '.cedar.Image', '9': 4, '10': 'centerPeakImage', '17': true},
    {'1': 'location_based_info', '3': 29, '4': 1, '5': 11, '6': '.cedar.LocationBasedInfo', '9': 5, '10': 'locationBasedInfo', '17': true},
    {'1': 'slew_request', '3': 24, '4': 1, '5': 11, '6': '.cedar.SlewRequest', '9': 6, '10': 'slewRequest', '17': true},
    {'1': 'boresight_image', '3': 28, '4': 1, '5': 11, '6': '.cedar.Image', '9': 7, '10': 'boresightImage', '17': true},
    {'1': 'polar_align_advice', '3': 30, '4': 1, '5': 11, '6': '.cedar.PolarAlignAdvice', '10': 'polarAlignAdvice'},
    {'1': 'labeled_catalog_entries', '3': 31, '4': 3, '5': 11, '6': '.cedar.FovCatalogEntry', '10': 'labeledCatalogEntries'},
    {'1': 'unlabeled_catalog_entries', '3': 33, '4': 3, '5': 11, '6': '.cedar.FovCatalogEntry', '10': 'unlabeledCatalogEntries'},
  ],
  '8': [
    {'1': '_plate_solution'},
    {'1': '_calibration_progress'},
    {'1': '_center_peak_position'},
    {'1': '_center_peak_value'},
    {'1': '_center_peak_image'},
    {'1': '_location_based_info'},
    {'1': '_slew_request'},
    {'1': '_boresight_image'},
  ],
  '9': [
    {'1': 11, '2': 12},
  ],
};

/// Descriptor for `FrameResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List frameResultDescriptor = $convert.base64Decode(
    'CgtGcmFtZVJlc3VsdBIZCghmcmFtZV9pZBgBIAEoBVIHZnJhbWVJZBJHChJzZXJ2ZXJfaW5mb3'
    'JtYXRpb24YICABKAsyGC5jZWRhci5TZXJ2ZXJJbmZvcm1hdGlvblIRc2VydmVySW5mb3JtYXRp'
    'b24SOwoOZml4ZWRfc2V0dGluZ3MYGyABKAsyFC5jZWRhci5GaXhlZFNldHRpbmdzUg1maXhlZF'
    'NldHRpbmdzEjQKC3ByZWZlcmVuY2VzGBkgASgLMhIuY2VkYXIuUHJlZmVyZW5jZXNSC3ByZWZl'
    'cmVuY2VzEkcKEm9wZXJhdGlvbl9zZXR0aW5ncxgCIAEoCzIYLmNlZGFyLk9wZXJhdGlvblNldH'
    'RpbmdzUhFvcGVyYXRpb25TZXR0aW5ncxJBChBjYWxpYnJhdGlvbl9kYXRhGAUgASgLMhYuY2Vk'
    'YXIuQ2FsaWJyYXRpb25EYXRhUg9jYWxpYnJhdGlvbkRhdGESIgoFaW1hZ2UYAyABKAsyDC5jZW'
    'Rhci5JbWFnZVIFaW1hZ2USPgoNZXhwb3N1cmVfdGltZRgHIAEoCzIZLmdvb2dsZS5wcm90b2J1'
    'Zi5EdXJhdGlvblIMZXhwb3N1cmVUaW1lEj0KDGNhcHR1cmVfdGltZRgJIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSC2NhcHR1cmVUaW1lEjwKGmNhbWVyYV90ZW1wZXJhdHVyZV9j'
    'ZWxzaXVzGAogASgBUhhjYW1lcmFUZW1wZXJhdHVyZUNlbHNpdXMSPAoPc3Rhcl9jYW5kaWRhdG'
    'VzGAQgAygLMhMuY2VkYXIuU3RhckNlbnRyb2lkUg5zdGFyQ2FuZGlkYXRlcxJGCg5wbGF0ZV9z'
    'b2x1dGlvbhgRIAEoCzIaLnRldHJhM19zZXJ2ZXIuU29sdmVSZXN1bHRIAFINcGxhdGVTb2x1dG'
    'lvbogBARIlCg5ub2lzZV9lc3RpbWF0ZRgaIAEoAVINbm9pc2VFc3RpbWF0ZRJBChBwcm9jZXNz'
    'aW5nX3N0YXRzGAggASgLMhYuY2VkYXIuUHJvY2Vzc2luZ1N0YXRzUg9wcm9jZXNzaW5nU3RhdH'
    'MSQAoSYm9yZXNpZ2h0X3Bvc2l0aW9uGBUgASgLMhEuY2VkYXIuSW1hZ2VDb29yZFIRYm9yZXNp'
    'Z2h0UG9zaXRpb24SIAoLY2FsaWJyYXRpbmcYFiABKAhSC2NhbGlicmF0aW5nEjYKFGNhbGlicm'
    'F0aW9uX3Byb2dyZXNzGBcgASgBSAFSE2NhbGlicmF0aW9uUHJvZ3Jlc3OIAQESSAoUY2VudGVy'
    'X3BlYWtfcG9zaXRpb24YDCABKAsyES5jZWRhci5JbWFnZUNvb3JkSAJSEmNlbnRlclBlYWtQb3'
    'NpdGlvbogBARIvChFjZW50ZXJfcGVha192YWx1ZRgGIAEoBUgDUg9jZW50ZXJQZWFrVmFsdWWI'
    'AQESPQoRY2VudGVyX3BlYWtfaW1hZ2UYDSABKAsyDC5jZWRhci5JbWFnZUgEUg9jZW50ZXJQZW'
    'FrSW1hZ2WIAQESTQoTbG9jYXRpb25fYmFzZWRfaW5mbxgdIAEoCzIYLmNlZGFyLkxvY2F0aW9u'
    'QmFzZWRJbmZvSAVSEWxvY2F0aW9uQmFzZWRJbmZviAEBEjoKDHNsZXdfcmVxdWVzdBgYIAEoCz'
    'ISLmNlZGFyLlNsZXdSZXF1ZXN0SAZSC3NsZXdSZXF1ZXN0iAEBEjoKD2JvcmVzaWdodF9pbWFn'
    'ZRgcIAEoCzIMLmNlZGFyLkltYWdlSAdSDmJvcmVzaWdodEltYWdliAEBEkUKEnBvbGFyX2FsaW'
    'duX2FkdmljZRgeIAEoCzIXLmNlZGFyLlBvbGFyQWxpZ25BZHZpY2VSEHBvbGFyQWxpZ25BZHZp'
    'Y2USTgoXbGFiZWxlZF9jYXRhbG9nX2VudHJpZXMYHyADKAsyFi5jZWRhci5Gb3ZDYXRhbG9nRW'
    '50cnlSFWxhYmVsZWRDYXRhbG9nRW50cmllcxJSChl1bmxhYmVsZWRfY2F0YWxvZ19lbnRyaWVz'
    'GCEgAygLMhYuY2VkYXIuRm92Q2F0YWxvZ0VudHJ5Uhd1bmxhYmVsZWRDYXRhbG9nRW50cmllc0'
    'IRCg9fcGxhdGVfc29sdXRpb25CFwoVX2NhbGlicmF0aW9uX3Byb2dyZXNzQhcKFV9jZW50ZXJf'
    'cGVha19wb3NpdGlvbkIUChJfY2VudGVyX3BlYWtfdmFsdWVCFAoSX2NlbnRlcl9wZWFrX2ltYW'
    'dlQhYKFF9sb2NhdGlvbl9iYXNlZF9pbmZvQg8KDV9zbGV3X3JlcXVlc3RCEgoQX2JvcmVzaWdo'
    'dF9pbWFnZUoECAsQDA==');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'binning_factor', '3': 1, '4': 1, '5': 5, '10': 'binningFactor'},
    {'1': 'rectangle', '3': 2, '4': 1, '5': 11, '6': '.cedar.Rectangle', '10': 'rectangle'},
    {'1': 'image_data', '3': 3, '4': 1, '5': 12, '10': 'imageData'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIlCg5iaW5uaW5nX2ZhY3RvchgBIAEoBVINYmlubmluZ0ZhY3RvchIuCglyZWN0YW'
    '5nbGUYAiABKAsyEC5jZWRhci5SZWN0YW5nbGVSCXJlY3RhbmdsZRIdCgppbWFnZV9kYXRhGAMg'
    'ASgMUglpbWFnZURhdGE=');

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
    {'1': 'centroid_position', '3': 1, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '10': 'centroidPosition'},
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
final $typed_data.Uint8List imageCoordDescriptor = $convert.base64Decode(
    'CgpJbWFnZUNvb3JkEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use processingStatsDescriptor instead')
const ProcessingStats$json = {
  '1': 'ProcessingStats',
  '2': [
    {'1': 'detect_latency', '3': 3, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'detectLatency'},
    {'1': 'overall_latency', '3': 2, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'overallLatency'},
    {'1': 'solve_interval', '3': 1, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'solveInterval'},
    {'1': 'solve_latency', '3': 4, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'solveLatency'},
    {'1': 'solve_attempt_fraction', '3': 5, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'solveAttemptFraction'},
    {'1': 'solve_success_fraction', '3': 6, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'solveSuccessFraction'},
    {'1': 'serve_latency', '3': 7, '4': 1, '5': 11, '6': '.cedar.ValueStats', '10': 'serveLatency'},
  ],
};

/// Descriptor for `ProcessingStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processingStatsDescriptor = $convert.base64Decode(
    'Cg9Qcm9jZXNzaW5nU3RhdHMSOAoOZGV0ZWN0X2xhdGVuY3kYAyABKAsyES5jZWRhci5WYWx1ZV'
    'N0YXRzUg1kZXRlY3RMYXRlbmN5EjoKD292ZXJhbGxfbGF0ZW5jeRgCIAEoCzIRLmNlZGFyLlZh'
    'bHVlU3RhdHNSDm92ZXJhbGxMYXRlbmN5EjgKDnNvbHZlX2ludGVydmFsGAEgASgLMhEuY2VkYX'
    'IuVmFsdWVTdGF0c1INc29sdmVJbnRlcnZhbBI2Cg1zb2x2ZV9sYXRlbmN5GAQgASgLMhEuY2Vk'
    'YXIuVmFsdWVTdGF0c1IMc29sdmVMYXRlbmN5EkcKFnNvbHZlX2F0dGVtcHRfZnJhY3Rpb24YBS'
    'ABKAsyES5jZWRhci5WYWx1ZVN0YXRzUhRzb2x2ZUF0dGVtcHRGcmFjdGlvbhJHChZzb2x2ZV9z'
    'dWNjZXNzX2ZyYWN0aW9uGAYgASgLMhEuY2VkYXIuVmFsdWVTdGF0c1IUc29sdmVTdWNjZXNzRn'
    'JhY3Rpb24SNgoNc2VydmVfbGF0ZW5jeRgHIAEoCzIRLmNlZGFyLlZhbHVlU3RhdHNSDHNlcnZl'
    'TGF0ZW5jeQ==');

@$core.Deprecated('Use valueStatsDescriptor instead')
const ValueStats$json = {
  '1': 'ValueStats',
  '2': [
    {'1': 'recent', '3': 1, '4': 1, '5': 11, '6': '.cedar.DescriptiveStats', '9': 0, '10': 'recent', '17': true},
    {'1': 'session', '3': 2, '4': 1, '5': 11, '6': '.cedar.DescriptiveStats', '9': 1, '10': 'session', '17': true},
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
    {'1': 'median_absolute_deviation', '3': 6, '4': 1, '5': 1, '9': 1, '10': 'medianAbsoluteDeviation', '17': true},
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
    {'1': 'calibration_time', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 0, '10': 'calibrationTime', '17': true},
    {'1': 'target_exposure_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Duration', '9': 1, '10': 'targetExposureTime', '17': true},
    {'1': 'camera_offset', '3': 3, '4': 1, '5': 5, '9': 2, '10': 'cameraOffset', '17': true},
    {'1': 'fov_horizontal', '3': 4, '4': 1, '5': 1, '9': 3, '10': 'fovHorizontal', '17': true},
    {'1': 'lens_distortion', '3': 5, '4': 1, '5': 1, '9': 4, '10': 'lensDistortion', '17': true},
    {'1': 'match_max_error', '3': 8, '4': 1, '5': 1, '9': 5, '10': 'matchMaxError', '17': true},
    {'1': 'lens_fl_mm', '3': 6, '4': 1, '5': 1, '9': 6, '10': 'lensFlMm', '17': true},
    {'1': 'pixel_angular_size', '3': 7, '4': 1, '5': 1, '9': 7, '10': 'pixelAngularSize', '17': true},
  ],
  '8': [
    {'1': '_calibration_time'},
    {'1': '_target_exposure_time'},
    {'1': '_camera_offset'},
    {'1': '_fov_horizontal'},
    {'1': '_lens_distortion'},
    {'1': '_match_max_error'},
    {'1': '_lens_fl_mm'},
    {'1': '_pixel_angular_size'},
  ],
};

/// Descriptor for `CalibrationData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calibrationDataDescriptor = $convert.base64Decode(
    'Cg9DYWxpYnJhdGlvbkRhdGESSgoQY2FsaWJyYXRpb25fdGltZRgBIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBIAFIPY2FsaWJyYXRpb25UaW1liAEBElAKFHRhcmdldF9leHBvc3Vy'
    'ZV90aW1lGAIgASgLMhkuZ29vZ2xlLnByb3RvYnVmLkR1cmF0aW9uSAFSEnRhcmdldEV4cG9zdX'
    'JlVGltZYgBARIoCg1jYW1lcmFfb2Zmc2V0GAMgASgFSAJSDGNhbWVyYU9mZnNldIgBARIqCg5m'
    'b3ZfaG9yaXpvbnRhbBgEIAEoAUgDUg1mb3ZIb3Jpem9udGFsiAEBEiwKD2xlbnNfZGlzdG9ydG'
    'lvbhgFIAEoAUgEUg5sZW5zRGlzdG9ydGlvbogBARIrCg9tYXRjaF9tYXhfZXJyb3IYCCABKAFI'
    'BVINbWF0Y2hNYXhFcnJvcogBARIhCgpsZW5zX2ZsX21tGAYgASgBSAZSCGxlbnNGbE1tiAEBEj'
    'EKEnBpeGVsX2FuZ3VsYXJfc2l6ZRgHIAEoAUgHUhBwaXhlbEFuZ3VsYXJTaXpliAEBQhMKEV9j'
    'YWxpYnJhdGlvbl90aW1lQhcKFV90YXJnZXRfZXhwb3N1cmVfdGltZUIQCg5fY2FtZXJhX29mZn'
    'NldEIRCg9fZm92X2hvcml6b250YWxCEgoQX2xlbnNfZGlzdG9ydGlvbkISChBfbWF0Y2hfbWF4'
    'X2Vycm9yQg0KC19sZW5zX2ZsX21tQhUKE19waXhlbF9hbmd1bGFyX3NpemU=');

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
    {'1': 'target', '3': 1, '4': 1, '5': 11, '6': '.tetra3_server.CelestialCoord', '10': 'target'},
    {'1': 'target_catalog_entry', '3': 8, '4': 1, '5': 11, '6': '.cedar_sky.CatalogEntry', '9': 0, '10': 'targetCatalogEntry', '17': true},
    {'1': 'target_catalog_entry_distance', '3': 9, '4': 1, '5': 1, '9': 1, '10': 'targetCatalogEntryDistance', '17': true},
    {'1': 'target_distance', '3': 2, '4': 1, '5': 1, '9': 2, '10': 'targetDistance', '17': true},
    {'1': 'target_angle', '3': 3, '4': 1, '5': 1, '9': 3, '10': 'targetAngle', '17': true},
    {'1': 'offset_rotation_axis', '3': 5, '4': 1, '5': 1, '9': 4, '10': 'offsetRotationAxis', '17': true},
    {'1': 'offset_tilt_axis', '3': 6, '4': 1, '5': 1, '9': 5, '10': 'offsetTiltAxis', '17': true},
    {'1': 'image_pos', '3': 4, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '9': 6, '10': 'imagePos', '17': true},
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
    'CgtTbGV3UmVxdWVzdBI1CgZ0YXJnZXQYASABKAsyHS50ZXRyYTNfc2VydmVyLkNlbGVzdGlhbE'
    'Nvb3JkUgZ0YXJnZXQSTgoUdGFyZ2V0X2NhdGFsb2dfZW50cnkYCCABKAsyFy5jZWRhcl9za3ku'
    'Q2F0YWxvZ0VudHJ5SABSEnRhcmdldENhdGFsb2dFbnRyeYgBARJGCh10YXJnZXRfY2F0YWxvZ1'
    '9lbnRyeV9kaXN0YW5jZRgJIAEoAUgBUhp0YXJnZXRDYXRhbG9nRW50cnlEaXN0YW5jZYgBARIs'
    'Cg90YXJnZXRfZGlzdGFuY2UYAiABKAFIAlIOdGFyZ2V0RGlzdGFuY2WIAQESJgoMdGFyZ2V0X2'
    'FuZ2xlGAMgASgBSANSC3RhcmdldEFuZ2xliAEBEjUKFG9mZnNldF9yb3RhdGlvbl9heGlzGAUg'
    'ASgBSARSEm9mZnNldFJvdGF0aW9uQXhpc4gBARItChBvZmZzZXRfdGlsdF9heGlzGAYgASgBSA'
    'VSDm9mZnNldFRpbHRBeGlziAEBEjMKCWltYWdlX3BvcxgEIAEoCzIRLmNlZGFyLkltYWdlQ29v'
    'cmRIBlIIaW1hZ2VQb3OIAQFCFwoVX3RhcmdldF9jYXRhbG9nX2VudHJ5QiAKHl90YXJnZXRfY2'
    'F0YWxvZ19lbnRyeV9kaXN0YW5jZUISChBfdGFyZ2V0X2Rpc3RhbmNlQg8KDV90YXJnZXRfYW5n'
    'bGVCFwoVX29mZnNldF9yb3RhdGlvbl9heGlzQhMKEV9vZmZzZXRfdGlsdF9heGlzQgwKCl9pbW'
    'FnZV9wb3NKBAgHEAg=');

@$core.Deprecated('Use polarAlignAdviceDescriptor instead')
const PolarAlignAdvice$json = {
  '1': 'PolarAlignAdvice',
  '2': [
    {'1': 'azimuth_correction', '3': 1, '4': 1, '5': 11, '6': '.cedar.ErrorBoundedValue', '9': 0, '10': 'azimuthCorrection', '17': true},
    {'1': 'altitude_correction', '3': 2, '4': 1, '5': 11, '6': '.cedar.ErrorBoundedValue', '9': 1, '10': 'altitudeCorrection', '17': true},
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
    {'1': 'entry', '3': 1, '4': 1, '5': 11, '6': '.cedar_sky.CatalogEntry', '10': 'entry'},
    {'1': 'image_pos', '3': 2, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '10': 'imagePos'},
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
    {'1': 'capture_boresight', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'captureBoresight', '17': true},
    {'1': 'designate_boresight', '3': 2, '4': 1, '5': 11, '6': '.cedar.ImageCoord', '9': 1, '10': 'designateBoresight', '17': true},
    {'1': 'shutdown_server', '3': 3, '4': 1, '5': 8, '9': 2, '10': 'shutdownServer', '17': true},
    {'1': 'restart_server', '3': 8, '4': 1, '5': 8, '9': 3, '10': 'restartServer', '17': true},
    {'1': 'initiate_slew', '3': 6, '4': 1, '5': 11, '6': '.tetra3_server.CelestialCoord', '9': 4, '10': 'initiateSlew', '17': true},
    {'1': 'stop_slew', '3': 4, '4': 1, '5': 8, '9': 5, '10': 'stopSlew', '17': true},
    {'1': 'save_image', '3': 5, '4': 1, '5': 8, '9': 6, '10': 'saveImage', '17': true},
    {'1': 'update_wifi_access_point', '3': 7, '4': 1, '5': 11, '6': '.cedar.WiFiAccessPoint', '9': 7, '10': 'updateWifiAccessPoint', '17': true},
  ],
  '8': [
    {'1': '_capture_boresight'},
    {'1': '_designate_boresight'},
    {'1': '_shutdown_server'},
    {'1': '_restart_server'},
    {'1': '_initiate_slew'},
    {'1': '_stop_slew'},
    {'1': '_save_image'},
    {'1': '_update_wifi_access_point'},
  ],
};

/// Descriptor for `ActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionRequestDescriptor = $convert.base64Decode(
    'Cg1BY3Rpb25SZXF1ZXN0EjAKEWNhcHR1cmVfYm9yZXNpZ2h0GAEgASgISABSEGNhcHR1cmVCb3'
    'Jlc2lnaHSIAQESRwoTZGVzaWduYXRlX2JvcmVzaWdodBgCIAEoCzIRLmNlZGFyLkltYWdlQ29v'
    'cmRIAVISZGVzaWduYXRlQm9yZXNpZ2h0iAEBEiwKD3NodXRkb3duX3NlcnZlchgDIAEoCEgCUg'
    '5zaHV0ZG93blNlcnZlcogBARIqCg5yZXN0YXJ0X3NlcnZlchgIIAEoCEgDUg1yZXN0YXJ0U2Vy'
    'dmVyiAEBEkcKDWluaXRpYXRlX3NsZXcYBiABKAsyHS50ZXRyYTNfc2VydmVyLkNlbGVzdGlhbE'
    'Nvb3JkSARSDGluaXRpYXRlU2xld4gBARIgCglzdG9wX3NsZXcYBCABKAhIBVIIc3RvcFNsZXeI'
    'AQESIgoKc2F2ZV9pbWFnZRgFIAEoCEgGUglzYXZlSW1hZ2WIAQESVAoYdXBkYXRlX3dpZmlfYW'
    'NjZXNzX3BvaW50GAcgASgLMhYuY2VkYXIuV2lGaUFjY2Vzc1BvaW50SAdSFXVwZGF0ZVdpZmlB'
    'Y2Nlc3NQb2ludIgBAUIUChJfY2FwdHVyZV9ib3Jlc2lnaHRCFgoUX2Rlc2lnbmF0ZV9ib3Jlc2'
    'lnaHRCEgoQX3NodXRkb3duX3NlcnZlckIRCg9fcmVzdGFydF9zZXJ2ZXJCEAoOX2luaXRpYXRl'
    'X3NsZXdCDAoKX3N0b3Bfc2xld0INCgtfc2F2ZV9pbWFnZUIbChlfdXBkYXRlX3dpZmlfYWNjZX'
    'NzX3BvaW50');

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

@$core.Deprecated('Use demoImagesResultDescriptor instead')
const DemoImagesResult$json = {
  '1': 'DemoImagesResult',
  '2': [
    {'1': 'demo_image_name', '3': 1, '4': 3, '5': 9, '10': 'demoImageName'},
  ],
};

/// Descriptor for `DemoImagesResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List demoImagesResultDescriptor = $convert.base64Decode(
    'ChBEZW1vSW1hZ2VzUmVzdWx0EiYKD2RlbW9faW1hZ2VfbmFtZRgBIAMoCVINZGVtb0ltYWdlTm'
    'FtZQ==');

@$core.Deprecated('Use emptyMessageDescriptor instead')
const EmptyMessage$json = {
  '1': 'EmptyMessage',
};

/// Descriptor for `EmptyMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyMessageDescriptor = $convert.base64Decode(
    'CgxFbXB0eU1lc3NhZ2U=');

