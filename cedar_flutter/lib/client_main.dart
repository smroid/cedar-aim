// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;
import 'package:cedar_flutter/about.dart';
import 'package:cedar_flutter/cedar.pb.dart';
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/draw_slew_target.dart';
import 'package:cedar_flutter/draw_util.dart';
import 'package:cedar_flutter/geolocation.dart';
import 'package:cedar_flutter/google/protobuf/timestamp.pb.dart';
import 'package:cedar_flutter/interstitial_msg.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/server_log.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:cedar_flutter/shutdown_dialog.dart';
import 'package:cedar_flutter/sky_coords_dialog.dart';
import 'package:cedar_flutter/themes.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as dart_widgets;
import 'package:grpc/grpc.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'platform.dart';

// To generate release build:
// flutter build web --no-web-resources-cdn

typedef DrawCatalogEntriesFunction = void Function(BuildContext, Canvas, Color,
    List<cedar_rpc.FovCatalogEntry>, bool, int, bool);

typedef ShowCatalogBrowserFunction = void Function(
    BuildContext, MyHomePageState);

typedef ObjectInfoDialogFunction = void Function(
    MyHomePageState, BuildContext, SelectedCatalogEntry);

typedef WifiAccessPointDialogFunction = void Function(
    MyHomePageState, BuildContext);

typedef WifiClientDialogFunction = void Function(
    bool, MyHomePageState, BuildContext);

DrawCatalogEntriesFunction? _drawCatalogEntries;
ShowCatalogBrowserFunction? _showCatalogBrowser;
ObjectInfoDialogFunction? _objectInfoDialog;
WifiAccessPointDialogFunction? _wifiAccessPointDialog;
WifiClientDialogFunction? _wifiClientDialog;

void clientMain(
    DrawCatalogEntriesFunction? drawCatalogEntries,
    ShowCatalogBrowserFunction? showCatalogBrowser,
    ObjectInfoDialogFunction? objectInfoDialog,
    WifiAccessPointDialogFunction? wifiAccessPointDialog,
    WifiClientDialogFunction? wifiClientDialog) {
  _drawCatalogEntries = drawCatalogEntries;
  _showCatalogBrowser = showCatalogBrowser;
  _objectInfoDialog = objectInfoDialog;
  _wifiAccessPointDialog = wifiAccessPointDialog;
  _wifiClientDialog = wifiClientDialog;

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

  void _paint(Canvas canvas, Size size) {
    const double thin = 1;
    const double thick = 1.5;
    final Color color = Theme.of(_context).colorScheme.primary;
    final Color opaqueColor =
        Color.fromARGB(128, color.red, color.green, color.blue);

    if (state._setupMode &&
        state._centerPeakRegion != null &&
        state._focusAid &&
        !state._daylightMode) {
      // Draw box around location of the brightest star.
      canvas.drawRect(
          state._centerPeakRegion as Rect,
          Paint()
            ..color = color
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
        canvas.drawRect(
            Rect.fromCenter(
                center: Offset(star.centroidPosition.x / state._binFactor,
                    star.centroidPosition.y / state._binFactor),
                width: 16,
                height: 16),
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

    // How many display pixels is the telescope FOV?
    if (state._slewRequest != null && !state._setupMode && state._hasSolution) {
      final slew = state._slewRequest;
      Offset? posInImage;
      if (slew!.hasImagePos()) {
        posInImage = Offset(slew.imagePos.x / state._binFactor,
            slew.imagePos.y / state._binFactor);
      }
      drawSlewTarget(
          _context,
          canvas,
          color,
          state._boresightPosition,
          state._scopeFov / state._rotationSizeRatio,
          /*rollAngleRad=*/ _deg2rad(state._bullseyeDirectionIndicator()),
          posInImage,
          slew.targetDistance,
          slew.targetAngle,
          /*drawDistanceText=*/ true,
          portrait);
      drawSlewDirections(
          _context,
          state,
          slew.target,
          slew.targetCatalogEntry,
          canvas,
          color,
          const Offset(15, 15),
          state.preferences?.mountType == cedar_rpc.MountType.ALT_AZ,
          state._northernHemisphere,
          slew.offsetRotationAxis,
          slew.offsetTiltAxis,
          portrait);
    } else if (!state._focusAid &&
        !state._calibrating &&
        !state._transitionToSetup) {
      var rollAngleRad = _deg2rad(state._bullseyeDirectionIndicator());
      drawBullseye(canvas, color, state._boresightPosition,
          state._scopeFov / state._rotationSizeRatio / 2, rollAngleRad);
      if (labeledCatalogEntries.isNotEmpty &&
          state._slewRequest == null &&
          _drawCatalogEntries != null) {
        _drawCatalogEntries!(_context, canvas, color, labeledCatalogEntries,
            /*drawLabel=*/ true, state._binFactor, portrait);
        if (dimLabeledCatalogEntries.isNotEmpty) {
          _drawCatalogEntries!(
              _context,
              canvas,
              opaqueColor,
              dimLabeledCatalogEntries,
              /*drawLabel=*/ true,
              state._binFactor,
              portrait);
        }
        _drawCatalogEntries!(
            _context,
            canvas,
            color,
            state._unlabeledFovCatalogEntries,
            /*drawLabel=*/ false,
            state._binFactor,
            portrait);
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
    // Note that slew.imagePos is in full resolution units.
    Offset? posInImage;
    if (slew!.hasImagePos()) {
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
        slew.targetDistance,
        slew.targetAngle,
        /*drawDistanceText=*/ false,
        portrait);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePageState extends State<MyHomePage> {
  MyHomePageState() {
    _initLocation();
    _refreshStateFromServer();
  }

  bool _showWelcome = false;
  bool _showedWelcome = false;
  bool _showFocusIntro = false;
  bool _showAlignIntro = false;

  bool _dontShowWelcome = false;
  bool _dontShowFocusIntro = false;
  bool _dontShowAlignIntro = false;

  // Whether we should offer a menu item to set the observer location via a map.
  bool _offerMap = false;

  // Geolocation from map.
  LatLng? _mapPosition;
  bool _northernHemisphere = true;

  Duration _tzOffset = const Duration();
  bool _hasCamera = false;
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
  bool _rightHanded = true;
  bool _canAlign = false;
  bool _hasWifiControl = false;

  // Telescope eyepiece field of view (diameter), in scaled image pixels.
  double _scopeFov = 0.0;

  Offset _boresightPosition =
      const Offset(0, 0); // Scaled by main image's binning.
  Offset _fullResBoresightPosition = const Offset(0, 0);

  Rect? _centerPeakRegion; // Scaled by binning.

  int _centerPeakWidth = 0;
  int _centerPeakHeight = 0;
  Uint8List? _centerPeakImageBytes;

  int _boresightImageWidth = 0; // Full resolution units.
  Uint8List? _boresightImageBytes;

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
    numStars = _stars.length;
    if (response.fixedSettings.hasObserverLocation()) {
      _mapPosition = LatLng(response.fixedSettings.observerLocation.latitude,
          response.fixedSettings.observerLocation.longitude);
      _northernHemisphere = _mapPosition!.latitude > 0.0;
    }
    _hasSolution = false;
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
    isDIY = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.DIY;
    isBasic = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.BASIC;
    isPlus = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.PLUS;
    _demoFiles = serverInformation!.demoImageNames;

    fixedSettings = response.fixedSettings;
    operationSettings = response.operationSettings;
    bool prevFocusMode = _setupMode && _focusAid;
    bool prevAlignMode = _setupMode && !_focusAid;
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
      _scopeFov = preferences!.eyepieceFov * _imageRegion.width / _solutionFOV;
    } else if (_scopeFov == 0) {
      // No plate solution yet, so we don't know the image scale. For now,
      // assume the eyepiece FOV is 1/10 the image width.
      _scopeFov = _imageRegion.width / 10;
    }
    noiseEstimate = response.noiseEstimate;
    _boresightPosition = Offset(response.boresightPosition.x / _binFactor,
        response.boresightPosition.y / _binFactor);
    _fullResBoresightPosition =
        Offset(response.boresightPosition.x, response.boresightPosition.y);
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
      _boresightImageWidth = response.boresightImage.rectangle.width;
      _boresightRotationSizeRatio = response.boresightImage.rotationSizeRatio;
    }
    if (response.hasCenterPeakPosition()) {
      var cp = response.centerPeakPosition;
      _centerPeakRegion = Rect.fromCenter(
          center: Offset(cp.x / _binFactor, cp.y / _binFactor),
          width: _centerPeakWidth.toDouble() / _binFactor,
          height: _centerPeakHeight.toDouble() / _binFactor);
    }
    if (preferences != null) {
      _dontShowWelcome = preferences!.dontShowWelcome;
      _dontShowFocusIntro = preferences!.dontShowFocusIntro;
      _dontShowAlignIntro = preferences!.dontShowAlignIntro;
    }
    if (newFocusMode && !prevFocusMode) {
      _showFocusIntro = !_dontShowFocusIntro;
    }
    if (newAlignMode && !prevAlignMode) {
      _showAlignIntro = !_dontShowAlignIntro;
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
      if (!_paintPending) {
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
    final request = cedar_rpc.ActionRequest(shutdownServer: true);
    await initiateAction(request);
  }

  Future<void> restart() async {
    final request = cedar_rpc.ActionRequest(restartServer: true);
    await initiateAction(request);
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

  String _removeExtension(String filename) {
    return path.basenameWithoutExtension(filename);
  }

  List<Widget> _drawerControls(BuildContext context) {
    return <Widget>[
      const SizedBox(height: 15),
      const CloseButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white10),
              alignment: Alignment.center)),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Container(width: 15),
              DropdownMenu<String>(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints:
                        BoxConstraints.tight(const Size.fromHeight(40)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  width: 120 * textScaleFactor(context),
                  requestFocusOnTap: false,
                  initialSelection:
                      _setupMode ? (_focusAid ? "Focus" : "Align") : "Aim",
                  label: _primaryText("Mode", size: 12),
                  dropdownMenuEntries: ["Focus", "Align", "Aim"]
                      .map<DropdownMenuEntry<String>>((String s) {
                    return DropdownMenuEntry<String>(
                      value: s,
                      label: s,
                      labelWidget: _primaryText(s),
                      enabled: true,
                    );
                  }).toList(),
                  textStyle: TextStyle(
                      fontSize: 12 * textScaleFactor(context),
                      color: Theme.of(context).colorScheme.primary),
                  onSelected: (String? newValue) async {
                    if (newValue == "Focus") {
                      setState(() {
                        if (!_setupMode) {
                          _transitionToSetup = true;
                        }
                        _setOperatingMode(
                            /*setupMode=*/ true, /*focusAid=*/ true);
                        // _showedFocusIntro = _dontShowFocusIntro;
                        // _showedAlignIntro = _dontShowAlignIntro;
                      });
                    } else if (newValue == "Align") {
                      setState(() {
                        _alignTargetTapped = false;
                        if (!_setupMode) {
                          _transitionToSetup = true;
                        }
                        _setOperatingMode(
                            /*setupMode=*/ true, /*focusAid=*/ false);
                        // _showedAlignIntro = _dontShowAlignIntro;
                      });
                    } else {
                      // Aim.
                      setState(() {
                        _setOperatingMode(
                            /*setupMode=*/ false, /*focusAid*/ false);
                      });
                    }
                    Navigator.of(context).pop();
                  }),
            ],
          )),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Preferences"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(this)))
                    .then((value) {
                  setState(() {}); // Force rebuild of the drawer.
                });
              })),
      SizedBox(height: _offerMap ? 15 : 0),
      _offerMap
          ? Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _mapPosition == null
                      ? _scaledText("Location unknown")
                      : _scaledText(sprintf("Location %.1f %.1f",
                          [_mapPosition!.latitude, _mapPosition!.longitude])),
                  icon: Icon(_mapPosition == null
                      ? Icons.not_listed_location
                      : Icons.edit_location_alt),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapScreen(this)));
                  }))
          : Container(),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Advanced"),
              icon: advanced
                  ? const Icon(Icons.check)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () async {
                advanced = !advanced;
                var settingsModel =
                    Provider.of<SettingsModel>(context, listen: false);
                settingsModel.preferencesProto.advanced = advanced;
                var prefs = cedar_rpc.Preferences();
                prefs.advanced = advanced;
                await updatePreferences(prefs);
              })),
      (advanced || _demoMode) && _demoFiles.isNotEmpty
          ? Column(children: <Widget>[
              const SizedBox(height: 15),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    label: _scaledText("Demo mode"),
                    icon: _demoMode
                        ? const Icon(Icons.check)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        _demoMode = !_demoMode;
                        if (_demoMode) {
                          if (_demoFile.isNotEmpty) {
                            _setDemoImage(_demoFile);
                          }
                        } else {
                          _setDemoImage(""); // Turn off.
                        }
                      });
                    },
                  )),
              const SizedBox(height: 10)
            ])
          : Container(),
      _demoMode && _demoFiles.isNotEmpty
          ? Column(children: [
              Row(children: [
                Container(width: 15),
                DropdownMenu<String>(
                    menuHeight: 200,
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      constraints:
                          BoxConstraints.tight(const Size.fromHeight(40)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    width: 200 * textScaleFactor(context),
                    requestFocusOnTap: false,
                    initialSelection: _demoFile.isEmpty ? "" : _demoFile,
                    label: _primaryText("Image file", size: 12),
                    dropdownMenuEntries:
                        _demoFiles.map<DropdownMenuEntry<String>>((String s) {
                      return DropdownMenuEntry<String>(
                        value: s,
                        label: _removeExtension(s),
                        labelWidget: _primaryText(_removeExtension(s)),
                        enabled: true,
                      );
                    }).toList(),
                    textStyle: TextStyle(
                        fontSize: 12 * textScaleFactor(context),
                        color: Theme.of(context).colorScheme.primary),
                    onSelected: (String? newValue) async {
                      setState(() {
                        _demoFile = newValue!;
                        _setDemoImage(_demoFile);
                      });
                      Navigator.of(context).pop();
                    })
              ]),
              const SizedBox(height: 15),
            ])
          : Container(),
      const SizedBox(height: 5),
      advanced
          ? Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("About"),
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    aboutScreen(this, context);
                  }),
            )
          : Container(),
      const SizedBox(height: 10),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Shutdown"),
              icon: const Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                shutdownDialog(this, context);
              })),
      advanced
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: _scaledText("Save image"),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () {
                        _saveImage();
                      }))
            ])
          : Container(),
      advanced
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: _scaledText("Show server log"),
                      icon: const Icon(Icons.text_snippet_outlined),
                      onPressed: () async {
                        var logs = await _getServerLogs();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) => ServerLogPopUp(this, logs));
                        }
                      })),
            ])
          : Container(),
      advanced && _hasWifiControl && _wifiAccessPointDialog != null
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: _scaledText("Wifi"),
                      icon: const Icon(Icons.wifi),
                      onPressed: () {
                        _wifiAccessPointDialog!(this, context);
                      }))
            ])
          : Container(),
      advanced
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: _scaledText("Reset 'Don't show again'"),
                      icon: const Icon(Icons.undo),
                      onPressed: () async {
                        final request =
                            cedar_rpc.ActionRequest(clearDontShows: true);
                        await initiateAction(request);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }))
            ])
          : Container(),
      const SizedBox(height: 15),
    ];
  }

  Widget _rowOrColumn(bool row, List<Widget> children) {
    return row ? Row(children: children) : Column(children: children);
  }

  Widget focusDoneButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
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

  Widget setupAlignSkipOrDoneButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
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

  Widget slewReAlignButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
          textScaler: textScaler(context),
          "Re-align",
        ),
        onPressed: () {
          _captureBoresight(); // Re-align.
        });
  }

  Widget catalogButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          style: const TextStyle(fontSize: 14),
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

  Widget endGotoButton() {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 0)),
        child: Text(
          style: const TextStyle(fontSize: 14),
          "End goto",
          textScaler: textScaler(context),
        ),
        onPressed: () {
          _stopSlew();
        });
  }

  List<Widget> _controls() {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final color = Theme.of(context).colorScheme.primary;
    return <Widget>[
      // Fake widget to consume changes to preferences and issue RPC to the
      // server.
      Consumer<SettingsModel>(
        builder: (context, settings, child) {
          final newPrefs = settings.preferencesProto;
          var prefsDiff = newPrefs.deepCopy();
          if (preferences != null && diffPreferences(preferences!, prefsDiff)) {
            updatePreferences(prefsDiff);
            if (prefsDiff.hasHideAppBar()) {
              if (prefsDiff.hideAppBar) {
                goFullScreen();
              } else {
                cancelFullScreen();
              }
            }
            if (prefsDiff.hasScreenAlwaysOn()) {
              if (prefsDiff.screenAlwaysOn) {
                setWakeLock(true);
              } else {
                setWakeLock(false);
              }
            }
          }
          final newOpSettings = settings.opSettingsProto;
          var opSettingsDiff = newOpSettings.deepCopy();
          if (diffOperationSettings(operationSettings, opSettingsDiff)) {
            updateOperationSettings(opSettingsDiff);
          }
          return Container();
        },
      ),
      RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: _focusAid
            ? SizedBox(
                width: (portrait ? 120 : 80) * textScaleFactor(context),
                height: 60 * textScaleFactor(context),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _daylightMode
                          ? "Aim at distant object and adjust focus"
                          : "Adjust focus",
                      maxLines: 8,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: color),
                      textScaler: textScaler(context),
                    )))
            : (_canAlign && _slewRequest == null
                ? _daylightMode
                    ? SizedBox(
                        width: (portrait ? 120 : 80) * textScaleFactor(context),
                        height:
                            (portrait ? 60 : 100) * textScaleFactor(context),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Tap image where telescope is pointed",
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: color),
                              textScaler: textScaler(context),
                            )))
                    : _rowOrColumn(portrait, [
                        SizedBox(
                            width: (portrait ? 120 : 80) *
                                textScaleFactor(context),
                            height: (portrait ? 80 : 120) *
                                textScaleFactor(context),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Move telescope to center a highlighted object, then tap on it",
                                  maxLines: 8,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: color),
                                  textScaler: textScaler(context),
                                ))),
                      ])
                : SizedBox(
                    height: (portrait ? 60 : 0) * textScaleFactor(context))),
      ),
      const SizedBox(height: 25),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: SizedBox(
            width: 70 * textScaleFactor(context),
            height: 25 * textScaleFactor(context),
            child: _focusAid
                ? focusDoneButton()
                : (_canAlign
                    ? (_slewRequest == null
                        ? setupAlignSkipOrDoneButton()
                        : (_boresightImageBytes != null
                            ? slewReAlignButton()
                            : Container()))
                    : (_slewRequest == null &&
                            !_setupMode &&
                            _showCatalogBrowser != null
                        ? catalogButton()
                        : Container())),
          )),
      const SizedBox(height: 25),
      _setupMode
          ? RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: TextButton.icon(
                  label: _scaledText("Day"),
                  icon: _daylightMode
                      ? const Icon(Icons.check)
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: () async {
                    setState(() {
                      _setDaylightMode(!_daylightMode);
                    });
                  }))
          : Container(),
      _slewRequest != null && !_setupMode && _showCatalogBrowser != null
          ? RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: SizedBox(
                  width: 70 * textScaleFactor(context),
                  height: 25 * textScaleFactor(context),
                  child: catalogButton()))
          : Container(),
      const SizedBox(height: 25),
      _slewRequest != null
          ? RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: SizedBox(
                  width: 70 * textScaleFactor(context),
                  height: 25 * textScaleFactor(context),
                  child: _slewRequest != null && !_setupMode
                      ? endGotoButton()
                      : Container()))
          : Container(),
    ];
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
    return Text(
      val,
      style: TextStyle(
          color: _solveColor(),
          fontSize: size,
          decoration: underline ? TextDecoration.underline : null),
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

  List<Widget> _raDec() {
    const size = 11.0;
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

  List<Widget> _azAlt() {
    const size = 10.0;
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

  List<Widget> _coordInfo() {
    if (preferences?.celestialCoordChoice ==
            cedar_rpc.CelestialCoordChoice.RA_DEC ||
        locationBasedInfo == null) {
      return _raDec();
    } else {
      return _azAlt();
    }
  }

  Widget _selectIcon(double value, IconData positive, IconData negative) {
    Color color = Theme.of(context).colorScheme.primary;
    return Icon(value > 0 ? positive : negative, color: color);
  }

  List<Widget> _dataItems(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return <Widget>[
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode && !(_focusAid && advanced && !_daylightMode)
              ? SizedBox(
                  width: 50 * textScaleFactor(context),
                  height: 50 * textScaleFactor(context),
                )
              : Column(children: <Widget>[
                  SizedBox(
                    width: 50 * textScaleFactor(context),
                    height: 50 * textScaleFactor(context),
                    child: GestureDetector(
                        onTap: () {
                          perfStatsDialog(this, context);
                        },
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              onAxisTapped: (double value) {
                                perfStatsDialog(this, context);
                              },
                              startAngle: 150,
                              endAngle: 30,
                              showLabels: false,
                              showTicks: false,
                              showAxisLine: false,
                              minimum: 0,
                              maximum: 10,
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  positionFactor: 0.3,
                                  angle: 270,
                                  widget: solveText(sprintf("%d", [numStars])),
                                ),
                                GaugeAnnotation(
                                  positionFactor: 0.4,
                                  angle: 90,
                                  widget: solveText("stars", size: 10),
                                ),
                              ],
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startWidth: 3,
                                    endWidth: 3,
                                    startValue: 0,
                                    endValue: 10,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                                GaugeRange(
                                    startWidth: 3,
                                    endWidth: 3,
                                    startValue: 0,
                                    endValue: math.min(10, math.sqrt(numStars)),
                                    color: _solveColor()),
                              ],
                            )
                          ],
                        )),
                  ),
                ])),
      const SizedBox(width: 10, height: 10),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode
              ? Container()
              : SizedBox(
                  width: 60 * textScaleFactor(context),
                  height: 60 * textScaleFactor(context),
                  child: GestureDetector(
                    onTap: () {
                      skyCoordsDialog(this, context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // RA/Dec, Alt/Az, etc.
                      children: _coordInfo(),
                    ),
                  ))),
      const SizedBox(width: 10, height: 10),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _hasPolarAdvice() && !_setupMode && (isPlus || isDIY)
              ? SizedBox(
                  width: 70 * textScaleFactor(context),
                  height: 60 * textScaleFactor(context),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _primaryText("Eq. Mount", size: 10, underline: true),
                        solveText(
                            _formatAdvice(
                                _polarAlignAdvice!.hasAltitudeCorrection()
                                    ? _polarAlignAdvice!.altitudeCorrection
                                    : _polarAlignAdvice!.azimuthCorrection),
                            size: 10),
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
                )
              : Container()),
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
                Offset localPosition = Offset(
                    details.localPosition.dx * _binFactor,
                    details.localPosition.dy * _binFactor);
                if (_setupMode) {
                  if (!_focusAid) {
                    // Align mode.
                    if (_daylightMode) {
                      await _designateBoresight(localPosition);
                      _alignTargetTapped = true;
                    } else {
                      var star = _findStarHit(localPosition, hitTolerance);
                      if (star != null) {
                        await _designateBoresight(Offset(
                          star.centroidPosition.x,
                          star.centroidPosition.y,
                        ));
                        _alignTargetTapped = true;
                      }
                    }
                  }
                } else {
                  // Aim mode.
                  var object = _findObjectHit(localPosition, hitTolerance);
                  if (object != null && _objectInfoDialog != null) {
                    var selEntry = SelectedCatalogEntry(entry: object.entry);
                    _objectInfoDialog!(this, context, selEntry);
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
              calibrating
                  ? Text("Calibrating",
                      textScaler: textScaler(context),
                      style: TextStyle(
                          fontSize: 20,
                          backgroundColor: Colors.black,
                          color: Theme.of(context).colorScheme.primary))
                  : Container(),
              const SizedBox(height: 15),
              CircularProgressIndicator(
                  value: calibrating ? _calibrationProgress : null,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 15),
              calibrating
                  ? TextButton(
                      onPressed: () {
                        _cancelCalibration();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: _scaledText("Cancel"),
                    )
                  : Container(),
            ]));
  }

  Widget _imageStack(BuildContext context) {
    Widget? overlayWidget;
    if (_setupMode && _focusAid && _centerPeakImageBytes != null) {
      overlayWidget = dart_widgets.Image.memory(_centerPeakImageBytes!,
          height: _imageRegion.width / 6,
          width: _imageRegion.width / 6,
          fit: BoxFit.fill,
          gaplessPlayback: true);
    } else if (!_setupMode && _boresightImageBytes != null) {
      var overlayImage = dart_widgets.Image.memory(_boresightImageBytes!,
          width: _imageRegion.width / 4,
          height: _imageRegion.width / 4,
          fit: BoxFit.fill,
          gaplessPlayback: true);
      overlayWidget = ClipRect(
          child: CustomPaint(
              foregroundPainter: _OverlayImagePainter(this, context,
                  (_imageRegion.width / 4) / _boresightImageWidth, _binFactor),
              child: overlayImage));
    }
    return Stack(alignment: Alignment.topRight, children: <Widget>[
      _prevFrameId != -1
          ? _mainImage()
          : const SizedBox(width: 500, height: 500),
      _prevFrameId != -1 && overlayWidget != null
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5,
                      color: Theme.of(context).colorScheme.primary)),
              child: overlayWidget)
          : Container(),
      _calibrating || _transitionToSetup
          ? Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: _pacifier(context, _calibrating)))
          : Container(),
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

  Widget _orientationLayout(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final controlsColumn = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: portrait ? _controls().reversed.toList() : _controls());

    final controls = controlsColumn;
    final data = Column(children: _dataItems(context));

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
          child: Row(
            children: <Widget>[
              const SizedBox(width: 5, height: 0),
              (portrait || _rightHanded) ? data : controls,
              const SizedBox(width: 5, height: 0),
              _imageStack(context),
              const SizedBox(width: 5, height: 0),
              (portrait || _rightHanded) ? controls : data,
              const SizedBox(width: 5, height: 0),
            ],
          ),
        ));
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
    _scaffoldKey.currentState?.closeEndDrawer();
  }

  Widget _drawer() {
    return _serverConnected
        ? SafeArea(
            child: Drawer(
                width: 240 * textScaleFactor(context),
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: _drawerControls(context))))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final bool healthy = _serverConnected && (_hasCamera || _demoMode);
    if (healthy && _wifiClientDialog != null) {
      _wifiClientDialog!(/*open=*/ false, this, context);
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
          prefs.dontShowWelcome = value;
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
            // _showedAlignIntro = false;
          });
        },
        onDontShowAgainChanged: (value) async {
          var prefs = cedar_rpc.Preferences();
          prefs.dontShowFocusIntro = value;
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
          prefs.dontShowAlignIntro = value;
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
      body: DefaultTextStyle.merge(
          style: const TextStyle(fontFamilyFallback: ["Roboto"]),
          child: SafeArea(
              child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      healthy
                          ? FittedBox(child: _orientationLayout(context))
                          : _badServerState(),
                      Positioned(
                          left: _rightHanded ? null : 0,
                          right: _rightHanded ? 0 : null,
                          top: 0,
                          child: hideAppBar
                              ? IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    if (_rightHanded) {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    } else {
                                      _scaffoldKey.currentState!.openDrawer();
                                    }
                                  })
                              : Container()),
                    ],
                  )))),
      // Prevent jank in demo mode image file selector.
      onEndDrawerChanged: (isOpened) {
        _inhibitRefresh = isOpened;
      },
      onDrawerChanged: (isOpened) {
        _inhibitRefresh = isOpened;
      },
      drawer: _drawer(),
      endDrawer: _drawer(),
      drawerEdgeDragWidth: 100,
    );
  }

  Widget _badServerState() {
    _paintPending = false;
    // Give some time for an initial connection to succeed.
    final elapsed = DateTime.now().difference(_startTime);
    if (elapsed.inMilliseconds < 1000) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isMobile() && !_serverConnected && _wifiClientDialog != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _wifiClientDialog!(/*open=*/ true, this, context);
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
