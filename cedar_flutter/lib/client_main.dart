// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/cedar.pb.dart';
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/controls_widget.dart';
import 'package:cedar_flutter/draw_slew_target.dart';
import 'package:cedar_flutter/drawer.dart';
import 'package:cedar_flutter/google/protobuf/timestamp.pb.dart';
import 'package:cedar_flutter/interstitial_msg.dart';
import 'package:cedar_flutter/perf_gauge.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:cedar_flutter/sky_coords_dialog.dart';
import 'package:cedar_flutter/slew_directions.dart';
import 'package:cedar_flutter/themes.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as dart_widgets;
import 'package:grpc/grpc.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'platform.dart';

// To generate release build:
// flutter build web --no-web-resources-cdn
// flutter build apk --release

typedef DrawCatalogEntriesFunction = void Function(BuildContext, Canvas, Color,
    List<cedar_rpc.FovCatalogEntry>, bool, int, bool);

typedef ShowCatalogBrowserFunction = void Function(
    BuildContext, MyHomePageState);

typedef ObjectInfoDialogFunction = void Function(
    MyHomePageState, BuildContext, SelectedCatalogEntry);

typedef WifiAccessPointDialogFunction = void Function(
    MyHomePageState, BuildContext);

/// Controller class for WiFi client dialog functionality
class WifiClientDialogController {
  final void Function(bool, MyHomePageState, BuildContext) showDialog;
  final void Function() hideTemporarily;
  final void Function(BuildContext) showAfterHiding;

  WifiClientDialogController({
    required this.showDialog,
    required this.hideTemporarily,
    required this.showAfterHiding,
  });
}

typedef WifiClientDialogFunction = void Function(
    bool, MyHomePageState, BuildContext);

typedef UpdateServerSoftwareDialogFunction = void Function(
    MyHomePageState, BuildContext);

typedef RestartCedarServerFunction = Future<void> Function();

DrawCatalogEntriesFunction? _drawCatalogEntries;
ShowCatalogBrowserFunction? _showCatalogBrowser;
ObjectInfoDialogFunction? _objectInfoDialog;
WifiAccessPointDialogFunction? _wifiAccessPointDialog;
WifiClientDialogController? _wifiClientDialogController;
UpdateServerSoftwareDialogFunction? _updateServerSoftwareDialogFunction;
RestartCedarServerFunction? _restartCedarServerFunction;

void clientMain(
    DrawCatalogEntriesFunction? drawCatalogEntries,
    ShowCatalogBrowserFunction? showCatalogBrowser,
    ObjectInfoDialogFunction? objectInfoDialog,
    WifiAccessPointDialogFunction? wifiAccessPointDialog,
    WifiClientDialogController? wifiClientDialogController,
    UpdateServerSoftwareDialogFunction? updateServerSoftwareDialogFunction,
    RestartCedarServerFunction? restartCedarServerFunction) {
  _drawCatalogEntries = drawCatalogEntries;
  _showCatalogBrowser = showCatalogBrowser;
  _objectInfoDialog = objectInfoDialog;
  _wifiAccessPointDialog = wifiAccessPointDialog;
  _wifiClientDialogController = wifiClientDialogController;
  _updateServerSoftwareDialogFunction = updateServerSoftwareDialogFunction;
  _restartCedarServerFunction = restartCedarServerFunction;

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SettingsModel()),
      ChangeNotifierProvider(create: (context) => ThemeModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cedar Aim",
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: const MyHomePage(title: "Cedar Aim"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

double _deg2rad(double deg) {
  return deg / 180.0 * math.pi;
}

class _MainImagePainter extends CustomPainter {
  final MyHomePageState state;
  final BuildContext _context;

  _MainImagePainter(this.state, this._context) {
    PaintingBinding.instance.imageCache.maximumSize = 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    try {
      _paint(canvas, size);
    } finally {
      state._paintPending = false;
    }
  }

  bool _nearInImage(cedar_rpc.ImageCoord p1, cedar_rpc.ImageCoord p2) {
    final distanceSq =
        (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);
    return distanceSq < 4;
  }

  List<cedar_rpc.FovCatalogEntry> _createScaledCatalogEntries(
      List<cedar_rpc.FovCatalogEntry> entries, double displayScale) {
    return entries.map((entry) {
      // Create a new catalog entry with scaled image position
      final scaledEntry = cedar_rpc.FovCatalogEntry();
      scaledEntry.entry = entry.entry; // Copy the catalog entry data
      scaledEntry.imagePos = cedar_rpc.ImageCoord(
        x: entry.imagePos.x * displayScale,
        y: entry.imagePos.y * displayScale,
      );
      return scaledEntry;
    }).toList();
  }

  void _paint(Canvas canvas, Size size) {
    const double thin = 1;
    const double thick = 1.5;
    final Color primaryColor = Theme.of(_context).colorScheme.primary;
    final Color color = state._solveColor();
    final Color opaqueColor =
        Color.fromARGB(128, color.red, color.green, color.blue);

    final displayScale = state._getDisplayScale();

    if (state._setupMode &&
        state._centerPeakRegion != null &&
        state._focusAid &&
        !state._daylightMode) {
      // Draw box around location of the brightest star.
      final scaledRect = Rect.fromLTWH(
        state._centerPeakRegion!.left * displayScale,
        state._centerPeakRegion!.top * displayScale,
        state._centerPeakRegion!.width * displayScale,
        state._centerPeakRegion!.height * displayScale,
      );
      canvas.drawRect(
          scaledRect,
          Paint()
            ..color = primaryColor
            ..strokeWidth = thin
            ..style = PaintingStyle.stroke);
    }

    if (state._setupMode &&
        state._daylightFocusZoomRegion != null &&
        state._focusAid &&
        state._daylightMode) {
      // Draw box around daylight focus zoom region.
      // Adjust coordinates relative to the displayed image region
      final scaledRect = Rect.fromLTWH(
        (state._daylightFocusZoomRegion!.left - state._imageRegion.left) * displayScale,
        (state._daylightFocusZoomRegion!.top - state._imageRegion.top) * displayScale,
        state._daylightFocusZoomRegion!.width * displayScale,
        state._daylightFocusZoomRegion!.height * displayScale,
      );
      canvas.drawRect(
          scaledRect,
          Paint()
            ..color = primaryColor
            ..strokeWidth = thin
            ..style = PaintingStyle.stroke);
    }

    final portrait =
        MediaQuery.of(_context).orientation == Orientation.portrait;

    var labeledCatalogEntries = List<FovCatalogEntry>.empty(growable: true);
    var dimLabeledCatalogEntries = List<FovCatalogEntry>.empty(growable: true);

    if (state._setupMode &&
        !state._focusAid &&
        !state._daylightMode &&
        state._stars.isNotEmpty) {
      // Draw alignment targets: up to N brightest stars (or planets).
      Paint paint = Paint()
        ..color = color
        ..strokeWidth = thick
        ..style = PaintingStyle.stroke;
      int numTargets = 0;
      double brightest = state._stars[0].brightness;
      // We only include stars up to two magnitude fainter.
      double faintLimit = brightest / state._faintLimit;
      var targetCoords = List<cedar_rpc.ImageCoord>.empty(growable: true);
      for (var star in state._stars) {
        if (star.brightness < faintLimit) {
          break;
        }
        if (++numTargets > state._numTargets) {
          break;
        }
        targetCoords.add(star.centroidPosition);
        // Scale the star position and rectangle size
        final scaledCenter = Offset(
          (star.centroidPosition.x / state._binFactor) * displayScale,
          (star.centroidPosition.y / state._binFactor) * displayScale,
        );
        final scaledSize = 16 * displayScale;
        canvas.drawRect(
            Rect.fromCenter(
                center: scaledCenter, width: scaledSize, height: scaledSize),
            paint);
      }
      // Partition state._labeledFovCatalogEntries to labeledCatalogEntries or
      // dimLabeledCatalogEntries.
      for (var catEntry in state._labeledFovCatalogEntries) {
        bool isTarget = false;
        for (var tc in targetCoords) {
          if (_nearInImage(catEntry.imagePos, tc)) {
            isTarget = true;
            break;
          }
        }
        if (isTarget) {
          labeledCatalogEntries.add(catEntry);
        } else {
          dimLabeledCatalogEntries.add(catEntry);
        }
      }
    } else {
      labeledCatalogEntries = state._labeledFovCatalogEntries;
    }

    if (state._slewRequest != null && !state._setupMode && state._hasSolution) {
      final slew = state._slewRequest;
      Offset? posInImage;
      if (slew!.hasImagePos()) {
        // Scale the slew position
        posInImage = Offset(
          (slew.imagePos.x / state._binFactor) * displayScale,
          (slew.imagePos.y / state._binFactor) * displayScale,
        );
      }
      // Scale the boresight position and scope FOV
      final scaledBoresightPosition = Offset(
        state._boresightPosition.dx * displayScale,
        state._boresightPosition.dy * displayScale,
      );
      final scaledScopeFov =
          (state._scopeFov / state._rotationSizeRatio) * displayScale;
      drawSlewTarget(
          _context,
          canvas,
          color,
          scaledBoresightPosition,
          scaledScopeFov,
          /*rollAngleRad=*/ _deg2rad(state._bullseyeDirectionIndicator()),
          posInImage,
          slew.targetAngle,
          portrait,
          Size(state._imageRegion.width * displayScale, state._imageRegion.height * displayScale));
    } else if (!state._focusAid &&
        !state._calibrating &&
        !state._transitionToSetup) {
      var rollAngleRad = _deg2rad(state._bullseyeDirectionIndicator());
      final scaledBoresightPosition = Offset(
        state._boresightPosition.dx * displayScale,
        state._boresightPosition.dy * displayScale,
      );
      final scaledScopeFov =
          (state._scopeFov / state._rotationSizeRatio / 2) * displayScale;

      drawBullseye(
          canvas, primaryColor, scaledBoresightPosition, scaledScopeFov, rollAngleRad,
          daylightMode: state._daylightMode);

      if (labeledCatalogEntries.isNotEmpty &&
          state._slewRequest == null &&
          _drawCatalogEntries != null) {
        // Create scaled catalog entries for display
        final scaledLabeledEntries =
            _createScaledCatalogEntries(labeledCatalogEntries, displayScale);
        final scaledDimEntries =
            _createScaledCatalogEntries(dimLabeledCatalogEntries, displayScale);
        final scaledUnlabeledEntries = _createScaledCatalogEntries(
            state._unlabeledFovCatalogEntries, displayScale);

        _drawCatalogEntries!(_context, canvas, color, scaledLabeledEntries,
            /*drawLabel=*/ true, state._binFactor, portrait);
        if (dimLabeledCatalogEntries.isNotEmpty) {
          _drawCatalogEntries!(_context, canvas, opaqueColor, scaledDimEntries,
              /*drawLabel=*/ true, state._binFactor, portrait);
        }
        _drawCatalogEntries!(_context, canvas, color, scaledUnlabeledEntries,
            /*drawLabel=*/ false, state._binFactor, portrait);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _OverlayImagePainter extends CustomPainter {
  final MyHomePageState _state;
  final BuildContext _context;
  final double _scale;
  final int _binFactor;

  _OverlayImagePainter(
      this._state, this._context, this._scale, this._binFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final Color color = Theme.of(_context).colorScheme.primary;
    Offset overlayCenter = Offset(size.width / 2, size.height / 2);

    var slew = _state._slewRequest;
    if (slew == null) return;

    // Note that slew.imagePos is in full resolution units.
    Offset? posInImage;
    if (slew.hasImagePos()) {
      final correctedScale = _scale *
          _state._rotationSizeRatio /
          _state._boresightRotationSizeRatio;
      posInImage = Offset(
          overlayCenter.dx +
              correctedScale *
                  (slew.imagePos.x - _state._fullResBoresightPosition.dx),
          overlayCenter.dy +
              correctedScale *
                  (slew.imagePos.y - _state._fullResBoresightPosition.dy));
    }
    // How many display pixels is the telescope FOV?
    final scopeFov = _scale * _binFactor * _state._scopeFov;
    final portrait =
        MediaQuery.of(_context).orientation == Orientation.portrait;
    drawSlewTarget(
        _context,
        canvas,
        color,
        overlayCenter,
        scopeFov / _state._boresightRotationSizeRatio,
        /*rollAngleRad=*/ _deg2rad(_state._bullseyeDirectionIndicator()),
        posInImage,
        slew.targetAngle,
        portrait,
        size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePageState extends State<MyHomePage> {
  // Computed properties
  bool get healthy => _serverConnected && (_hasCamera || _demoMode);
  late final SlewDirectionsWidgets _slewDirections;

  MyHomePageState() {
    _slewDirections = SlewDirectionsWidgets(
      northernHemisphere: _northernHemisphere,
      getSolveColor: () => _solveColor(),
    );
    _initLocation();
    _refreshStateFromServer();
  }

  bool _showWelcome = false;
  bool _showedWelcome = false;
  bool _showFocusIntro = false;
  bool _showAlignIntro = false;
  bool _showTooFewStars = false;
  bool _showBrightSky = false;
  bool _showSolverFailed = false;
  bool _showSetupFinished = false;

  bool _dontShowWelcome = false;
  bool _dontShowFocusIntro = false;
  bool _dontShowAlignIntro = false;
  bool _dontShowTooFewStars = false;
  bool _dontShowBrightSky = false;
  bool _dontShowSolverFailed = false;
  bool _dontShowSetupFinished = false;

  // Whether we should offer a menu item to set the observer location via a map.
  bool _offerMap = false;

  // Geolocation from map.
  LatLng? _mapPosition;
  bool _northernHemisphere = true;

  Duration _tzOffset = const Duration();
  bool _hasCamera = false;
  int _cameraWidth = 0;
  bool isDIY = false;
  bool isBasic = false;
  bool isPlus = false;
  bool _paintPending = false;
  bool _inhibitRefresh = false;

  final DateTime _startTime = DateTime.now();
  bool _serverConnected = false;
  bool everConnected = false;
  DateTime _lastServerResponseTime = DateTime.now();

  // State for align mode.
  final _numTargets = 3;
  final _faintLimit = 2.512 * 2.512; // Two magnitudes.
  bool _alignTargetTapped = false;
  bool _wantAlignFeedback = false;

  // Information from most recent FrameResult.

  // Image data, binned by server.
  Uint8List _imageBytes = Uint8List(1);
  late Rect _imageRegion; // Scaled by _binFactor.
  int _binFactor = 1;
  double _rotationSizeRatio = 1.0; // Always >= 1.0.
  double _boresightRotationSizeRatio = 1.0; // Always >= 1.0.

  cedar_rpc.ServerInformation? serverInformation;
  var fixedSettings = cedar_rpc.FixedSettings();
  var operationSettings = cedar_rpc.OperationSettings();
  bool _setupMode = false;
  bool _focusAid = false;
  bool _daylightMode = false;
  bool _demoMode = false;
  List<String> _demoFiles = [];
  String _demoFile = "";
  bool advanced = false;
  bool _systemMenuExpanded = false;
  bool _rightHanded = true;
  bool _canAlign = false;
  bool _hasWifiControl = false;
  bool updateInProgress = false;
  bool shutdownInProgress = false;

  // Telescope eyepiece field of view (diameter), in scaled image pixels.
  double _scopeFov = 0.0;

  Offset _boresightPosition =
      const Offset(0, 0); // Scaled by main image's binning.
  Offset _fullResBoresightPosition = const Offset(0, 0);

  Rect? _centerPeakRegion; // Scaled by binning.
  Rect? _daylightFocusZoomRegion; // Scaled by binning.

  int _centerPeakWidth = 0;
  int _centerPeakHeight = 0;
  Uint8List? _centerPeakImageBytes;

  int _boresightImageHeight = 0; // Full resolution units.
  Uint8List? _boresightImageBytes;

  Uint8List? _daylightFocusZoomImageBytes;

  int _prevFrameId = -1;
  late List<cedar_rpc.StarCentroid> _stars;
  int numStars = 0;
  var exposureTimeMs = 0.0;
  bool _hasSolution = false;
  double noiseEstimate = 0.0;

  List<Offset>? _solutionCentroids;
  // Degrees.
  double solutionRA = 0.0;
  double solutionDec = 0.0;
  double _solutionRollAngle = 0.0; // Degrees.
  double _solutionFOV = 0.0; // Degrees.

  // Arcsec.
  double solutionRMSE = 0.0;

  cedar_rpc.LocationBasedInfo? locationBasedInfo;

  cedar_rpc.CalibrationData? calibrationData;
  cedar_rpc.ProcessingStats? processingStats;
  cedar_rpc.SlewRequest? _slewRequest;
  cedar_rpc.Preferences? preferences;
  cedar_rpc.PolarAlignAdvice? _polarAlignAdvice;
  List<cedar_rpc.FovCatalogEntry> _labeledFovCatalogEntries = List.empty();
  List<cedar_rpc.FovCatalogEntry> _unlabeledFovCatalogEntries = List.empty();

  // Calibration happens when _setupMode transitions to false.
  bool _calibrating = false;
  double _calibrationProgress = 0.0;

  // Transition from Operate mode back to Setup mode can take a second or
  // so if the update rate setting is e.g. 1 Hz. We put up a pacifier for this;
  // define a flag so we can know when it is done.
  bool _transitionToSetup = false;

  Future<void> _initLocation() async {
    _offerMap = isWeb() || !await canGetLocation();
    _tzOffset = DateTime.now().timeZoneOffset; // Get platform timezone.
    if (await canGetLocation()) {
      // Try to get location from the platform. If we are a web app, served
      // over http (not https), we won't be able to get location here.
      final platformPosition = await getLocation();
      if (platformPosition != null) {
        mapPosition =
            LatLng(platformPosition.latitude, platformPosition.longitude);
      }
    }
  }

  cedar_rpc.CedarClient client() {
    return getClient();
  }

  LatLng? get mapPosition => _mapPosition;
  set mapPosition(LatLng? newPos) {
    setState(() {
      _mapPosition = newPos;
      if (newPos != null) {
        _setObserverLocation(newPos);
      }
    });
  }

  Duration get tzOffset => _tzOffset;

  void setStateFromFrameResult(cedar_rpc.FrameResult response) {
    if (_dontShowWelcome) {
      _showedWelcome = true;
    }
    _showWelcome = !_showedWelcome;
    _prevFrameId = response.frameId;
    _stars = response.starCandidates;
    numStars = response.starCountMovingAverage.round();
    if (response.fixedSettings.hasObserverLocation()) {
      _mapPosition = LatLng(response.fixedSettings.observerLocation.latitude,
          response.fixedSettings.observerLocation.longitude);
      _northernHemisphere = _mapPosition!.latitude > 0.0;
    }
    _hasSolution = false;
    bool prevCalibrating = _calibrating;
    _calibrating = response.calibrating;
    if (response.calibrating) {
      _calibrationProgress = response.calibrationProgress;
    }
    if (response.preferences.nightVisionTheme) {
      Provider.of<ThemeModel>(context, listen: false).setNightVisionTheme();
    } else {
      Provider.of<ThemeModel>(context, listen: false).setNormalTheme();
    }
    serverInformation = response.serverInformation;
    _hasWifiControl =
        serverInformation!.featureLevel != cedar_rpc.FeatureLevel.DIY;
    _hasCamera = serverInformation!.hasCamera();
    if (_hasCamera) {
      _cameraWidth = serverInformation!.camera.imageWidth;
    }
    isDIY = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.DIY;
    isBasic = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.BASIC;
    isPlus = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.PLUS;
    _demoFiles = serverInformation!.demoImageNames;

    fixedSettings = response.fixedSettings;
    operationSettings = response.operationSettings;
    bool prevFocusMode = _setupMode && _focusAid;
    bool prevAlignMode = _setupMode && !_focusAid;
    bool prevSetupMode = _setupMode;
    _setupMode =
        operationSettings.operatingMode == cedar_rpc.OperatingMode.SETUP;
    _focusAid = operationSettings.focusAssistMode;
    bool newFocusMode = _setupMode && _focusAid;
    bool newAlignMode = _setupMode && !_focusAid;
    _daylightMode = operationSettings.daylightMode;
    if (_setupMode) {
      _transitionToSetup = false;
    }
    _demoFile = operationSettings.demoImageFilename;
    _demoMode = _demoFile.isNotEmpty;
    if (_demoFile.isEmpty) {
      _demoFile = _demoFiles[0];
    }

    _canAlign = _setupMode;
    if (preferences == null) {
      // First time seeing the preferences from the server.
      if (response.preferences.hideAppBar) {
        goFullScreen();
      } else {
        cancelFullScreen();
      }
      if (response.preferences.screenAlwaysOn) {
        setWakeLock(true);
      } else {
        setWakeLock(false);
      }
    }
    preferences = response.preferences;
    _polarAlignAdvice = response.polarAlignAdvice;
    _labeledFovCatalogEntries = response.labeledCatalogEntries;
    _unlabeledFovCatalogEntries = response.unlabeledCatalogEntries;
    var settingsModel = Provider.of<SettingsModel>(context, listen: false);
    settingsModel.preferencesProto = preferences!.deepCopy();
    settingsModel.opSettingsProto = operationSettings.deepCopy();
    settingsModel.isDIY = isDIY;
    settingsModel.isBasic = isBasic;
    settingsModel.isPlus = isPlus;
    advanced = preferences!.advanced;
    _rightHanded = preferences!.rightHanded;
    calibrationData =
        response.hasCalibrationData() ? response.calibrationData : null;
    bool tooFewStars = false;
    bool brightSky = false;
    bool solverFail = false;
    if (calibrationData != null) {
      tooFewStars = calibrationData!.calibrationFailureReason ==
          CalibrationFailureReason.TOO_FEW_STARS;
      brightSky = calibrationData!.calibrationFailureReason ==
          CalibrationFailureReason.BRIGHT_SKY;
      solverFail = calibrationData!.calibrationFailureReason ==
          CalibrationFailureReason.SOLVER_FAILED;
    }
    if (prevCalibrating && !_calibrating) {
      if (tooFewStars && !_dontShowTooFewStars) {
        _showTooFewStars = true;
      }
      if (brightSky && !_dontShowBrightSky) {
        _showBrightSky = true;
      }
      if (solverFail && !_dontShowSolverFailed) {
        _showSolverFailed = true;
      }
    }

    processingStats =
        response.hasProcessingStats() ? response.processingStats : null;
    _slewRequest = response.hasSlewRequest() ? response.slewRequest : null;
    if (_slewRequest != null) {
      _canAlign = true;
    }
    if (response.hasImage()) {
      _imageBytes = Uint8List.fromList(response.image.imageData);
      _binFactor = response.image.binningFactor;
      _rotationSizeRatio = response.image.rotationSizeRatio;
      _imageRegion = Rect.fromLTWH(
          response.image.rectangle.originX.toDouble() / _binFactor,
          response.image.rectangle.originY.toDouble() / _binFactor,
          response.image.rectangle.width.toDouble() / _binFactor,
          response.image.rectangle.height.toDouble() / _binFactor);
    }
    if (response.hasPlateSolution()) {
      PlateSolution plateSolution = response.plateSolution;
      _hasSolution = true;
      _solutionCentroids = <Offset>[];
      for (var centroid in plateSolution.patternCentroids) {
        _solutionCentroids!.add(Offset(centroid.x, centroid.y));
      }
      if (plateSolution.targetSkyCoord.isNotEmpty) {
        solutionRA = plateSolution.targetSkyCoord.first.ra;
        solutionDec = plateSolution.targetSkyCoord.first.dec;
      } else {
        solutionRA = plateSolution.imageSkyCoord.ra;
        solutionDec = plateSolution.imageSkyCoord.dec;
      }
      _solutionRollAngle = plateSolution.roll;
      solutionRMSE = plateSolution.rmse;
      _solutionFOV = plateSolution.fov;
      if (response.hasLocationBasedInfo()) {
        locationBasedInfo = response.locationBasedInfo;
      }
      _scopeFov =
          preferences!.eyepieceFov * (_cameraWidth / _binFactor) / _solutionFOV;
    } else if (_scopeFov == 0) {
      // No plate solution yet, so we don't know the image scale. For now,
      // assume the eyepiece FOV is 1/10 the image height.
      _scopeFov = _imageRegion.height / 10;
    }
    noiseEstimate = response.noiseEstimate;
    _boresightPosition = Offset(response.boresightPosition.x / _binFactor,
        response.boresightPosition.y / _binFactor);
    var prevFullResBoresightPosition = _fullResBoresightPosition;
    _fullResBoresightPosition =
        Offset(response.boresightPosition.x, response.boresightPosition.y);
    if (prevFullResBoresightPosition.dx.toInt() !=
            _fullResBoresightPosition.dx.toInt() ||
        prevFullResBoresightPosition.dy.toInt() !=
            _fullResBoresightPosition.dy.toInt()) {
      if (_wantAlignFeedback) {
        HapticFeedback.mediumImpact();
        _wantAlignFeedback = false;
      }
    }
    if (response.hasExposureTime()) {
      exposureTimeMs = durationToMs(response.exposureTime).toDouble();
    }
    _centerPeakImageBytes = null;
    if (response.hasCenterPeakImage()) {
      _centerPeakImageBytes =
          Uint8List.fromList(response.centerPeakImage.imageData);
      _centerPeakWidth = response.centerPeakImage.rectangle.width;
      _centerPeakHeight = response.centerPeakImage.rectangle.height;
    }
    _boresightImageBytes = null;
    if (response.hasBoresightImage()) {
      _boresightImageBytes =
          Uint8List.fromList(response.boresightImage.imageData);
      _boresightImageHeight = response.boresightImage.rectangle.height;
      _boresightRotationSizeRatio = response.boresightImage.rotationSizeRatio;
    }
    _daylightFocusZoomImageBytes = null;
    _daylightFocusZoomRegion = null;
    if (response.hasDaylightFocusZoomImage()) {
      _daylightFocusZoomImageBytes =
          Uint8List.fromList(response.daylightFocusZoomImage.imageData);

      // The rectangle gives us the region in full resolution coordinates.
      _daylightFocusZoomRegion = Rect.fromLTWH(
          response.daylightFocusZoomImage.rectangle.originX.toDouble() / _binFactor,
          response.daylightFocusZoomImage.rectangle.originY.toDouble() / _binFactor,
          response.daylightFocusZoomImage.rectangle.width.toDouble() / _binFactor,
          response.daylightFocusZoomImage.rectangle.height.toDouble() / _binFactor);
    }
    if (response.hasCenterPeakPosition()) {
      var cp = response.centerPeakPosition;
      _centerPeakRegion = Rect.fromCenter(
          center: Offset(cp.x / _binFactor, cp.y / _binFactor),
          width: _centerPeakWidth.toDouble() / _binFactor,
          height: _centerPeakHeight.toDouble() / _binFactor);
    }
    if (preferences != null) {
      final dontShowItems = preferences!.dontShowItems;
      _dontShowWelcome = dontShowItems.contains('welcome');
      _dontShowFocusIntro = dontShowItems.contains('focus_intro');
      _dontShowAlignIntro = dontShowItems.contains('align_intro');
      _dontShowTooFewStars = dontShowItems.contains('too_few_stars');
      _dontShowBrightSky = dontShowItems.contains('bright_sky');
      _dontShowSolverFailed = dontShowItems.contains('solver_failed');
      _dontShowSetupFinished = dontShowItems.contains('setup_finished');
    }
    if (newFocusMode && !prevFocusMode) {
      _showFocusIntro = !_dontShowFocusIntro;
    }
    if (newAlignMode && !prevAlignMode) {
      _showAlignIntro = !_dontShowAlignIntro;
    }
    if (!_setupMode && prevSetupMode) {
      _showSetupFinished = !_dontShowSetupFinished;
    }
  }

  double _bullseyeDirectionIndicator() {
    if (preferences?.mountType == cedar_rpc.MountType.ALT_AZ &&
        locationBasedInfo != null) {
      return locationBasedInfo!.zenithRollAngle;
    } else {
      return _solutionRollAngle; // Direction towards north.
    }
  }

  Future<void> _updateFixedSettings(cedar_rpc.FixedSettings request) async {
    try {
      await client().updateFixedSettings(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint("updateFixedSettings error: $e");
    }
  }

  Future<void> updateOperationSettings(
      cedar_rpc.OperationSettings request) async {
    try {
      await client().updateOperationSettings(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint("updateOperationSettings error: $e");
    }
  }

  // Use request/response style of RPC.
  Future<void> _getFrameFromServer() async {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final request = cedar_rpc.FrameRequest()
      ..prevFrameId = _prevFrameId
      ..nonBlocking = true
      ..displayOrientation = landscape
          ? DisplayOrientation.LANDSCAPE
          : DisplayOrientation.PORTRAIT;
    try {
      final response = await client().getFrame(
        request,
        options: CallOptions(timeout: const Duration(seconds: 4)),
      );
      rpcSucceeded();
      if (!_serverConnected) {
        // Connecting for first time, or reconnecting. Send our time and
        // location.
        _setServerTime(DateTime.now());
        if (_mapPosition != null) {
          _setObserverLocation(_mapPosition!);
        }
      }
      _serverConnected = true;
      everConnected = true;
      _lastServerResponseTime = DateTime.now();
      if (response.hasResult) {
        if (_inhibitRefresh) {
          _prevFrameId = response.frameId;
        } else {
          _paintPending = true; // TODO: can we drop this?
          setState(() {
            setStateFromFrameResult(response);
          });
        }
      }
    } catch (e) {
      debugPrint("getFrame RPC error: $e");
      rpcFailed(); // Make a new channel.
      setState(() {
        // Has it been too long since we last succeeded?
        Duration elapsed = DateTime.now().difference(_lastServerResponseTime);
        if (elapsed.inSeconds > 10) {
          _serverConnected = false;
        }
      });
    }
  }

  // Issue repeated request/response RPCs.
  Future<void> _refreshStateFromServer() async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!_paintPending && !updateInProgress && !shutdownInProgress) {
        await _getFrameFromServer();
      }
      return true; // Forever!
    });
  }

  Future<void> initiateAction(cedar_rpc.ActionRequest request) async {
    try {
      await client().initiateAction(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint("initiateAction error: $e");
    }
  }

  Future<void> _setServerTime(DateTime now) async {
    final ts = Timestamp(
        seconds: Int64(now.millisecondsSinceEpoch ~/ 1000.0),
        nanos: (now.millisecondsSinceEpoch % 1000) * 1000000);
    var request = cedar_rpc.FixedSettings();
    request.currentTime = ts;
    await _updateFixedSettings(request);
  }

  Future<void> _setObserverLocation(LatLng pos) async {
    final posProto =
        cedar_rpc.LatLong(latitude: pos.latitude, longitude: pos.longitude);
    var request = cedar_rpc.FixedSettings();
    request.observerLocation = posProto;
    await _updateFixedSettings(request);
  }

  Future<void> _captureBoresight() async {
    final request = cedar_rpc.ActionRequest(captureBoresight: true);
    await initiateAction(request);
  }

  Future<void> _designateBoresight(Offset pos) async {
    final coord = cedar_rpc.ImageCoord(x: pos.dx, y: pos.dy);
    final request = cedar_rpc.ActionRequest(designateBoresight: coord);
    await initiateAction(request);
  }

  Future<void> _designateDaylightFocusRegion(Offset pos) async {
    final coord = cedar_rpc.ImageCoord(x: pos.dx, y: pos.dy);
    final request = cedar_rpc.ActionRequest(designateDaylightFocusRegion: coord);
    await initiateAction(request);
  }

  Future<void> _stopSlew() async {
    final request = cedar_rpc.ActionRequest(stopSlew: true);
    await initiateAction(request);
  }

  Future<void> _setOperatingMode(bool setupMode, bool focusAid) async {
    var request = cedar_rpc.OperationSettings();
    request.operatingMode = setupMode
        ? cedar_rpc.OperatingMode.SETUP
        : cedar_rpc.OperatingMode.OPERATE;
    request.focusAssistMode = focusAid;
    await updateOperationSettings(request);
  }

  Future<void> _setDaylightMode(bool value) async {
    final request = cedar_rpc.OperationSettings(daylightMode: value);
    await updateOperationSettings(request);
  }

  // Pass empty string to terminate demo mode.
  Future<void> _setDemoImage(String imageFile) async {
    final request = cedar_rpc.OperationSettings(demoImageFilename: imageFile);
    await updateOperationSettings(request);
  }

  Future<String> _getServerLogs() async {
    final request = cedar_rpc.ServerLogRequest(logRequest: 20000);
    try {
      final infoResult = await client().getServerLog(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
      return infoResult.logContent;
    } catch (e) {
      debugPrint("getServerLogs error: $e");
      return "";
    }
  }

  Text _scaledText(String str) {
    return Text(str, textScaler: textScaler(context));
  }

  Future<void> shutdown() async {
    shutdownInProgress = true;
    final request = cedar_rpc.ActionRequest(shutdownServer: true);
    await initiateAction(request);
  }

  Future<void> restart() async {
    shutdownInProgress = true;
    final request = cedar_rpc.ActionRequest(restartServer: true);
    await initiateAction(request);
  }

  Future<void> _crashServer() async {
    final request = cedar_rpc.ActionRequest(crashServer: true);
    await initiateAction(request);
  }

  Future<void> _restartCedarServer() async {
    if (_restartCedarServerFunction != null) {
      await _restartCedarServerFunction!();
    } else {
      throw Exception('Restart Cedar Server functionality not available');
    }
  }

  Future<void> _saveImage() async {
    final request = cedar_rpc.ActionRequest(saveImage: true);
    await initiateAction(request);
  }

  Future<void> updateWifi(String ssid, String psk, int channel) async {
    final updateWifi = WiFiAccessPoint(ssid: ssid, psk: psk, channel: channel);
    final request = cedar_rpc.ActionRequest(updateWifiAccessPoint: updateWifi);
    await initiateAction(request);
  }

  Future<void> _cancelCalibration() async {
    final request = cedar_rpc.ActionRequest(cancelCalibration: true);
    await initiateAction(request);
  }

  Future<void> updatePreferences(cedar_rpc.Preferences changedPrefs) async {
    try {
      final newPrefs = await client().updatePreferences(changedPrefs,
          options: CallOptions(timeout: const Duration(seconds: 2)));
      setState(() {
        preferences = newPrefs;
        if (newPrefs.nightVisionTheme) {
          Provider.of<ThemeModel>(context, listen: false).setNightVisionTheme();
        } else {
          Provider.of<ThemeModel>(context, listen: false).setNormalTheme();
        }
        var settingsModel = Provider.of<SettingsModel>(context, listen: false);
        settingsModel.preferencesProto = preferences!.deepCopy();
      });
    } catch (e) {
      debugPrint("updatePreferences error: $e");
    }
  }

  Widget _rowOrColumn(bool row, List<Widget> children) {
    return row ? Row(children: children) : Column(children: children);
  }

  Widget focusDoneButton({fontSize = 14.0}) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
          "Done",
          textScaler: textScaler(context),
        ),
        onPressed: () {
          setState(() {
            // Transition to align mode.
            _alignTargetTapped = false;
            if (!_setupMode) {
              _transitionToSetup = true;
            }
            _setOperatingMode(/*setupMode=*/ true, /*focusAid=*/ false);
          });
        });
  }

  Widget setupAlignSkipOrDoneButton({fontSize = 14.0}) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
          textScaler: textScaler(context),
          _alignTargetTapped ? "Done" : "Skip",
        ),
        onPressed: () {
          // Transition to aim mode.
          setState(() {
            _setOperatingMode(/*setupMode=*/ false, _focusAid);
          });
        });
  }

  Widget slewReAlignButton({fontSize = 14.0}) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
          textScaler: textScaler(context),
          "Re-align",
        ),
        onPressed: () {
          _wantAlignFeedback = true;
          _captureBoresight(); // Re-align.
        });
  }

  Widget catalogButton({fontSize = 14.0}) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          style: TextStyle(fontSize: fontSize),
          "Catalog",
          textScaler: textScaler(context),
        ),
        onPressed: () {
          if (_slewRequest != null) {
            _stopSlew();
          }
          _showCatalogBrowser!(context, this);
        });
  }

  Widget endGotoButton({fontSize = 14.0}) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          style: TextStyle(fontSize: fontSize),
          "End goto",
          textScaler: textScaler(context),
        ),
        onPressed: () {
          _stopSlew();
        });
  }

  Widget _buildControlsWidget() {
    return ControlsWidget(
      layoutCalculations: _getLayoutCalculations(),
      focusAid: _focusAid,
      daylightMode: _daylightMode,
      canAlign: _canAlign,
      setupMode: _setupMode,
      slewRequest: _slewRequest,
      boresightImageBytes: _boresightImageBytes,
      preferences: preferences,
      operationSettings: operationSettings,
      showCatalogBrowser: _showCatalogBrowser != null,
      onPreferencesUpdate: (prefsDiff) => updatePreferences(prefsDiff),
      onOperationSettingsUpdate: (opSettingsDiff) => updateOperationSettings(opSettingsDiff),
      onGoFullScreen: goFullScreen,
      onCancelFullScreen: cancelFullScreen,
      onSetWakeLock: (enabled) => setWakeLock(enabled),
      onSetDaylightMode: (enabled) => setState(() {
        _setDaylightMode(enabled);
      }),
      focusDoneButton: ({double? fontSize}) => focusDoneButton(fontSize: fontSize),
      setupAlignSkipOrDoneButton: ({double? fontSize}) => setupAlignSkipOrDoneButton(fontSize: fontSize),
      slewReAlignButton: ({double? fontSize}) => slewReAlignButton(fontSize: fontSize),
      catalogButton: ({double? fontSize}) => catalogButton(fontSize: fontSize),
      endGotoButton: ({double? fontSize}) => endGotoButton(fontSize: fontSize),
      scaledText: (String text) => _scaledText(text),
      rowOrColumn: (bool portrait, List<Widget> children) => _rowOrColumn(portrait, children),
    );
  }

  // ra: 0..360.
  String formatRightAscension(double ra, {bool short = false}) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.3f°", [ra]);
    }
    if (short) {
      // Round up to nearest minute.
      const thirtySecs = 30.0 * 360 / 86400.0;
      ra += thirtySecs;
      if (ra > 360) {
        ra -= 360;
      }
    }
    int hours = (ra / 15.0).floor();
    double fracHours = ra / 15.0 - hours;
    int minutes = (fracHours * 60.0).floor();
    double fracMinutes = fracHours * 60.0 - minutes;
    int seconds = (fracMinutes * 60).floor();
    return short
        ? sprintf("%02dh%02dm", [hours, minutes])
        : sprintf("%02dh%02dm%02ds", [hours, minutes, seconds]);
  }

  // ha: -180..180.
  String formatHourAngle(double ha, {bool short = false}) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.3f°", [ha]);
    }
    if (short) {
      // Round up or down to nearest minute.
      const thirtySecs = 30.0 * 360 / 86400.0;
      if (ha > 0) {
        ha += thirtySecs;
        if (ha > 180) {
          ha -= 360;
        }
      } else {
        ha -= thirtySecs;
        if (ha < -180) {
          ha += 360;
        }
      }
    }
    String sign = ha < 0 ? "-" : "+";
    if (ha < 0) {
      ha = -ha;
    }
    int hours = (ha / 15.0).floor();
    double fracHours = ha / 15.0 - hours;
    int minutes = (fracHours * 60.0).floor();
    double fracMinutes = fracHours * 60.0 - minutes;
    int seconds = (fracMinutes * 60).floor();
    return short
        ? sprintf("%s%02dh%02dm", [sign, hours, minutes])
        : sprintf("%s%02dh%02dm%02ds", [sign, hours, minutes, seconds]);
  }

  // dec: -90..90.
  String formatDeclination(double dec, {bool short = false}) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.3f°", [dec]);
    }
    if (short) {
      // Round up or down to nearest minute.
      const thirtySecs = 30.0 / 3600.0;
      if (dec > 0) {
        dec += thirtySecs;
      } else {
        dec -= thirtySecs;
      }
    }
    String sign = dec < 0 ? "-" : "+";
    if (dec < 0) {
      dec = -dec;
    }
    int degrees = dec.floor();
    double fracDegrees = dec - degrees;
    int minutes = (fracDegrees * 60.0).floor();
    double fracMinutes = fracDegrees * 60.0 - minutes;
    int seconds = (fracMinutes * 60).floor();
    return short
        ? sprintf("%s%02d°%02d'", [sign, degrees, minutes])
        : sprintf("%s%02d°%02d'%02d''", [sign, degrees, minutes, seconds]);
  }

  String formatAltitude(double alt, {bool short = false}) {
    return short ? sprintf("%d°", [alt.round()]) : sprintf("%.2f°", [alt]);
  }

  String formatAzimuth(double az, {bool short = false}) {
    final String dir = switch (az) {
      >= 360 - 22.5 || < 22.5 => "N",
      >= 22.5 && < 45 + 22.5 => "NE",
      >= 45 + 22.5 && < 90 + 22.5 => "E",
      >= 90 + 22.5 && < 135 + 22.5 => "SE",
      >= 135 + 22.5 && < 180 + 22.5 => "S",
      >= 180 + 22.5 && < 225 + 22.5 => "SW",
      >= 225 + 22.5 && < 270 + 22.5 => "W",
      >= 270 + 22.5 && < 315 + 22.5 => "NW",
      double() => "??",
    };
    return short
        ? sprintf("%s %d°", [dir, az.round()])
        : sprintf("%s %.2f°", [dir, az]);
  }

  String _format2places(double val) {
    if (val.abs() >= 10.0) {
      return sprintf("%.0f", [val]);
    }
    if (val.abs() >= 1.0) {
      return sprintf("%.1f", [val]);
    }
    return sprintf("%.2f", [val]);
  }

  String _formatAdvice(cedar_rpc.ErrorBoundedValue? ebv) {
    if (ebv == null) {
      return "null";
    }
    return sprintf(
        "%s°±%s", [_format2places(ebv.value), _format2places(ebv.error)]);
  }

  bool get hasSolution => _hasSolution;

  Color _solveColor() {
    return _hasSolution
        ? Theme.of(context).colorScheme.primary
        : const Color(0xff606060);
  }

  Text _primaryText(String val, {double? size = 16, bool underline = false}) {
    return Text(
      val,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: size,
        decoration: underline ? TextDecoration.underline : null,
      ),
      textScaler: textScaler(context),
    );
  }

  Text solveText(String val, {double? size = 14, bool underline = false}) {
    final color = _solveColor();
    return Text(
      val,
      style: TextStyle(
          color: color,
          fontSize: size,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: underline ? color : null),
      textScaler: textScaler(context),
    );
  }

  bool _hasPolarAdvice() {
    if (_polarAlignAdvice == null) {
      return false;
    }
    return _polarAlignAdvice!.hasAltitudeCorrection() ||
        _polarAlignAdvice!.hasAzimuthCorrection();
  }

  List<Widget> _raDec(double panelScaleFactor) {
    final size = 11.0 * panelScaleFactor;
    return [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [solveText("RA/Dec", size: size, underline: true)]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        solveText(formatRightAscension(solutionRA, short: true), size: size)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        solveText(formatDeclination(solutionDec, short: true), size: size)
      ]),
    ];
  }

  List<Widget> _azAlt(double panelScaleFactor) {
    final size = 10.0 * panelScaleFactor;
    return [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [solveText("Az/Alt/HA", size: size, underline: true)]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        solveText(formatAzimuth(locationBasedInfo!.azimuth), size: size)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        solveText(formatAltitude(locationBasedInfo!.altitude), size: size)
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        solveText(formatHourAngle(locationBasedInfo!.hourAngle, short: true),
            size: size)
      ]),
    ];
  }

  List<Widget> _coordInfo(double panelScaleFactor) {
    if (preferences?.celestialCoordChoice == "RA_DEC" ||
        preferences?.celestialCoordChoice == null ||
        locationBasedInfo == null) {
      return _raDec(panelScaleFactor);
    } else {
      return _azAlt(panelScaleFactor);
    }
  }

  Widget _selectIcon(double value, IconData positive, IconData negative) {
    Color color = Theme.of(context).colorScheme.primary;
    return Icon(value > 0 ? positive : negative, color: color);
  }

  List<Widget> _dataItems(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final textScale = textScaleFactor(context);
    final constraints = MediaQuery.of(context).size;
    final shortDimension = portrait ? constraints.width : constraints.height;

    final calculations = _getLayoutCalculations();
    final panelWidth = calculations['panelWidth']!;

    // Note that widgets are sized according to two factors. The first is
    // `textScale`, which is the user-chosen text size (small/medium/large). The
    // second scaling factor is `panelScaleFactor`, computed below to adapt the
    // widgets to available space in the panel above (or to the left of) the
    // main image.

    // Scale widgets based on constraining dimensions. We use the widgets shown
    // when _slewRequest is non-null because these in aggregate use the largest
    // layout.
    final coordInfoSize = 85.0 * textScale;
    final objectLabelSize = 60.0 * textScale;

    // First, consider the dimension along the slew navigation widgets.
    final mainDimension = 2.0 * coordInfoSize + objectLabelSize;
    final mainDimensionBasedScale = (shortDimension / mainDimension);

    // Next, consider the dimension across the slew navigation widgets.
    final crossDimension = math.max(coordInfoSize, objectLabelSize);
    final crossDimensionBasedScale = (panelWidth / crossDimension);

    final panelScaleFactor =
      math.min(mainDimensionBasedScale, crossDimensionBasedScale).clamp(0.5, 1.2);

    var gaugeSize = 45 * panelScaleFactor * textScale;

    // When goto is active, show movement instructions.
    if (_slewRequest != null) {
      final slew = _slewRequest!;
      final isAltAz = preferences?.mountType == cedar_rpc.MountType.ALT_AZ;

      return <Widget>[
        // Rotation axis guidance.
        RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: _slewDirections.buildAxisGuidance(
              context,
              isAltAz ? "Az" : "RA",
              slew.offsetRotationAxis,
              isAltAz,
              true, // isRotationAxis
              panelScaleFactor,
              coordInfoSize * panelScaleFactor,
            )),
        // Object label.
        RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: _slewDirections.buildObjectLabel(
              context,
              slew.target,
              slew.targetCatalogEntry,
              panelScaleFactor,
              objectLabelSize * panelScaleFactor,
              formatRightAscension,
              formatDeclination,
            )),
        // Tilt axis guidance.
        RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: _slewDirections.buildAxisGuidance(
              context,
              isAltAz ? "Alt" : "Dec",
              slew.offsetTiltAxis,
              isAltAz,
              false, // isRotationAxis
              panelScaleFactor,
              coordInfoSize * panelScaleFactor,
            )),
      ];
    }

    return <Widget>[
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode && !(_focusAid && advanced && !_daylightMode)
              ? SizedBox(
                  width: gaugeSize,
                  height: gaugeSize,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      PerfGauge(
                        state: this,
                        size: gaugeSize,
                        textFactor: panelScaleFactor,
                        thicknessFactor: panelScaleFactor,
                      ),
                    ])),
      if (!_setupMode) ...[
        RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: SizedBox(
                width: 60 * panelScaleFactor * textScaleFactor(context),
                height: 60 * panelScaleFactor * textScaleFactor(context),
                child: GestureDetector(
                  onTap: () {
                    skyCoordsDialog(this, context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // RA/Dec, Alt/Az, etc.
                    children: _coordInfo(panelScaleFactor),
                  ),
                ))),
      ],
      if (_hasPolarAdvice() && !_setupMode && (isPlus || isDIY)) ...[
        RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: SizedBox(
              width: 70 * panelScaleFactor * textScaleFactor(context),
              height: 60 * panelScaleFactor * textScaleFactor(context),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _primaryText("Eq. Mount",
                        size: 10 * panelScaleFactor, underline: true),
                    solveText(
                        _formatAdvice(_polarAlignAdvice!.hasAltitudeCorrection()
                            ? _polarAlignAdvice!.altitudeCorrection
                            : _polarAlignAdvice!.azimuthCorrection),
                        size: 10 * panelScaleFactor),
                    _polarAlignAdvice!.hasAltitudeCorrection()
                        ? _selectIcon(
                            _polarAlignAdvice!.altitudeCorrection.value,
                            Icons.north,
                            Icons.south)
                        : _selectIcon(
                            _polarAlignAdvice!.azimuthCorrection.value,
                            Icons.rotate_right,
                            Icons.rotate_left),
                  ]),
            )),
      ],
    ];
  }

  Widget _loadImage() {
    return dart_widgets.Image.memory(_imageBytes, gaplessPlayback: true);
  }

  // Use a generous hit tolerance, otherwise it is difficult to tap on a sky
  // object. There can be multiple objects within this tolerance; we take care
  // to return the closest one.
  static const int hitTolerance = 50;

  Widget _mainImage() {
    return ClipRect(
        child: CustomPaint(
            foregroundPainter: _MainImagePainter(this, context),
            child: GestureDetector(
              child: _loadImage(),
              onTapDown: (TapDownDetails details) async {
                final displayScale = _getDisplayScale();
                Offset localPosition = Offset(
                    details.localPosition.dx * _binFactor / displayScale,
                    details.localPosition.dy * _binFactor / displayScale);

                if (_setupMode) {
                  if (_focusAid && _daylightMode) {
                    // Daylight focus mode - designate focus region.
                    await _designateDaylightFocusRegion(localPosition);
                  } else if (!_focusAid) {
                    // Align mode.
                    if (_daylightMode) {
                      await _designateBoresight(localPosition);
                      _alignTargetTapped = true;
                      _wantAlignFeedback = true;
                    } else {
                      var star = _findStarHit(localPosition, hitTolerance);
                      if (star != null) {
                        await _designateBoresight(Offset(
                          star.centroidPosition.x,
                          star.centroidPosition.y,
                        ));
                        _alignTargetTapped = true;
                        _wantAlignFeedback = true;
                      }
                    }
                  }
                } else {
                  // Aim mode.
                  if (_objectInfoDialog != null) {
                    var object = _findObjectHit(localPosition, hitTolerance);
                    if (object != null) {
                      var selEntry = SelectedCatalogEntry(entry: object.entry);
                      _objectInfoDialog!(this, context, selEntry);
                    }
                  }
                }
              },
            )));
  }

  StarCentroid? _findStarHit(Offset tapPosition, int tolerance) {
    if (_stars.isEmpty) {
      return null;
    }
    StarCentroid? closest;
    double closestDistance = 0;
    double brightest = _stars[0].brightness;
    // We only include stars up to two magnitude fainter.
    double faintLimit = brightest / _faintLimit;

    int numTargets = 0;
    for (var star in _stars) {
      if (star.brightness < faintLimit) {
        break;
      }
      if (++numTargets > _numTargets) {
        break;
      }
      Offset imagePos =
          Offset(star.centroidPosition.x, star.centroidPosition.y);
      var distance = (imagePos - tapPosition).distance;
      if (closest == null || distance < closestDistance) {
        closest = star;
        closestDistance = distance;
      }
    }
    if (closest != null && closestDistance < tolerance * _binFactor) {
      return closest;
    }
    return null;
  }

  cedar_rpc.FovCatalogEntry? _findObjectHit(Offset tapPosition, int tolerance) {
    cedar_rpc.FovCatalogEntry? closest;
    double closestDistance = 0;

    for (var entry in _labeledFovCatalogEntries) {
      Offset imagePos = Offset(entry.imagePos.x, entry.imagePos.y);
      var distance = (imagePos - tapPosition).distance;
      if (closest == null || distance < closestDistance) {
        closest = entry;
        closestDistance = distance;
      }
    }
    for (var entry in _unlabeledFovCatalogEntries) {
      Offset imagePos = Offset(entry.imagePos.x, entry.imagePos.y);
      var distance = (imagePos - tapPosition).distance;
      if (closest == null || distance < closestDistance) {
        closest = entry;
        closestDistance = distance;
      }
    }
    if (closest != null && closestDistance < tolerance * _binFactor) {
      return closest;
    }
    return null;
  }

  Widget _pacifier(BuildContext context, bool calibrating) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (calibrating) ...[
                Text("Calibrating",
                    textScaler: textScaler(context),
                    style: TextStyle(
                        fontSize: 20,
                        backgroundColor: Colors.black,
                        color: Theme.of(context).colorScheme.primary)),
              ],
              const SizedBox(height: 15),
              CircularProgressIndicator(
                  value: calibrating ? _calibrationProgress : null,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 15),
              if (calibrating) ...[
                TextButton(
                  onPressed: () {
                    _cancelCalibration();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Theme.of(context).colorScheme.primary),
                  child: _scaledText("Cancel"),
                ),
              ],
            ]));
  }

  Widget _imageStack(BuildContext context) {
    Widget? overlayWidget;
    // Scale the overlay size with the display scale
    final displayScale = _getDisplayScale();

    if (_setupMode && _focusAid && _daylightMode && _daylightFocusZoomImageBytes != null) {
      final overlaySize = (_imageRegion.height / 4) * displayScale;
      overlayWidget = dart_widgets.Image.memory(_daylightFocusZoomImageBytes!,
          height: overlaySize,
          width: overlaySize,
          fit: BoxFit.fill,
          gaplessPlayback: true);
    } else if (_setupMode && _focusAid && _centerPeakImageBytes != null) {
      final overlaySize = (_imageRegion.height / 4) * displayScale;
      overlayWidget = dart_widgets.Image.memory(_centerPeakImageBytes!,
          height: overlaySize,
          width: overlaySize,
          fit: BoxFit.fill,
          gaplessPlayback: true);
    } else if (!_setupMode && _boresightImageBytes != null) {
      final overlaySize = (_imageRegion.height / 3) * displayScale;
      var overlayImage = dart_widgets.Image.memory(_boresightImageBytes!,
          width: overlaySize,
          height: overlaySize,
          fit: BoxFit.fill,
          gaplessPlayback: true);
      overlayWidget = ClipRect(
          child: CustomPaint(
              foregroundPainter: _OverlayImagePainter(this, context,
                  overlaySize / _boresightImageHeight, _binFactor),
              child: overlayImage));
    }
    return Stack(alignment: Alignment.topRight, children: <Widget>[
      _prevFrameId != -1
          ? _mainImage()
          : const SizedBox(width: 500, height: 500),
      if (_prevFrameId != -1 && overlayWidget != null) ...[
        Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: Theme.of(context).colorScheme.primary)),
            child: overlayWidget),
      ],
      if (_calibrating || _transitionToSetup) ...[
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: _pacifier(context, _calibrating))),
      ],
    ]);
  }

  int _getCurrentTextSizeIndex() {
    if (preferences == null) {
      return 0;
    }
    return preferences!.textSizeIndex;
  }

  Future<void> _setTextSizeIndex(int textSizeIndex) async {
    textSizeIndex = math.min(textSizeIndex, 1);
    textSizeIndex = math.max(textSizeIndex, -1);
    if (preferences == null || preferences!.textSizeIndex == textSizeIndex) {
      return;
    }
    var prefs = cedar_rpc.Preferences();
    prefs.textSizeIndex = textSizeIndex;
    await updatePreferences(prefs);
  }

  int _initialTextSizeIndex = 0;

  // Helper method to calculate display scale and image size
  Map<String, double> _getLayoutCalculations() {
    final constraints = MediaQuery.of(context).size;
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Calculate layout dimensions
    const minPanelWidth = 120.0;
    final longDimension = portrait ? constraints.height : constraints.width;
    final shortDimension = portrait ? constraints.width : constraints.height;
    const spacingWidth = 0.0;

    // Determine the natural/preferred image size using actual image dimensions
    final actualImageHeight = _imageRegion.height;
    final naturalImageSize = math.min(shortDimension, actualImageHeight);

    // Calculate what we'd need for natural size + minimum panels
    final naturalLayoutWidth =
        naturalImageSize + 2 * minPanelWidth + spacingWidth;

    final double actualImageSize;
    final double panelWidth;

    if (longDimension >= naturalLayoutWidth) {
      // We have plenty of space - use natural image size and let panels expand
      actualImageSize = naturalImageSize;
      // Calculate how much extra space we have and distribute it to panels
      final extraSpace = longDimension - naturalLayoutWidth;
      panelWidth = minPanelWidth + (extraSpace / 2);
    } else {
      // Space is constrained - calculate based on available space
      final remainingWidth = longDimension - naturalImageSize - spacingWidth;
      const minPanelsWidth = 2 * minPanelWidth;
      if (remainingWidth >= minPanelsWidth) {
        // We can fit minimum panels with natural image size
        actualImageSize = naturalImageSize;
        panelWidth = remainingWidth / 2;
      } else {
        // Must shrink image to fit minimum panels
        actualImageSize =
            math.max(50.0, longDimension - minPanelsWidth - spacingWidth);
        panelWidth = minPanelWidth;
      }
    }

    final displayScale = actualImageSize / _imageRegion.width;

    return {
      'actualImageSize': actualImageSize,
      'panelWidth': panelWidth,
      'displayScale': displayScale,
    };
  }

  double _getDisplayScale() {
    return _getLayoutCalculations()['displayScale']!;
  }

  Widget _orientationLayout(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final controls = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildControlsWidget()]);
    final data = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _dataItems(context));

    return GestureDetector(
        // On Android, sometimes the system and navigation bars become visible.
        // Kludge long-press to re-assert our desired screen mode.
        onLongPress: () {
          bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
              .preferencesProto
              .hideAppBar;
          if (hideAppBar) {
            goFullScreen();
          } else {
            cancelFullScreen();
          }
        },
        onScaleStart: (details) {
          _initialTextSizeIndex = _getCurrentTextSizeIndex();
        },
        onScaleUpdate: (details) {
          final scale = details.scale;
          if (scale > 1.5) {
            _setTextSizeIndex(_initialTextSizeIndex + 2);
            return;
          }
          if (scale > 1.2) {
            _setTextSizeIndex(_initialTextSizeIndex + 1);
            return;
          }
          if (scale < 0.66) {
            _setTextSizeIndex(_initialTextSizeIndex - 2);
            return;
          }
          if (scale < 0.83) {
            _setTextSizeIndex(_initialTextSizeIndex - 1);
            return;
          }
          _setTextSizeIndex(_initialTextSizeIndex);
        },
        child: RotatedBox(
          quarterTurns: portrait ? 1 : 0,
          child: Builder(
            builder: (context) {
              // Get layout calculations
              final calculations = _getLayoutCalculations();
              final actualImageSize = calculations['actualImageSize']!;
              final panelWidth = calculations['panelWidth']!;

              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Left panel
                    SizedBox(
                      width: panelWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: (portrait || _rightHanded) ? data : controls,
                        ),
                      ),
                    ),
                    // Center image
                    SizedBox(
                      width: actualImageSize,
                      height: actualImageSize,
                      child: _imageStack(context),
                    ),
                    // Right panel
                    SizedBox(
                      width: panelWidth,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: (portrait || _rightHanded) ? controls : data,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
    _scaffoldKey.currentState?.closeEndDrawer();
  }

  Widget _drawer() {
    return CedarDrawer(
        controller: CedarDrawerController(
          setupMode: _setupMode,
          focusAid: _focusAid,
          offerMap: _offerMap,
          mapPosition: _mapPosition,
          advanced: advanced,
          demoMode: _demoMode,
          demoFiles: _demoFiles,
          systemMenuExpanded: _systemMenuExpanded,
          demoFile: _demoFile,
          hasWifiControl: _hasWifiControl,
          badServerState: !healthy,
          updateServerSoftwareDialogFunction:
              _updateServerSoftwareDialogFunction,
          restartCedarServerFunction: _restartCedarServerFunction,
          wifiAccessPointDialog: _wifiAccessPointDialog,
          setOperatingMode: (setupMode, focusAid) async {
            if (!_setupMode && setupMode) {
              setState(() {
                _transitionToSetup = true;
              });
            }
            if (setupMode && focusAid) {
              // Focus mode specific setup
              setState(() {
                _alignTargetTapped = false;
              });
            } else if (setupMode && !focusAid) {
              // Align mode specific setup
              setState(() {
                _alignTargetTapped = false;
              });
            }
            await _setOperatingMode(setupMode, focusAid);
          },
          setDemoImage: (imageFile) async {
            setState(() {
              _demoFile = imageFile;
              _demoMode = imageFile.isNotEmpty;
            });
            await _setDemoImage(imageFile);
          },
          saveImage: _saveImage,
          getServerLogs: _getServerLogs,
          crashServer: _crashServer,
          restartCedarServer: _restartCedarServer,
          initiateAction: initiateAction,
          updatePreferences: updatePreferences,
          setAdvanced: (value) async {
            setState(() {
              advanced = value;
            });
            var settingsModel =
                Provider.of<SettingsModel>(context, listen: false);
            settingsModel.preferencesProto.advanced = value;
            var prefs = cedar_rpc.Preferences();
            prefs.advanced = value;
            await updatePreferences(prefs);
          },
          setDemoMode: (value) async {
            setState(() {
              _demoMode = value;
              if (value && _demoFile.isNotEmpty) {
                // Turn on demo mode with current file
                _setDemoImage(_demoFile);
              } else {
                // Turn off demo mode
                _setDemoImage("");
              }
            });
          },
          setSystemMenuExpanded: (value) {
            setState(() {
              _systemMenuExpanded = value;
            });
          },
          onStateChanged: () => setState(() {}),
          closeDrawer: closeDrawer,
          context: context,
          homePageState: this,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (healthy && _wifiClientDialogController != null) {
      _wifiClientDialogController!.showDialog(/*open=*/ false, this, context);
    }

    // This method is rerun every time setState() is called.
    bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
        .preferencesProto
        .hideAppBar;
    final String product =
        serverInformation != null ? serverInformation!.productName : "e-finder";

    if (_showWelcome && !_dontShowWelcome) {
      return interstitialDialog(
        "Welcome to Cedar Aim!\nThe next few screens will walk you through "
        "setting up your $product.",
        context,
        onConfirm: () {
          setState(() {
            _showedWelcome = true;
            _showWelcome = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('welcome');
          }
          await updatePreferences(prefs);
        },
      );
    }
    if (_showFocusIntro && _focusAid && _setupMode) {
      return interstitialDialog(
        product == "Hopper"
            ? "We will verify the focus of your $product, which was set "
                "at the factory and should not need adjustment.\n"
                "Please point your telescope "
                "towards some stars. At the next screen, one of the stars "
                "will be magnified; it should be round and compact.\n"
                "You can select 'Day' to check focus using a daylight scene."
            : "We will check and adjust the focusing of your $product.\nPlease point "
                "your telescope towards some stars. "
                "At the next screen, adjust the $product lens to make "
                "the highlighted star image as compact as possible.\n"
                "You can select 'Day' to adjust focus using a daylight scene.",
        context,
        onConfirm: () {
          setState(() {
            _showFocusIntro = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('focus_intro');
          }
          await updatePreferences(prefs);
        },
      );
    }
    if (_showAlignIntro && !_focusAid && _setupMode) {
      return interstitialDialog(
        "We will set the alignment of your $product "
        "relative to your telescope.\nStart by pointing your telescope at "
        "any bright star or planet, preferably one that is the brightest in "
        "its area of the sky. Then, follow the prompt on the next screen.\n"
        "You can select 'Day' to set alignment using a daylight scene.",
        context,
        onConfirm: () {
          setState(() {
            _showAlignIntro = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('align_intro');
          }
          await updatePreferences(prefs);
        },
      );
    }
    if (_showTooFewStars) {
      String action = product == "Hopper"
          ? " and verify the lens cap is open"
          : ", verify the lens cap is open, and check focus";
      return interstitialDialog(
        "Calibration of $product failed because too few stars are visible.\n"
        "Please point $product at stars$action.",
        context,
        onConfirm: () {
          setState(() {
            _showTooFewStars = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('too_few_stars');
          }
          await updatePreferences(prefs);
        },
      );
    }
    if (_showBrightSky) {
      return interstitialDialog(
        "Calibration of $product failed because the sky is too bright.\n",
        context,
        onConfirm: () {
          setState(() {
            _showBrightSky = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('bright_sky');
          }
          await updatePreferences(prefs);
        },
      );
    }
    if (_showSolverFailed) {
      return interstitialDialog(
        "Calibration of $product failed because the star field is not recgonized.\n",
        context,
        onConfirm: () {
          setState(() {
            _showSolverFailed = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('solver_failed');
          }
          await updatePreferences(prefs);
        },
      );
    }

    if (_showSetupFinished) {
      String useCatalog = product == "Hopper"
          ? "\nUse the 'Catalog' button to access the Cedar Sky database"
              " of celestial objects."
          : "";
      return interstitialDialog(
        "All set!\nYour $product is ready to help you explore the night sky "
        "with your telescope.$useCatalog",
        context,
        onConfirm: () {
          setState(() {
            _showSetupFinished = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          if (value) {
            prefs.dontShowItems.add('setup_finished');
          }
          await updatePreferences(prefs);
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          toolbarHeight: hideAppBar ? 0 : 56,
          toolbarOpacity: hideAppBar ? 0.0 : 1.0,
          title: Text(widget.title),
          foregroundColor: Theme.of(context).colorScheme.primary),
      onDrawerChanged: _handleDrawerChanged,
      onEndDrawerChanged: _handleDrawerChanged,
      body: DefaultTextStyle.merge(
          style: const TextStyle(fontFamilyFallback: ["Roboto"]),
          child: SafeArea(
              child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      healthy ? _orientationLayout(context) : _badServerState(),
                      if (hideAppBar) ...[
                        Positioned(
                            left: _rightHanded ? null : 0,
                            right: _rightHanded ? 0 : null,
                            top: 0,
                            child: IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  if (_rightHanded) {
                                    _scaffoldKey.currentState!.openEndDrawer();
                                  } else {
                                    _scaffoldKey.currentState!.openDrawer();
                                  }
                                })),
                      ],
                    ],
                  )))),
      drawer: _drawer(),
      endDrawer: _drawer(),
      drawerEdgeDragWidth: 100,
    );
  }

  void _handleDrawerChanged(bool isOpened) {
    if (isOpened) {
      // Drawer opened, hide WiFi dialog temporarily
      _wifiClientDialogController?.hideTemporarily();
    } else {
      // Drawer closed, show WiFi dialog again if it was temporarily hidden
      _wifiClientDialogController?.showAfterHiding(context);
    }
    // Prevent jank in demo mode image file selector.
    _inhibitRefresh = isOpened;
  }

  Widget _badServerState() {
    _paintPending = false;
    // Give some time for an initial connection to succeed.
    final elapsed = DateTime.now().difference(_startTime);
    if (elapsed.inMilliseconds < 1000) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isMobile() && !_serverConnected && _wifiClientDialogController != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _wifiClientDialogController!.showDialog(/*open=*/ true, this, context);
      });
      return Container();
    }
    // If we're still here, we are on Web platform or the camera is not present.

    Color color = Theme.of(context).colorScheme.primary;
    // If web, put up message
    final connMessage = everConnected
        ? "Connection lost to Cedar server"
        : "No connection to Cedar server";
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color),
              bottom: BorderSide(color: color),
              left: BorderSide(color: color),
              right: BorderSide(color: color),
            ),
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
                maxLines: 10,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                _serverConnected
                    ? "Cedar could not detect a camera. "
                        "Please check the camera connection."
                    : "$connMessage. Please ensure that Cedar "
                        "server is running, connect this device to the Cedar "
                        "WiFi hotspot, and navigate to http://192.168.4.1."),
          ]),
        ),
      ),
    );
  }
} // MyHomePageState
