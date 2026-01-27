// This is a generated file - do not edit.
//
// Generated from cedar_sky.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use orderingDescriptor instead')
const Ordering$json = {
  '1': 'Ordering',
  '2': [
    {'1': 'UNSPECIFIED', '2': 0},
    {'1': 'BRIGHTNESS', '2': 1},
    {'1': 'SKY_LOCATION', '2': 2},
    {'1': 'ELEVATION', '2': 3},
  ],
};

/// Descriptor for `Ordering`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderingDescriptor = $convert.base64Decode(
    'CghPcmRlcmluZxIPCgtVTlNQRUNJRklFRBAAEg4KCkJSSUdIVE5FU1MQARIQCgxTS1lfTE9DQV'
    'RJT04QAhINCglFTEVWQVRJT04QAw==');

@$core.Deprecated('Use queryCatalogRequestDescriptor instead')
const QueryCatalogRequest$json = {
  '1': 'QueryCatalogRequest',
  '2': [
    {
      '1': 'catalog_entry_match',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.CatalogEntryMatch',
      '10': 'catalogEntryMatch'
    },
    {
      '1': 'max_distance',
      '3': 2,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'maxDistance',
      '17': true
    },
    {
      '1': 'min_elevation',
      '3': 3,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'minElevation',
      '17': true
    },
    {
      '1': 'decrowd_distance',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 2,
      '10': 'decrowdDistance',
      '17': true
    },
    {
      '1': 'ordering',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.cedar_sky.Ordering',
      '9': 3,
      '10': 'ordering',
      '17': true
    },
    {
      '1': 'limit_result',
      '3': 7,
      '4': 1,
      '5': 5,
      '9': 4,
      '10': 'limitResult',
      '17': true
    },
    {
      '1': 'text_search',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'textSearch',
      '17': true
    },
  ],
  '8': [
    {'1': '_max_distance'},
    {'1': '_min_elevation'},
    {'1': '_decrowd_distance'},
    {'1': '_ordering'},
    {'1': '_limit_result'},
    {'1': '_text_search'},
  ],
};

/// Descriptor for `QueryCatalogRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCatalogRequestDescriptor = $convert.base64Decode(
    'ChNRdWVyeUNhdGFsb2dSZXF1ZXN0EkwKE2NhdGFsb2dfZW50cnlfbWF0Y2gYASABKAsyHC5jZW'
    'Rhcl9za3kuQ2F0YWxvZ0VudHJ5TWF0Y2hSEWNhdGFsb2dFbnRyeU1hdGNoEiYKDG1heF9kaXN0'
    'YW5jZRgCIAEoAUgAUgttYXhEaXN0YW5jZYgBARIoCg1taW5fZWxldmF0aW9uGAMgASgBSAFSDG'
    '1pbkVsZXZhdGlvbogBARIuChBkZWNyb3dkX2Rpc3RhbmNlGAUgASgBSAJSD2RlY3Jvd2REaXN0'
    'YW5jZYgBARI0CghvcmRlcmluZxgGIAEoDjITLmNlZGFyX3NreS5PcmRlcmluZ0gDUghvcmRlcm'
    'luZ4gBARImCgxsaW1pdF9yZXN1bHQYByABKAVIBFILbGltaXRSZXN1bHSIAQESJAoLdGV4dF9z'
    'ZWFyY2gYCCABKAlIBVIKdGV4dFNlYXJjaIgBAUIPCg1fbWF4X2Rpc3RhbmNlQhAKDl9taW5fZW'
    'xldmF0aW9uQhMKEV9kZWNyb3dkX2Rpc3RhbmNlQgsKCV9vcmRlcmluZ0IPCg1fbGltaXRfcmVz'
    'dWx0Qg4KDF90ZXh0X3NlYXJjaA==');

@$core.Deprecated('Use catalogEntryMatchDescriptor instead')
const CatalogEntryMatch$json = {
  '1': 'CatalogEntryMatch',
  '2': [
    {
      '1': 'faintest_magnitude',
      '3': 1,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'faintestMagnitude',
      '17': true
    },
    {
      '1': 'match_catalog_label',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'matchCatalogLabel'
    },
    {'1': 'catalog_label', '3': 2, '4': 3, '5': 9, '10': 'catalogLabel'},
    {
      '1': 'match_object_type_label',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'matchObjectTypeLabel'
    },
    {'1': 'object_type_label', '3': 3, '4': 3, '5': 9, '10': 'objectTypeLabel'},
  ],
  '8': [
    {'1': '_faintest_magnitude'},
  ],
};

/// Descriptor for `CatalogEntryMatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogEntryMatchDescriptor = $convert.base64Decode(
    'ChFDYXRhbG9nRW50cnlNYXRjaBIyChJmYWludGVzdF9tYWduaXR1ZGUYASABKAVIAFIRZmFpbn'
    'Rlc3RNYWduaXR1ZGWIAQESLgoTbWF0Y2hfY2F0YWxvZ19sYWJlbBgEIAEoCFIRbWF0Y2hDYXRh'
    'bG9nTGFiZWwSIwoNY2F0YWxvZ19sYWJlbBgCIAMoCVIMY2F0YWxvZ0xhYmVsEjUKF21hdGNoX2'
    '9iamVjdF90eXBlX2xhYmVsGAUgASgIUhRtYXRjaE9iamVjdFR5cGVMYWJlbBIqChFvYmplY3Rf'
    'dHlwZV9sYWJlbBgDIAMoCVIPb2JqZWN0VHlwZUxhYmVsQhUKE19mYWludGVzdF9tYWduaXR1ZG'
    'U=');

@$core.Deprecated('Use queryCatalogResponseDescriptor instead')
const QueryCatalogResponse$json = {
  '1': 'QueryCatalogResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.SelectedCatalogEntry',
      '10': 'entries'
    },
    {'1': 'truncated_count', '3': 2, '4': 1, '5': 5, '10': 'truncatedCount'},
  ],
};

/// Descriptor for `QueryCatalogResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCatalogResponseDescriptor = $convert.base64Decode(
    'ChRRdWVyeUNhdGFsb2dSZXNwb25zZRI5CgdlbnRyaWVzGAEgAygLMh8uY2VkYXJfc2t5LlNlbG'
    'VjdGVkQ2F0YWxvZ0VudHJ5UgdlbnRyaWVzEicKD3RydW5jYXRlZF9jb3VudBgCIAEoBVIOdHJ1'
    'bmNhdGVkQ291bnQ=');

@$core.Deprecated('Use selectedCatalogEntryDescriptor instead')
const SelectedCatalogEntry$json = {
  '1': 'SelectedCatalogEntry',
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
      '1': 'deduped_entries',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.CatalogEntry',
      '10': 'dedupedEntries'
    },
    {
      '1': 'decrowded_entries',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.CatalogEntry',
      '10': 'decrowdedEntries'
    },
    {
      '1': 'altitude',
      '3': 4,
      '4': 1,
      '5': 1,
      '9': 0,
      '10': 'altitude',
      '17': true
    },
    {
      '1': 'azimuth',
      '3': 5,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'azimuth',
      '17': true
    },
  ],
  '8': [
    {'1': '_altitude'},
    {'1': '_azimuth'},
  ],
};

/// Descriptor for `SelectedCatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectedCatalogEntryDescriptor = $convert.base64Decode(
    'ChRTZWxlY3RlZENhdGFsb2dFbnRyeRItCgVlbnRyeRgBIAEoCzIXLmNlZGFyX3NreS5DYXRhbG'
    '9nRW50cnlSBWVudHJ5EkAKD2RlZHVwZWRfZW50cmllcxgCIAMoCzIXLmNlZGFyX3NreS5DYXRh'
    'bG9nRW50cnlSDmRlZHVwZWRFbnRyaWVzEkQKEWRlY3Jvd2RlZF9lbnRyaWVzGAMgAygLMhcuY2'
    'VkYXJfc2t5LkNhdGFsb2dFbnRyeVIQZGVjcm93ZGVkRW50cmllcxIfCghhbHRpdHVkZRgEIAEo'
    'AUgAUghhbHRpdHVkZYgBARIdCgdhemltdXRoGAUgASgBSAFSB2F6aW11dGiIAQFCCwoJX2FsdG'
    'l0dWRlQgoKCF9hemltdXRo');

@$core.Deprecated('Use catalogEntryDescriptor instead')
const CatalogEntry$json = {
  '1': 'CatalogEntry',
  '2': [
    {'1': 'catalog_label', '3': 1, '4': 1, '5': 9, '10': 'catalogLabel'},
    {'1': 'catalog_entry', '3': 2, '4': 1, '5': 9, '10': 'catalogEntry'},
    {
      '1': 'coord',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.cedar_common.CelestialCoord',
      '10': 'coord'
    },
    {
      '1': 'constellation',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.Constellation',
      '9': 0,
      '10': 'constellation',
      '17': true
    },
    {
      '1': 'object_type',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.cedar_sky.ObjectType',
      '10': 'objectType'
    },
    {
      '1': 'magnitude',
      '3': 6,
      '4': 1,
      '5': 1,
      '9': 1,
      '10': 'magnitude',
      '17': true
    },
    {
      '1': 'angular_size',
      '3': 7,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'angularSize',
      '17': true
    },
    {
      '1': 'common_name',
      '3': 8,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'commonName',
      '17': true
    },
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '9': 4, '10': 'notes', '17': true},
  ],
  '8': [
    {'1': '_constellation'},
    {'1': '_magnitude'},
    {'1': '_angular_size'},
    {'1': '_common_name'},
    {'1': '_notes'},
  ],
};

/// Descriptor for `CatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogEntryDescriptor = $convert.base64Decode(
    'CgxDYXRhbG9nRW50cnkSIwoNY2F0YWxvZ19sYWJlbBgBIAEoCVIMY2F0YWxvZ0xhYmVsEiMKDW'
    'NhdGFsb2dfZW50cnkYAiABKAlSDGNhdGFsb2dFbnRyeRIyCgVjb29yZBgDIAEoCzIcLmNlZGFy'
    'X2NvbW1vbi5DZWxlc3RpYWxDb29yZFIFY29vcmQSQwoNY29uc3RlbGxhdGlvbhgEIAEoCzIYLm'
    'NlZGFyX3NreS5Db25zdGVsbGF0aW9uSABSDWNvbnN0ZWxsYXRpb26IAQESNgoLb2JqZWN0X3R5'
    'cGUYBSABKAsyFS5jZWRhcl9za3kuT2JqZWN0VHlwZVIKb2JqZWN0VHlwZRIhCgltYWduaXR1ZG'
    'UYBiABKAFIAVIJbWFnbml0dWRliAEBEiYKDGFuZ3VsYXJfc2l6ZRgHIAEoCUgCUgthbmd1bGFy'
    'U2l6ZYgBARIkCgtjb21tb25fbmFtZRgIIAEoCUgDUgpjb21tb25OYW1liAEBEhkKBW5vdGVzGA'
    'kgASgJSARSBW5vdGVziAEBQhAKDl9jb25zdGVsbGF0aW9uQgwKCl9tYWduaXR1ZGVCDwoNX2Fu'
    'Z3VsYXJfc2l6ZUIOCgxfY29tbW9uX25hbWVCCAoGX25vdGVz');

@$core.Deprecated('Use catalogDescriptionDescriptor instead')
const CatalogDescription$json = {
  '1': 'CatalogDescription',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'copyright',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'copyright',
      '17': true
    },
    {
      '1': 'license',
      '3': 6,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'license',
      '17': true
    },
  ],
  '8': [
    {'1': '_copyright'},
    {'1': '_license'},
  ],
};

/// Descriptor for `CatalogDescription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogDescriptionDescriptor = $convert.base64Decode(
    'ChJDYXRhbG9nRGVzY3JpcHRpb24SFAoFbGFiZWwYASABKAlSBWxhYmVsEhIKBG5hbWUYAiABKA'
    'lSBG5hbWUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEhYKBnNvdXJjZRgEIAEo'
    'CVIGc291cmNlEiEKCWNvcHlyaWdodBgFIAEoCUgAUgljb3B5cmlnaHSIAQESHQoHbGljZW5zZR'
    'gGIAEoCUgBUgdsaWNlbnNliAEBQgwKCl9jb3B5cmlnaHRCCgoIX2xpY2Vuc2U=');

@$core.Deprecated('Use catalogDescriptionResponseDescriptor instead')
const CatalogDescriptionResponse$json = {
  '1': 'CatalogDescriptionResponse',
  '2': [
    {
      '1': 'catalog_descriptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.CatalogDescription',
      '10': 'catalogDescriptions'
    },
  ],
};

/// Descriptor for `CatalogDescriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogDescriptionResponseDescriptor =
    $convert.base64Decode(
        'ChpDYXRhbG9nRGVzY3JpcHRpb25SZXNwb25zZRJQChRjYXRhbG9nX2Rlc2NyaXB0aW9ucxgBIA'
        'MoCzIdLmNlZGFyX3NreS5DYXRhbG9nRGVzY3JpcHRpb25SE2NhdGFsb2dEZXNjcmlwdGlvbnM=');

@$core.Deprecated('Use objectTypeDescriptor instead')
const ObjectType$json = {
  '1': 'ObjectType',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    {'1': 'broad_category', '3': 2, '4': 1, '5': 9, '10': 'broadCategory'},
  ],
};

/// Descriptor for `ObjectType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectTypeDescriptor = $convert.base64Decode(
    'CgpPYmplY3RUeXBlEhQKBWxhYmVsGAEgASgJUgVsYWJlbBIlCg5icm9hZF9jYXRlZ29yeRgCIA'
    'EoCVINYnJvYWRDYXRlZ29yeQ==');

@$core.Deprecated('Use objectTypeResponseDescriptor instead')
const ObjectTypeResponse$json = {
  '1': 'ObjectTypeResponse',
  '2': [
    {
      '1': 'object_types',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.ObjectType',
      '10': 'objectTypes'
    },
  ],
};

/// Descriptor for `ObjectTypeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List objectTypeResponseDescriptor = $convert.base64Decode(
    'ChJPYmplY3RUeXBlUmVzcG9uc2USOAoMb2JqZWN0X3R5cGVzGAEgAygLMhUuY2VkYXJfc2t5Lk'
    '9iamVjdFR5cGVSC29iamVjdFR5cGVz');

@$core.Deprecated('Use constellationDescriptor instead')
const Constellation$json = {
  '1': 'Constellation',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `Constellation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List constellationDescriptor = $convert.base64Decode(
    'Cg1Db25zdGVsbGF0aW9uEhQKBWxhYmVsGAEgASgJUgVsYWJlbBISCgRuYW1lGAIgASgJUgRuYW'
    '1l');

@$core.Deprecated('Use constellationResponseDescriptor instead')
const ConstellationResponse$json = {
  '1': 'ConstellationResponse',
  '2': [
    {
      '1': 'constellations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.cedar_sky.Constellation',
      '10': 'constellations'
    },
  ],
};

/// Descriptor for `ConstellationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List constellationResponseDescriptor = $convert.base64Decode(
    'ChVDb25zdGVsbGF0aW9uUmVzcG9uc2USQAoOY29uc3RlbGxhdGlvbnMYASADKAsyGC5jZWRhcl'
    '9za3kuQ29uc3RlbGxhdGlvblIOY29uc3RlbGxhdGlvbnM=');

@$core.Deprecated('Use catalogEntryKeyDescriptor instead')
const CatalogEntryKey$json = {
  '1': 'CatalogEntryKey',
  '2': [
    {'1': 'cat_label', '3': 1, '4': 1, '5': 9, '10': 'catLabel'},
    {'1': 'entry', '3': 2, '4': 1, '5': 9, '10': 'entry'},
  ],
};

/// Descriptor for `CatalogEntryKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List catalogEntryKeyDescriptor = $convert.base64Decode(
    'Cg9DYXRhbG9nRW50cnlLZXkSGwoJY2F0X2xhYmVsGAEgASgJUghjYXRMYWJlbBIUCgVlbnRyeR'
    'gCIAEoCVIFZW50cnk=');
