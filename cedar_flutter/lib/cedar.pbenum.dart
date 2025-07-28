//
//  Generated code. Do not modify.
//  source: cedar.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class FeatureLevel extends $pb.ProtobufEnum {
  static const FeatureLevel FEATURE_LEVEL_UNSPECIFIED = FeatureLevel._(0, _omitEnumNames ? '' : 'FEATURE_LEVEL_UNSPECIFIED');
  static const FeatureLevel DIY = FeatureLevel._(1, _omitEnumNames ? '' : 'DIY');
  static const FeatureLevel BASIC = FeatureLevel._(2, _omitEnumNames ? '' : 'BASIC');
  static const FeatureLevel PLUS = FeatureLevel._(3, _omitEnumNames ? '' : 'PLUS');

  static const $core.List<FeatureLevel> values = <FeatureLevel> [
    FEATURE_LEVEL_UNSPECIFIED,
    DIY,
    BASIC,
    PLUS,
  ];

  static final $core.Map<$core.int, FeatureLevel> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeatureLevel? valueOf($core.int value) => _byValue[value];

  const FeatureLevel._(super.v, super.n);
}

class OperatingMode extends $pb.ProtobufEnum {
  static const OperatingMode MODE_UNSPECIFIED = OperatingMode._(0, _omitEnumNames ? '' : 'MODE_UNSPECIFIED');
  /// Mode supporting establishment of camera focus and boresight alignment of
  /// camera and telescope. Auto-exposure behavior is refined by submodes
  /// daylight_mode and focus_assist_mode:
  /// * Neither in effect: exposure is metered for star detection and plate
  ///   solving.
  /// * daylight_mode: exposure is metered in conventional photographic fashion.
  /// * focus_assist_mode: Exposure metered based on brightest point in image.
  static const OperatingMode SETUP = OperatingMode._(1, _omitEnumNames ? '' : 'SETUP');
  /// Main operating mode. Continually updated RA/DEC sent to SkySafari.
  /// Detection of tracking mount and accumulation of polar alignment advice
  /// during dwells.
  /// * Exposure metered based on number of detected stars.
  /// * Plate solves done using FOV and distortion estimate obtained when
  ///   leaving SETUP mode.
  static const OperatingMode OPERATE = OperatingMode._(2, _omitEnumNames ? '' : 'OPERATE');

  static const $core.List<OperatingMode> values = <OperatingMode> [
    MODE_UNSPECIFIED,
    SETUP,
    OPERATE,
  ];

  static final $core.Map<$core.int, OperatingMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OperatingMode? valueOf($core.int value) => _byValue[value];

  const OperatingMode._(super.v, super.n);
}

class CelestialCoordFormat extends $pb.ProtobufEnum {
  static const CelestialCoordFormat FORMAT_UNSPECIFIED = CelestialCoordFormat._(0, _omitEnumNames ? '' : 'FORMAT_UNSPECIFIED');
  /// Both right ascension and declination should be formatted as
  /// decimal. Right ascension from 0..360, declination from -90..90.
  /// Example:
  /// RA  = 182.3345 degrees
  /// DEC = 34.2351 degrees
  static const CelestialCoordFormat DECIMAL = CelestialCoordFormat._(1, _omitEnumNames ? '' : 'DECIMAL');
  /// Right ascension should be formatted as hours/minutes/seconds;
  /// declination as degrees/minutes/seconds. The example values given
  /// above would be:
  /// RA  = 12h 9m 20.28s
  /// DEC = 34d 14m 6.36s
  static const CelestialCoordFormat HMS_DMS = CelestialCoordFormat._(2, _omitEnumNames ? '' : 'HMS_DMS');

  static const $core.List<CelestialCoordFormat> values = <CelestialCoordFormat> [
    FORMAT_UNSPECIFIED,
    DECIMAL,
    HMS_DMS,
  ];

  static final $core.Map<$core.int, CelestialCoordFormat> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CelestialCoordFormat? valueOf($core.int value) => _byValue[value];

  const CelestialCoordFormat._(super.v, super.n);
}

class CelestialCoordChoice extends $pb.ProtobufEnum {
  static const CelestialCoordChoice CHOICE_UNSPECIFIED = CelestialCoordChoice._(0, _omitEnumNames ? '' : 'CHOICE_UNSPECIFIED');
  /// RA/Dec.
  static const CelestialCoordChoice RA_DEC = CelestialCoordChoice._(1, _omitEnumNames ? '' : 'RA_DEC');
  /// Alt/Az and also hour angle.
  static const CelestialCoordChoice ALT_AZ_HA = CelestialCoordChoice._(2, _omitEnumNames ? '' : 'ALT_AZ_HA');

  static const $core.List<CelestialCoordChoice> values = <CelestialCoordChoice> [
    CHOICE_UNSPECIFIED,
    RA_DEC,
    ALT_AZ_HA,
  ];

  static final $core.Map<$core.int, CelestialCoordChoice> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CelestialCoordChoice? valueOf($core.int value) => _byValue[value];

  const CelestialCoordChoice._(super.v, super.n);
}

class MountType extends $pb.ProtobufEnum {
  static const MountType MOUNT_UNSPECIFIED = MountType._(0, _omitEnumNames ? '' : 'MOUNT_UNSPECIFIED');
  static const MountType EQUATORIAL = MountType._(1, _omitEnumNames ? '' : 'EQUATORIAL');
  static const MountType ALT_AZ = MountType._(2, _omitEnumNames ? '' : 'ALT_AZ');

  static const $core.List<MountType> values = <MountType> [
    MOUNT_UNSPECIFIED,
    EQUATORIAL,
    ALT_AZ,
  ];

  static final $core.Map<$core.int, MountType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MountType? valueOf($core.int value) => _byValue[value];

  const MountType._(super.v, super.n);
}

/// The orientation of the client's display.
class DisplayOrientation extends $pb.ProtobufEnum {
  static const DisplayOrientation ORIENTATION_UNSPECIFIED = DisplayOrientation._(0, _omitEnumNames ? '' : 'ORIENTATION_UNSPECIFIED');
  static const DisplayOrientation LANDSCAPE = DisplayOrientation._(1, _omitEnumNames ? '' : 'LANDSCAPE');
  static const DisplayOrientation PORTRAIT = DisplayOrientation._(2, _omitEnumNames ? '' : 'PORTRAIT');

  static const $core.List<DisplayOrientation> values = <DisplayOrientation> [
    ORIENTATION_UNSPECIFIED,
    LANDSCAPE,
    PORTRAIT,
  ];

  static final $core.Map<$core.int, DisplayOrientation> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DisplayOrientation? valueOf($core.int value) => _byValue[value];

  const DisplayOrientation._(super.v, super.n);
}

class CalibrationFailureReason extends $pb.ProtobufEnum {
  static const CalibrationFailureReason REASON_UNSPECIFIED = CalibrationFailureReason._(0, _omitEnumNames ? '' : 'REASON_UNSPECIFIED');
  /// Exposure calibration failed to find stars at maximum exposure duration.
  /// Likely causes: lens cover is closed; dark clouds.
  static const CalibrationFailureReason TOO_FEW_STARS = CalibrationFailureReason._(1, _omitEnumNames ? '' : 'TOO_FEW_STARS');
  /// Exposure calibration reached its mean scene brightness limit before
  /// detecting the desired number of stars. Likely causes: not pointed at sky;
  /// bright clouds; twilight too bright; extreme light pollution.
  static const CalibrationFailureReason BRIGHT_SKY = CalibrationFailureReason._(2, _omitEnumNames ? '' : 'BRIGHT_SKY');
  /// Cedar Solve could not find a solution. If exposure calibration succeeds
  /// a solver failure is unusual.
  static const CalibrationFailureReason SOLVER_FAILED = CalibrationFailureReason._(3, _omitEnumNames ? '' : 'SOLVER_FAILED');

  static const $core.List<CalibrationFailureReason> values = <CalibrationFailureReason> [
    REASON_UNSPECIFIED,
    TOO_FEW_STARS,
    BRIGHT_SKY,
    SOLVER_FAILED,
  ];

  static final $core.Map<$core.int, CalibrationFailureReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CalibrationFailureReason? valueOf($core.int value) => _byValue[value];

  const CalibrationFailureReason._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
