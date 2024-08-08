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

import 'google/protobuf/duration.pb.dart' as $1;
import 'tetra3.pbenum.dart';

export 'tetra3.pbenum.dart';

class SolveRequest extends $pb.GeneratedMessage {
  factory SolveRequest({
    $core.Iterable<ImageCoord>? starCentroids,
    $core.int? imageWidth,
    $core.int? imageHeight,
    $core.double? fovEstimate,
    $core.double? fovMaxError,
    $core.double? matchRadius,
    $core.double? matchThreshold,
    $core.Iterable<ImageCoord>? targetPixels,
    $core.double? distortion,
    $core.bool? returnMatches,
    $core.double? matchMaxError,
    $1.Duration? solveTimeout,
    $core.Iterable<CelestialCoord>? targetSkyCoords,
    $core.bool? returnRotationMatrix,
  }) {
    final $result = create();
    if (starCentroids != null) {
      $result.starCentroids.addAll(starCentroids);
    }
    if (imageWidth != null) {
      $result.imageWidth = imageWidth;
    }
    if (imageHeight != null) {
      $result.imageHeight = imageHeight;
    }
    if (fovEstimate != null) {
      $result.fovEstimate = fovEstimate;
    }
    if (fovMaxError != null) {
      $result.fovMaxError = fovMaxError;
    }
    if (matchRadius != null) {
      $result.matchRadius = matchRadius;
    }
    if (matchThreshold != null) {
      $result.matchThreshold = matchThreshold;
    }
    if (targetPixels != null) {
      $result.targetPixels.addAll(targetPixels);
    }
    if (distortion != null) {
      $result.distortion = distortion;
    }
    if (returnMatches != null) {
      $result.returnMatches = returnMatches;
    }
    if (matchMaxError != null) {
      $result.matchMaxError = matchMaxError;
    }
    if (solveTimeout != null) {
      $result.solveTimeout = solveTimeout;
    }
    if (targetSkyCoords != null) {
      $result.targetSkyCoords.addAll(targetSkyCoords);
    }
    if (returnRotationMatrix != null) {
      $result.returnRotationMatrix = returnRotationMatrix;
    }
    return $result;
  }
  SolveRequest._() : super();
  factory SolveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..pc<ImageCoord>(1, _omitFieldNames ? '' : 'starCentroids', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'imageWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'imageHeight', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'fovEstimate', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'fovMaxError', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'matchRadius', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'matchThreshold', $pb.PbFieldType.OD)
    ..pc<ImageCoord>(9, _omitFieldNames ? '' : 'targetPixels', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'distortion', $pb.PbFieldType.OD)
    ..aOB(11, _omitFieldNames ? '' : 'returnMatches')
    ..a<$core.double>(12, _omitFieldNames ? '' : 'matchMaxError', $pb.PbFieldType.OD)
    ..aOM<$1.Duration>(13, _omitFieldNames ? '' : 'solveTimeout', subBuilder: $1.Duration.create)
    ..pc<CelestialCoord>(14, _omitFieldNames ? '' : 'targetSkyCoords', $pb.PbFieldType.PM, subBuilder: CelestialCoord.create)
    ..aOB(15, _omitFieldNames ? '' : 'returnRotationMatrix')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolveRequest clone() => SolveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolveRequest copyWith(void Function(SolveRequest) updates) => super.copyWith((message) => updates(message as SolveRequest)) as SolveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolveRequest create() => SolveRequest._();
  SolveRequest createEmptyInstance() => create();
  static $pb.PbList<SolveRequest> createRepeated() => $pb.PbList<SolveRequest>();
  @$core.pragma('dart2js:noInline')
  static SolveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolveRequest>(create);
  static SolveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ImageCoord> get starCentroids => $_getList(0);

  /// The 'size' parameter, in pixels.
  @$pb.TagNumber(2)
  $core.int get imageWidth => $_getIZ(1);
  @$pb.TagNumber(2)
  set imageWidth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasImageWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearImageWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get imageHeight => $_getIZ(2);
  @$pb.TagNumber(3)
  set imageHeight($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImageHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearImageHeight() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get fovEstimate => $_getN(3);
  @$pb.TagNumber(4)
  set fovEstimate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFovEstimate() => $_has(3);
  @$pb.TagNumber(4)
  void clearFovEstimate() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get fovMaxError => $_getN(4);
  @$pb.TagNumber(5)
  set fovMaxError($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFovMaxError() => $_has(4);
  @$pb.TagNumber(5)
  void clearFovMaxError() => clearField(5);

  @$pb.TagNumber(7)
  $core.double get matchRadius => $_getN(5);
  @$pb.TagNumber(7)
  set matchRadius($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasMatchRadius() => $_has(5);
  @$pb.TagNumber(7)
  void clearMatchRadius() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get matchThreshold => $_getN(6);
  @$pb.TagNumber(8)
  set matchThreshold($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasMatchThreshold() => $_has(6);
  @$pb.TagNumber(8)
  void clearMatchThreshold() => clearField(8);

  @$pb.TagNumber(9)
  $core.List<ImageCoord> get targetPixels => $_getList(7);

  @$pb.TagNumber(10)
  $core.double get distortion => $_getN(8);
  @$pb.TagNumber(10)
  set distortion($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(10)
  $core.bool hasDistortion() => $_has(8);
  @$pb.TagNumber(10)
  void clearDistortion() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get returnMatches => $_getBF(9);
  @$pb.TagNumber(11)
  set returnMatches($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasReturnMatches() => $_has(9);
  @$pb.TagNumber(11)
  void clearReturnMatches() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get matchMaxError => $_getN(10);
  @$pb.TagNumber(12)
  set matchMaxError($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasMatchMaxError() => $_has(10);
  @$pb.TagNumber(12)
  void clearMatchMaxError() => clearField(12);

  @$pb.TagNumber(13)
  $1.Duration get solveTimeout => $_getN(11);
  @$pb.TagNumber(13)
  set solveTimeout($1.Duration v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasSolveTimeout() => $_has(11);
  @$pb.TagNumber(13)
  void clearSolveTimeout() => clearField(13);
  @$pb.TagNumber(13)
  $1.Duration ensureSolveTimeout() => $_ensure(11);

  @$pb.TagNumber(14)
  $core.List<CelestialCoord> get targetSkyCoords => $_getList(12);

  @$pb.TagNumber(15)
  $core.bool get returnRotationMatrix => $_getBF(13);
  @$pb.TagNumber(15)
  set returnRotationMatrix($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasReturnRotationMatrix() => $_has(13);
  @$pb.TagNumber(15)
  void clearReturnRotationMatrix() => clearField(15);
}

class SolveResult extends $pb.GeneratedMessage {
  factory SolveResult({
    CelestialCoord? imageCenterCoords,
    $core.double? roll,
    $core.double? fov,
    $core.double? distortion,
    $core.double? rmse,
    $core.int? matches,
    $core.double? prob,
    $core.double? epochEquinox,
    $core.double? epochProperMotion,
    $1.Duration? solveTime,
    $core.double? cacheHitFraction,
    $core.Iterable<CelestialCoord>? targetCoords,
    $core.Iterable<MatchedStar>? matchedStars,
    SolveStatus? status,
    $core.Iterable<ImageCoord>? targetSkyToImageCoords,
    $core.Iterable<ImageCoord>? patternCentroids,
    RotationMatrix? rotationMatrix,
    $core.double? p90e,
    $core.double? maxe,
  }) {
    final $result = create();
    if (imageCenterCoords != null) {
      $result.imageCenterCoords = imageCenterCoords;
    }
    if (roll != null) {
      $result.roll = roll;
    }
    if (fov != null) {
      $result.fov = fov;
    }
    if (distortion != null) {
      $result.distortion = distortion;
    }
    if (rmse != null) {
      $result.rmse = rmse;
    }
    if (matches != null) {
      $result.matches = matches;
    }
    if (prob != null) {
      $result.prob = prob;
    }
    if (epochEquinox != null) {
      $result.epochEquinox = epochEquinox;
    }
    if (epochProperMotion != null) {
      $result.epochProperMotion = epochProperMotion;
    }
    if (solveTime != null) {
      $result.solveTime = solveTime;
    }
    if (cacheHitFraction != null) {
      $result.cacheHitFraction = cacheHitFraction;
    }
    if (targetCoords != null) {
      $result.targetCoords.addAll(targetCoords);
    }
    if (matchedStars != null) {
      $result.matchedStars.addAll(matchedStars);
    }
    if (status != null) {
      $result.status = status;
    }
    if (targetSkyToImageCoords != null) {
      $result.targetSkyToImageCoords.addAll(targetSkyToImageCoords);
    }
    if (patternCentroids != null) {
      $result.patternCentroids.addAll(patternCentroids);
    }
    if (rotationMatrix != null) {
      $result.rotationMatrix = rotationMatrix;
    }
    if (p90e != null) {
      $result.p90e = p90e;
    }
    if (maxe != null) {
      $result.maxe = maxe;
    }
    return $result;
  }
  SolveResult._() : super();
  factory SolveResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolveResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolveResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..aOM<CelestialCoord>(1, _omitFieldNames ? '' : 'imageCenterCoords', subBuilder: CelestialCoord.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'roll', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'fov', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'distortion', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'rmse', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'matches', $pb.PbFieldType.O3)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'prob', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'epochEquinox', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'epochProperMotion', $pb.PbFieldType.OD)
    ..aOM<$1.Duration>(10, _omitFieldNames ? '' : 'solveTime', subBuilder: $1.Duration.create)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'cacheHitFraction', $pb.PbFieldType.OD)
    ..pc<CelestialCoord>(12, _omitFieldNames ? '' : 'targetCoords', $pb.PbFieldType.PM, subBuilder: CelestialCoord.create)
    ..pc<MatchedStar>(13, _omitFieldNames ? '' : 'matchedStars', $pb.PbFieldType.PM, subBuilder: MatchedStar.create)
    ..e<SolveStatus>(14, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: SolveStatus.UNSPECIFIED, valueOf: SolveStatus.valueOf, enumValues: SolveStatus.values)
    ..pc<ImageCoord>(15, _omitFieldNames ? '' : 'targetSkyToImageCoords', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..pc<ImageCoord>(16, _omitFieldNames ? '' : 'patternCentroids', $pb.PbFieldType.PM, subBuilder: ImageCoord.create)
    ..aOM<RotationMatrix>(17, _omitFieldNames ? '' : 'rotationMatrix', subBuilder: RotationMatrix.create)
    ..a<$core.double>(18, _omitFieldNames ? '' : 'p90e', $pb.PbFieldType.OD)
    ..a<$core.double>(19, _omitFieldNames ? '' : 'maxe', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolveResult clone() => SolveResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolveResult copyWith(void Function(SolveResult) updates) => super.copyWith((message) => updates(message as SolveResult)) as SolveResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolveResult create() => SolveResult._();
  SolveResult createEmptyInstance() => create();
  static $pb.PbList<SolveResult> createRepeated() => $pb.PbList<SolveResult>();
  @$core.pragma('dart2js:noInline')
  static SolveResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolveResult>(create);
  static SolveResult? _defaultInstance;

  @$pb.TagNumber(1)
  CelestialCoord get imageCenterCoords => $_getN(0);
  @$pb.TagNumber(1)
  set imageCenterCoords(CelestialCoord v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasImageCenterCoords() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageCenterCoords() => clearField(1);
  @$pb.TagNumber(1)
  CelestialCoord ensureImageCenterCoords() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get roll => $_getN(1);
  @$pb.TagNumber(2)
  set roll($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoll() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoll() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get fov => $_getN(2);
  @$pb.TagNumber(3)
  set fov($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFov() => $_has(2);
  @$pb.TagNumber(3)
  void clearFov() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get distortion => $_getN(3);
  @$pb.TagNumber(4)
  set distortion($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDistortion() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistortion() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get rmse => $_getN(4);
  @$pb.TagNumber(5)
  set rmse($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRmse() => $_has(4);
  @$pb.TagNumber(5)
  void clearRmse() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get matches => $_getIZ(5);
  @$pb.TagNumber(6)
  set matches($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMatches() => $_has(5);
  @$pb.TagNumber(6)
  void clearMatches() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get prob => $_getN(6);
  @$pb.TagNumber(7)
  set prob($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasProb() => $_has(6);
  @$pb.TagNumber(7)
  void clearProb() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get epochEquinox => $_getN(7);
  @$pb.TagNumber(8)
  set epochEquinox($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasEpochEquinox() => $_has(7);
  @$pb.TagNumber(8)
  void clearEpochEquinox() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get epochProperMotion => $_getN(8);
  @$pb.TagNumber(9)
  set epochProperMotion($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEpochProperMotion() => $_has(8);
  @$pb.TagNumber(9)
  void clearEpochProperMotion() => clearField(9);

  @$pb.TagNumber(10)
  $1.Duration get solveTime => $_getN(9);
  @$pb.TagNumber(10)
  set solveTime($1.Duration v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSolveTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearSolveTime() => clearField(10);
  @$pb.TagNumber(10)
  $1.Duration ensureSolveTime() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.double get cacheHitFraction => $_getN(10);
  @$pb.TagNumber(11)
  set cacheHitFraction($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCacheHitFraction() => $_has(10);
  @$pb.TagNumber(11)
  void clearCacheHitFraction() => clearField(11);

  /// Celestial coordinates of SolveRequest.target_pixels.
  @$pb.TagNumber(12)
  $core.List<CelestialCoord> get targetCoords => $_getList(11);

  @$pb.TagNumber(13)
  $core.List<MatchedStar> get matchedStars => $_getList(12);

  /// If SolveFromCentroids() fails, all of the SolveResult fields will be
  /// omitted except for 'solve_time' and 'status', and the reason for the
  /// failure will be given here.
  @$pb.TagNumber(14)
  SolveStatus get status => $_getN(13);
  @$pb.TagNumber(14)
  set status(SolveStatus v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasStatus() => $_has(13);
  @$pb.TagNumber(14)
  void clearStatus() => clearField(14);

  /// Image coordinates of SolveRequest.target_sky_coords. If a request's
  /// target_sky_coords entry is outside of the FOV, the corresponding
  /// entry here will be (-1,-1).
  @$pb.TagNumber(15)
  $core.List<ImageCoord> get targetSkyToImageCoords => $_getList(14);

  @$pb.TagNumber(16)
  $core.List<ImageCoord> get patternCentroids => $_getList(15);

  @$pb.TagNumber(17)
  RotationMatrix get rotationMatrix => $_getN(16);
  @$pb.TagNumber(17)
  set rotationMatrix(RotationMatrix v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasRotationMatrix() => $_has(16);
  @$pb.TagNumber(17)
  void clearRotationMatrix() => clearField(17);
  @$pb.TagNumber(17)
  RotationMatrix ensureRotationMatrix() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.double get p90e => $_getN(17);
  @$pb.TagNumber(18)
  set p90e($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasP90e() => $_has(17);
  @$pb.TagNumber(18)
  void clearP90e() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get maxe => $_getN(18);
  @$pb.TagNumber(19)
  set maxe($core.double v) { $_setDouble(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasMaxe() => $_has(18);
  @$pb.TagNumber(19)
  void clearMaxe() => clearField(19);
}

/// A location in full resolution image coordinates. (0.5, 0.5) corresponds to
/// the center of the image's upper left pixel.
class ImageCoord extends $pb.GeneratedMessage {
  factory ImageCoord({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  ImageCoord._() : super();
  factory ImageCoord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageCoord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageCoord', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageCoord clone() => ImageCoord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageCoord copyWith(void Function(ImageCoord) updates) => super.copyWith((message) => updates(message as ImageCoord)) as ImageCoord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageCoord create() => ImageCoord._();
  ImageCoord createEmptyInstance() => create();
  static $pb.PbList<ImageCoord> createRepeated() => $pb.PbList<ImageCoord>();
  @$core.pragma('dart2js:noInline')
  static ImageCoord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageCoord>(create);
  static ImageCoord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class CelestialCoord extends $pb.GeneratedMessage {
  factory CelestialCoord({
    $core.double? ra,
    $core.double? dec,
  }) {
    final $result = create();
    if (ra != null) {
      $result.ra = ra;
    }
    if (dec != null) {
      $result.dec = dec;
    }
    return $result;
  }
  CelestialCoord._() : super();
  factory CelestialCoord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CelestialCoord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CelestialCoord', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ra', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dec', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CelestialCoord clone() => CelestialCoord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CelestialCoord copyWith(void Function(CelestialCoord) updates) => super.copyWith((message) => updates(message as CelestialCoord)) as CelestialCoord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CelestialCoord create() => CelestialCoord._();
  CelestialCoord createEmptyInstance() => create();
  static $pb.PbList<CelestialCoord> createRepeated() => $pb.PbList<CelestialCoord>();
  @$core.pragma('dart2js:noInline')
  static CelestialCoord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CelestialCoord>(create);
  static CelestialCoord? _defaultInstance;

  /// Float isn't quite enough precision if we want to go down to arcsec
  /// precision.
  @$pb.TagNumber(1)
  $core.double get ra => $_getN(0);
  @$pb.TagNumber(1)
  set ra($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRa() => $_has(0);
  @$pb.TagNumber(1)
  void clearRa() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get dec => $_getN(1);
  @$pb.TagNumber(2)
  set dec($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDec() => $_has(1);
  @$pb.TagNumber(2)
  void clearDec() => clearField(2);
}

class MatchedStar extends $pb.GeneratedMessage {
  factory MatchedStar({
    CelestialCoord? celestialCoord,
    $core.double? magnitude,
    ImageCoord? imageCoord,
    $core.String? catId,
  }) {
    final $result = create();
    if (celestialCoord != null) {
      $result.celestialCoord = celestialCoord;
    }
    if (magnitude != null) {
      $result.magnitude = magnitude;
    }
    if (imageCoord != null) {
      $result.imageCoord = imageCoord;
    }
    if (catId != null) {
      $result.catId = catId;
    }
    return $result;
  }
  MatchedStar._() : super();
  factory MatchedStar.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MatchedStar.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MatchedStar', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..aOM<CelestialCoord>(1, _omitFieldNames ? '' : 'celestialCoord', subBuilder: CelestialCoord.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'magnitude', $pb.PbFieldType.OD)
    ..aOM<ImageCoord>(3, _omitFieldNames ? '' : 'imageCoord', subBuilder: ImageCoord.create)
    ..aOS(4, _omitFieldNames ? '' : 'catId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MatchedStar clone() => MatchedStar()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MatchedStar copyWith(void Function(MatchedStar) updates) => super.copyWith((message) => updates(message as MatchedStar)) as MatchedStar;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchedStar create() => MatchedStar._();
  MatchedStar createEmptyInstance() => create();
  static $pb.PbList<MatchedStar> createRepeated() => $pb.PbList<MatchedStar>();
  @$core.pragma('dart2js:noInline')
  static MatchedStar getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MatchedStar>(create);
  static MatchedStar? _defaultInstance;

  @$pb.TagNumber(1)
  CelestialCoord get celestialCoord => $_getN(0);
  @$pb.TagNumber(1)
  set celestialCoord(CelestialCoord v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCelestialCoord() => $_has(0);
  @$pb.TagNumber(1)
  void clearCelestialCoord() => clearField(1);
  @$pb.TagNumber(1)
  CelestialCoord ensureCelestialCoord() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get magnitude => $_getN(1);
  @$pb.TagNumber(2)
  set magnitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMagnitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearMagnitude() => clearField(2);

  @$pb.TagNumber(3)
  ImageCoord get imageCoord => $_getN(2);
  @$pb.TagNumber(3)
  set imageCoord(ImageCoord v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasImageCoord() => $_has(2);
  @$pb.TagNumber(3)
  void clearImageCoord() => clearField(3);
  @$pb.TagNumber(3)
  ImageCoord ensureImageCoord() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get catId => $_getSZ(3);
  @$pb.TagNumber(4)
  set catId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCatId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCatId() => clearField(4);
}

class RotationMatrix extends $pb.GeneratedMessage {
  factory RotationMatrix({
    $core.Iterable<$core.double>? matrixElements,
  }) {
    final $result = create();
    if (matrixElements != null) {
      $result.matrixElements.addAll(matrixElements);
    }
    return $result;
  }
  RotationMatrix._() : super();
  factory RotationMatrix.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RotationMatrix.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RotationMatrix', package: const $pb.PackageName(_omitMessageNames ? '' : 'tetra3_server'), createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'matrixElements', $pb.PbFieldType.KD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RotationMatrix clone() => RotationMatrix()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RotationMatrix copyWith(void Function(RotationMatrix) updates) => super.copyWith((message) => updates(message as RotationMatrix)) as RotationMatrix;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RotationMatrix create() => RotationMatrix._();
  RotationMatrix createEmptyInstance() => create();
  static $pb.PbList<RotationMatrix> createRepeated() => $pb.PbList<RotationMatrix>();
  @$core.pragma('dart2js:noInline')
  static RotationMatrix getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RotationMatrix>(create);
  static RotationMatrix? _defaultInstance;

  /// 3x3 matrix in row-major order.
  @$pb.TagNumber(1)
  $core.List<$core.double> get matrixElements => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
