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

import 'cedar_common.pb.dart' as $4;
import 'cedar_sky.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'cedar_sky.pbenum.dart';

/// Describes various constraints that must all be satisfied for a sky catalog
/// entry to be returned by QueryCatalogEntries() RPC.
class QueryCatalogRequest extends $pb.GeneratedMessage {
  factory QueryCatalogRequest({
    CatalogEntryMatch? catalogEntryMatch,
    $core.double? maxDistance,
    $core.double? minElevation,
    $core.double? decrowdDistance,
    Ordering? ordering,
    $core.int? limitResult,
    $core.String? textSearch,
  }) {
    final $result = create();
    if (catalogEntryMatch != null) {
      $result.catalogEntryMatch = catalogEntryMatch;
    }
    if (maxDistance != null) {
      $result.maxDistance = maxDistance;
    }
    if (minElevation != null) {
      $result.minElevation = minElevation;
    }
    if (decrowdDistance != null) {
      $result.decrowdDistance = decrowdDistance;
    }
    if (ordering != null) {
      $result.ordering = ordering;
    }
    if (limitResult != null) {
      $result.limitResult = limitResult;
    }
    if (textSearch != null) {
      $result.textSearch = textSearch;
    }
    return $result;
  }
  QueryCatalogRequest._() : super();
  factory QueryCatalogRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryCatalogRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QueryCatalogRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOM<CatalogEntryMatch>(1, _omitFieldNames ? '' : 'catalogEntryMatch', subBuilder: CatalogEntryMatch.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'maxDistance', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'minElevation', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'decrowdDistance', $pb.PbFieldType.OD)
    ..e<Ordering>(6, _omitFieldNames ? '' : 'ordering', $pb.PbFieldType.OE, defaultOrMaker: Ordering.UNSPECIFIED, valueOf: Ordering.valueOf, enumValues: Ordering.values)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'limitResult', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'textSearch')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryCatalogRequest clone() => QueryCatalogRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryCatalogRequest copyWith(void Function(QueryCatalogRequest) updates) => super.copyWith((message) => updates(message as QueryCatalogRequest)) as QueryCatalogRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryCatalogRequest create() => QueryCatalogRequest._();
  QueryCatalogRequest createEmptyInstance() => create();
  static $pb.PbList<QueryCatalogRequest> createRepeated() => $pb.PbList<QueryCatalogRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryCatalogRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryCatalogRequest>(create);
  static QueryCatalogRequest? _defaultInstance;

  /// Constraints relative to information about the sky objects themselves.
  @$pb.TagNumber(1)
  CatalogEntryMatch get catalogEntryMatch => $_getN(0);
  @$pb.TagNumber(1)
  set catalogEntryMatch(CatalogEntryMatch v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCatalogEntryMatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogEntryMatch() => $_clearField(1);
  @$pb.TagNumber(1)
  CatalogEntryMatch ensureCatalogEntryMatch() => $_ensure(0);

  /// Distance from the current telescope boresight position in the sky. Ignored
  /// if Cedar has no plate solution.
  @$pb.TagNumber(2)
  $core.double get maxDistance => $_getN(1);
  @$pb.TagNumber(2)
  set maxDistance($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxDistance() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxDistance() => $_clearField(2);

  /// Elevation relative to the current horizon. Ignored if Cedar does not know
  /// the observer location and current time.
  @$pb.TagNumber(3)
  $core.double get minElevation => $_getN(2);
  @$pb.TagNumber(3)
  set minElevation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinElevation() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinElevation() => $_clearField(3);

  /// If two objects from the same catalog satisfy the criteria, and are
  /// within this angular distance of each other, only one is returned. The
  /// brighter object is returned. If omitted, no decrowding is done.
  @$pb.TagNumber(5)
  $core.double get decrowdDistance => $_getN(3);
  @$pb.TagNumber(5)
  set decrowdDistance($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasDecrowdDistance() => $_has(3);
  @$pb.TagNumber(5)
  void clearDecrowdDistance() => $_clearField(5);

  @$pb.TagNumber(6)
  Ordering get ordering => $_getN(4);
  @$pb.TagNumber(6)
  set ordering(Ordering v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasOrdering() => $_has(4);
  @$pb.TagNumber(6)
  void clearOrdering() => $_clearField(6);

  /// If given, caps the number of `entries` in QueryCatalogResponse.
  @$pb.TagNumber(7)
  $core.int get limitResult => $_getIZ(5);
  @$pb.TagNumber(7)
  set limitResult($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasLimitResult() => $_has(5);
  @$pb.TagNumber(7)
  void clearLimitResult() => $_clearField(7);

  /// If given, applies a text match constraint. The server canonicalizes the
  /// given string, removing dangerous characters, tokenizing it, etc. Each token
  /// is treated as a prefix search term, and multiple token terms are combined
  /// with implicit AND; order is not significant. Thus, |andr gal| and
  /// |gal andr| both match "Andromeda Galaxy".
  /// Note that when `text_search` is given, the `catalog_entry_match`,
  /// `max_distance`, and `min_elevation` constraints are ignored.
  @$pb.TagNumber(8)
  $core.String get textSearch => $_getSZ(6);
  @$pb.TagNumber(8)
  set textSearch($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasTextSearch() => $_has(6);
  @$pb.TagNumber(8)
  void clearTextSearch() => $_clearField(8);
}

/// Specifies what intrinsic criteria to apply when matching catalog entries.
class CatalogEntryMatch extends $pb.GeneratedMessage {
  factory CatalogEntryMatch({
    $core.int? faintestMagnitude,
    $core.Iterable<$core.String>? catalogLabel,
    $core.Iterable<$core.String>? objectTypeLabel,
    $core.bool? matchCatalogLabel,
    $core.bool? matchObjectTypeLabel,
  }) {
    final $result = create();
    if (faintestMagnitude != null) {
      $result.faintestMagnitude = faintestMagnitude;
    }
    if (catalogLabel != null) {
      $result.catalogLabel.addAll(catalogLabel);
    }
    if (objectTypeLabel != null) {
      $result.objectTypeLabel.addAll(objectTypeLabel);
    }
    if (matchCatalogLabel != null) {
      $result.matchCatalogLabel = matchCatalogLabel;
    }
    if (matchObjectTypeLabel != null) {
      $result.matchObjectTypeLabel = matchObjectTypeLabel;
    }
    return $result;
  }
  CatalogEntryMatch._() : super();
  factory CatalogEntryMatch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CatalogEntryMatch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CatalogEntryMatch', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'faintestMagnitude', $pb.PbFieldType.O3)
    ..pPS(2, _omitFieldNames ? '' : 'catalogLabel')
    ..pPS(3, _omitFieldNames ? '' : 'objectTypeLabel')
    ..aOB(4, _omitFieldNames ? '' : 'matchCatalogLabel')
    ..aOB(5, _omitFieldNames ? '' : 'matchObjectTypeLabel')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CatalogEntryMatch clone() => CatalogEntryMatch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CatalogEntryMatch copyWith(void Function(CatalogEntryMatch) updates) => super.copyWith((message) => updates(message as CatalogEntryMatch)) as CatalogEntryMatch;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogEntryMatch create() => CatalogEntryMatch._();
  CatalogEntryMatch createEmptyInstance() => create();
  static $pb.PbList<CatalogEntryMatch> createRepeated() => $pb.PbList<CatalogEntryMatch>();
  @$core.pragma('dart2js:noInline')
  static CatalogEntryMatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogEntryMatch>(create);
  static CatalogEntryMatch? _defaultInstance;

  /// Limiting magnitude. If provided, objects fainter than the limit are
  /// excluded.
  @$pb.TagNumber(1)
  $core.int get faintestMagnitude => $_getIZ(0);
  @$pb.TagNumber(1)
  set faintestMagnitude($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaintestMagnitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaintestMagnitude() => $_clearField(1);

  /// What catalog(s) to search.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get catalogLabel => $_getList(1);

  /// What object type(s) to search. Note: if empty, no filtering on object
  /// type is done.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get objectTypeLabel => $_getList(2);

  /// If true, `catalog_label` is used to match catalog(s).
  @$pb.TagNumber(4)
  $core.bool get matchCatalogLabel => $_getBF(3);
  @$pb.TagNumber(4)
  set matchCatalogLabel($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMatchCatalogLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearMatchCatalogLabel() => $_clearField(4);

  /// If true, `object_type_label` is used to match object type(s).
  @$pb.TagNumber(5)
  $core.bool get matchObjectTypeLabel => $_getBF(4);
  @$pb.TagNumber(5)
  set matchObjectTypeLabel($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMatchObjectTypeLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearMatchObjectTypeLabel() => $_clearField(5);
}

class QueryCatalogResponse extends $pb.GeneratedMessage {
  factory QueryCatalogResponse({
    $core.Iterable<SelectedCatalogEntry>? entries,
    $core.int? truncatedCount,
  }) {
    final $result = create();
    if (entries != null) {
      $result.entries.addAll(entries);
    }
    if (truncatedCount != null) {
      $result.truncatedCount = truncatedCount;
    }
    return $result;
  }
  QueryCatalogResponse._() : super();
  factory QueryCatalogResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryCatalogResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QueryCatalogResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..pc<SelectedCatalogEntry>(1, _omitFieldNames ? '' : 'entries', $pb.PbFieldType.PM, subBuilder: SelectedCatalogEntry.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'truncatedCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryCatalogResponse clone() => QueryCatalogResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryCatalogResponse copyWith(void Function(QueryCatalogResponse) updates) => super.copyWith((message) => updates(message as QueryCatalogResponse)) as QueryCatalogResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryCatalogResponse create() => QueryCatalogResponse._();
  QueryCatalogResponse createEmptyInstance() => create();
  static $pb.PbList<QueryCatalogResponse> createRepeated() => $pb.PbList<QueryCatalogResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryCatalogResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryCatalogResponse>(create);
  static QueryCatalogResponse? _defaultInstance;

  /// The catalog entries that satisfy the QueryCatalogRequest criteria.
  @$pb.TagNumber(1)
  $pb.PbList<SelectedCatalogEntry> get entries => $_getList(0);

  /// If `limit_result` is specified in QueryCatalogRequest, this will
  /// be the number of entries that were truncated after the limit was
  /// reached.
  @$pb.TagNumber(2)
  $core.int get truncatedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set truncatedCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTruncatedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncatedCount() => $_clearField(2);
}

class SelectedCatalogEntry extends $pb.GeneratedMessage {
  factory SelectedCatalogEntry({
    CatalogEntry? entry,
    $core.Iterable<CatalogEntry>? dedupedEntries,
    $core.Iterable<CatalogEntry>? decrowdedEntries,
    $core.double? altitude,
    $core.double? azimuth,
  }) {
    final $result = create();
    if (entry != null) {
      $result.entry = entry;
    }
    if (dedupedEntries != null) {
      $result.dedupedEntries.addAll(dedupedEntries);
    }
    if (decrowdedEntries != null) {
      $result.decrowdedEntries.addAll(decrowdedEntries);
    }
    if (altitude != null) {
      $result.altitude = altitude;
    }
    if (azimuth != null) {
      $result.azimuth = azimuth;
    }
    return $result;
  }
  SelectedCatalogEntry._() : super();
  factory SelectedCatalogEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectedCatalogEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SelectedCatalogEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOM<CatalogEntry>(1, _omitFieldNames ? '' : 'entry', subBuilder: CatalogEntry.create)
    ..pc<CatalogEntry>(2, _omitFieldNames ? '' : 'dedupedEntries', $pb.PbFieldType.PM, subBuilder: CatalogEntry.create)
    ..pc<CatalogEntry>(3, _omitFieldNames ? '' : 'decrowdedEntries', $pb.PbFieldType.PM, subBuilder: CatalogEntry.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'altitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectedCatalogEntry clone() => SelectedCatalogEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectedCatalogEntry copyWith(void Function(SelectedCatalogEntry) updates) => super.copyWith((message) => updates(message as SelectedCatalogEntry)) as SelectedCatalogEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectedCatalogEntry create() => SelectedCatalogEntry._();
  SelectedCatalogEntry createEmptyInstance() => create();
  static $pb.PbList<SelectedCatalogEntry> createRepeated() => $pb.PbList<SelectedCatalogEntry>();
  @$core.pragma('dart2js:noInline')
  static SelectedCatalogEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectedCatalogEntry>(create);
  static SelectedCatalogEntry? _defaultInstance;

  @$pb.TagNumber(1)
  CatalogEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(CatalogEntry v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  CatalogEntry ensureEntry() => $_ensure(0);

  /// Other entries, if any, that were suppressed due to `dedup_distance` in the
  /// Cedar sky implementation.
  @$pb.TagNumber(2)
  $pb.PbList<CatalogEntry> get dedupedEntries => $_getList(1);

  /// Other entries, if any, that were suppressed due to `decrowd_distance` in
  /// the QueryCatalogRequest.
  @$pb.TagNumber(3)
  $pb.PbList<CatalogEntry> get decrowdedEntries => $_getList(2);

  /// Altitude (degrees, relative to the local horizon).
  @$pb.TagNumber(4)
  $core.double get altitude => $_getN(3);
  @$pb.TagNumber(4)
  set altitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAltitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearAltitude() => $_clearField(4);

  /// Azimuth (degrees, positive clockwise from north).
  @$pb.TagNumber(5)
  $core.double get azimuth => $_getN(4);
  @$pb.TagNumber(5)
  set azimuth($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAzimuth() => $_has(4);
  @$pb.TagNumber(5)
  void clearAzimuth() => $_clearField(5);
}

class CatalogEntry extends $pb.GeneratedMessage {
  factory CatalogEntry({
    $core.String? catalogLabel,
    $core.String? catalogEntry,
    $4.CelestialCoord? coord,
    Constellation? constellation,
    ObjectType? objectType,
    $core.double? magnitude,
    $core.String? angularSize,
    $core.String? commonName,
    $core.String? notes,
  }) {
    final $result = create();
    if (catalogLabel != null) {
      $result.catalogLabel = catalogLabel;
    }
    if (catalogEntry != null) {
      $result.catalogEntry = catalogEntry;
    }
    if (coord != null) {
      $result.coord = coord;
    }
    if (constellation != null) {
      $result.constellation = constellation;
    }
    if (objectType != null) {
      $result.objectType = objectType;
    }
    if (magnitude != null) {
      $result.magnitude = magnitude;
    }
    if (angularSize != null) {
      $result.angularSize = angularSize;
    }
    if (commonName != null) {
      $result.commonName = commonName;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  CatalogEntry._() : super();
  factory CatalogEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CatalogEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CatalogEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'catalogLabel')
    ..aOS(2, _omitFieldNames ? '' : 'catalogEntry')
    ..aOM<$4.CelestialCoord>(3, _omitFieldNames ? '' : 'coord', subBuilder: $4.CelestialCoord.create)
    ..aOM<Constellation>(4, _omitFieldNames ? '' : 'constellation', subBuilder: Constellation.create)
    ..aOM<ObjectType>(5, _omitFieldNames ? '' : 'objectType', subBuilder: ObjectType.create)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'magnitude', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'angularSize')
    ..aOS(8, _omitFieldNames ? '' : 'commonName')
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CatalogEntry clone() => CatalogEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CatalogEntry copyWith(void Function(CatalogEntry) updates) => super.copyWith((message) => updates(message as CatalogEntry)) as CatalogEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogEntry create() => CatalogEntry._();
  CatalogEntry createEmptyInstance() => create();
  static $pb.PbList<CatalogEntry> createRepeated() => $pb.PbList<CatalogEntry>();
  @$core.pragma('dart2js:noInline')
  static CatalogEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogEntry>(create);
  static CatalogEntry? _defaultInstance;

  /// These two fields combine to be globally unique entry label, e.g. 'M51',
  /// 'NGC3982'.
  @$pb.TagNumber(1)
  $core.String get catalogLabel => $_getSZ(0);
  @$pb.TagNumber(1)
  set catalogLabel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCatalogLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatalogLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get catalogEntry => $_getSZ(1);
  @$pb.TagNumber(2)
  set catalogEntry($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCatalogEntry() => $_has(1);
  @$pb.TagNumber(2)
  void clearCatalogEntry() => $_clearField(2);

  @$pb.TagNumber(3)
  $4.CelestialCoord get coord => $_getN(2);
  @$pb.TagNumber(3)
  set coord($4.CelestialCoord v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCoord() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoord() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.CelestialCoord ensureCoord() => $_ensure(2);

  @$pb.TagNumber(4)
  Constellation get constellation => $_getN(3);
  @$pb.TagNumber(4)
  set constellation(Constellation v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasConstellation() => $_has(3);
  @$pb.TagNumber(4)
  void clearConstellation() => $_clearField(4);
  @$pb.TagNumber(4)
  Constellation ensureConstellation() => $_ensure(3);

  @$pb.TagNumber(5)
  ObjectType get objectType => $_getN(4);
  @$pb.TagNumber(5)
  set objectType(ObjectType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasObjectType() => $_has(4);
  @$pb.TagNumber(5)
  void clearObjectType() => $_clearField(5);
  @$pb.TagNumber(5)
  ObjectType ensureObjectType() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get magnitude => $_getN(5);
  @$pb.TagNumber(6)
  set magnitude($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMagnitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearMagnitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get angularSize => $_getSZ(6);
  @$pb.TagNumber(7)
  set angularSize($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAngularSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearAngularSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get commonName => $_getSZ(7);
  @$pb.TagNumber(8)
  set commonName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCommonName() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommonName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);
}

class CatalogDescription extends $pb.GeneratedMessage {
  factory CatalogDescription({
    $core.String? label,
    $core.String? name,
    $core.String? description,
    $core.String? source,
    $core.String? copyright,
    $core.String? license,
  }) {
    final $result = create();
    if (label != null) {
      $result.label = label;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (source != null) {
      $result.source = source;
    }
    if (copyright != null) {
      $result.copyright = copyright;
    }
    if (license != null) {
      $result.license = license;
    }
    return $result;
  }
  CatalogDescription._() : super();
  factory CatalogDescription.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CatalogDescription.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CatalogDescription', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'source')
    ..aOS(5, _omitFieldNames ? '' : 'copyright')
    ..aOS(6, _omitFieldNames ? '' : 'license')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CatalogDescription clone() => CatalogDescription()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CatalogDescription copyWith(void Function(CatalogDescription) updates) => super.copyWith((message) => updates(message as CatalogDescription)) as CatalogDescription;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogDescription create() => CatalogDescription._();
  CatalogDescription createEmptyInstance() => create();
  static $pb.PbList<CatalogDescription> createRepeated() => $pb.PbList<CatalogDescription>();
  @$core.pragma('dart2js:noInline')
  static CatalogDescription getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogDescription>(create);
  static CatalogDescription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get source => $_getSZ(3);
  @$pb.TagNumber(4)
  set source($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get copyright => $_getSZ(4);
  @$pb.TagNumber(5)
  set copyright($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCopyright() => $_has(4);
  @$pb.TagNumber(5)
  void clearCopyright() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get license => $_getSZ(5);
  @$pb.TagNumber(6)
  set license($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLicense() => $_has(5);
  @$pb.TagNumber(6)
  void clearLicense() => $_clearField(6);
}

class CatalogDescriptionResponse extends $pb.GeneratedMessage {
  factory CatalogDescriptionResponse({
    $core.Iterable<CatalogDescription>? catalogDescriptions,
  }) {
    final $result = create();
    if (catalogDescriptions != null) {
      $result.catalogDescriptions.addAll(catalogDescriptions);
    }
    return $result;
  }
  CatalogDescriptionResponse._() : super();
  factory CatalogDescriptionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CatalogDescriptionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CatalogDescriptionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..pc<CatalogDescription>(1, _omitFieldNames ? '' : 'catalogDescriptions', $pb.PbFieldType.PM, subBuilder: CatalogDescription.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CatalogDescriptionResponse clone() => CatalogDescriptionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CatalogDescriptionResponse copyWith(void Function(CatalogDescriptionResponse) updates) => super.copyWith((message) => updates(message as CatalogDescriptionResponse)) as CatalogDescriptionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogDescriptionResponse create() => CatalogDescriptionResponse._();
  CatalogDescriptionResponse createEmptyInstance() => create();
  static $pb.PbList<CatalogDescriptionResponse> createRepeated() => $pb.PbList<CatalogDescriptionResponse>();
  @$core.pragma('dart2js:noInline')
  static CatalogDescriptionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogDescriptionResponse>(create);
  static CatalogDescriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CatalogDescription> get catalogDescriptions => $_getList(0);
}

class ObjectType extends $pb.GeneratedMessage {
  factory ObjectType({
    $core.String? label,
    $core.String? broadCategory,
  }) {
    final $result = create();
    if (label != null) {
      $result.label = label;
    }
    if (broadCategory != null) {
      $result.broadCategory = broadCategory;
    }
    return $result;
  }
  ObjectType._() : super();
  factory ObjectType.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjectType.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ObjectType', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aOS(2, _omitFieldNames ? '' : 'broadCategory')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObjectType clone() => ObjectType()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObjectType copyWith(void Function(ObjectType) updates) => super.copyWith((message) => updates(message as ObjectType)) as ObjectType;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectType create() => ObjectType._();
  ObjectType createEmptyInstance() => create();
  static $pb.PbList<ObjectType> createRepeated() => $pb.PbList<ObjectType>();
  @$core.pragma('dart2js:noInline')
  static ObjectType getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjectType>(create);
  static ObjectType? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get broadCategory => $_getSZ(1);
  @$pb.TagNumber(2)
  set broadCategory($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBroadCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearBroadCategory() => $_clearField(2);
}

class ObjectTypeResponse extends $pb.GeneratedMessage {
  factory ObjectTypeResponse({
    $core.Iterable<ObjectType>? objectTypes,
  }) {
    final $result = create();
    if (objectTypes != null) {
      $result.objectTypes.addAll(objectTypes);
    }
    return $result;
  }
  ObjectTypeResponse._() : super();
  factory ObjectTypeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjectTypeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ObjectTypeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..pc<ObjectType>(1, _omitFieldNames ? '' : 'objectTypes', $pb.PbFieldType.PM, subBuilder: ObjectType.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObjectTypeResponse clone() => ObjectTypeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObjectTypeResponse copyWith(void Function(ObjectTypeResponse) updates) => super.copyWith((message) => updates(message as ObjectTypeResponse)) as ObjectTypeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectTypeResponse create() => ObjectTypeResponse._();
  ObjectTypeResponse createEmptyInstance() => create();
  static $pb.PbList<ObjectTypeResponse> createRepeated() => $pb.PbList<ObjectTypeResponse>();
  @$core.pragma('dart2js:noInline')
  static ObjectTypeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjectTypeResponse>(create);
  static ObjectTypeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ObjectType> get objectTypes => $_getList(0);
}

class Constellation extends $pb.GeneratedMessage {
  factory Constellation({
    $core.String? label,
    $core.String? name,
  }) {
    final $result = create();
    if (label != null) {
      $result.label = label;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  Constellation._() : super();
  factory Constellation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Constellation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Constellation', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'label')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Constellation clone() => Constellation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Constellation copyWith(void Function(Constellation) updates) => super.copyWith((message) => updates(message as Constellation)) as Constellation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Constellation create() => Constellation._();
  Constellation createEmptyInstance() => create();
  static $pb.PbList<Constellation> createRepeated() => $pb.PbList<Constellation>();
  @$core.pragma('dart2js:noInline')
  static Constellation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Constellation>(create);
  static Constellation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get label => $_getSZ(0);
  @$pb.TagNumber(1)
  set label($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class ConstellationResponse extends $pb.GeneratedMessage {
  factory ConstellationResponse({
    $core.Iterable<Constellation>? constellations,
  }) {
    final $result = create();
    if (constellations != null) {
      $result.constellations.addAll(constellations);
    }
    return $result;
  }
  ConstellationResponse._() : super();
  factory ConstellationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConstellationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConstellationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..pc<Constellation>(1, _omitFieldNames ? '' : 'constellations', $pb.PbFieldType.PM, subBuilder: Constellation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConstellationResponse clone() => ConstellationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConstellationResponse copyWith(void Function(ConstellationResponse) updates) => super.copyWith((message) => updates(message as ConstellationResponse)) as ConstellationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConstellationResponse create() => ConstellationResponse._();
  ConstellationResponse createEmptyInstance() => create();
  static $pb.PbList<ConstellationResponse> createRepeated() => $pb.PbList<ConstellationResponse>();
  @$core.pragma('dart2js:noInline')
  static ConstellationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConstellationResponse>(create);
  static ConstellationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Constellation> get constellations => $_getList(0);
}

class CatalogEntryKey extends $pb.GeneratedMessage {
  factory CatalogEntryKey({
    $core.String? catLabel,
    $core.String? entry,
  }) {
    final $result = create();
    if (catLabel != null) {
      $result.catLabel = catLabel;
    }
    if (entry != null) {
      $result.entry = entry;
    }
    return $result;
  }
  CatalogEntryKey._() : super();
  factory CatalogEntryKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CatalogEntryKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CatalogEntryKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'cedar_sky'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'catLabel')
    ..aOS(2, _omitFieldNames ? '' : 'entry')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CatalogEntryKey clone() => CatalogEntryKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CatalogEntryKey copyWith(void Function(CatalogEntryKey) updates) => super.copyWith((message) => updates(message as CatalogEntryKey)) as CatalogEntryKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CatalogEntryKey create() => CatalogEntryKey._();
  CatalogEntryKey createEmptyInstance() => create();
  static $pb.PbList<CatalogEntryKey> createRepeated() => $pb.PbList<CatalogEntryKey>();
  @$core.pragma('dart2js:noInline')
  static CatalogEntryKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CatalogEntryKey>(create);
  static CatalogEntryKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get catLabel => $_getSZ(0);
  @$pb.TagNumber(1)
  set catLabel($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCatLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearCatLabel() => $_clearField(1);

  /// or COM.
  @$pb.TagNumber(2)
  $core.String get entry => $_getSZ(1);
  @$pb.TagNumber(2)
  set entry($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEntry() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntry() => $_clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
