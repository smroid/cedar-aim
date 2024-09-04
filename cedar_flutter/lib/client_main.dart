// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:developer';
import 'dart:math' as math;
import 'package:cedar_flutter/cedar_sky.pb.dart';
import 'package:cedar_flutter/draw_slew_target.dart';
import 'package:cedar_flutter/draw_util.dart';
import 'package:cedar_flutter/geolocation.dart';
import 'package:cedar_flutter/google/protobuf/timestamp.pb.dart';
import 'package:cedar_flutter/perf_stats_dialog.dart';
import 'package:cedar_flutter/server_log.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:cedar_flutter/themes.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' as dart_widgets;
import 'package:grpc/service_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:protobuf/protobuf.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'tetra3.pb.dart';
import 'google/protobuf/duration.pb.dart' as proto_duration;
import 'get_cedar_client_for_web.dart'
    if (dart.library.io) 'get_cedar_client.dart';

// To generate release build: flutter build web

typedef DrawCatalogEntriesFunction = void Function(BuildContext, Canvas, Color,
    List<cedar_rpc.FovCatalogEntry>, bool, int, bool);

typedef ShowCatalogBrowserFunction = void Function(
    BuildContext, MyHomePageState);

typedef ObjectInfoDialogFunction = void Function(
    MyHomePageState, BuildContext, SelectedCatalogEntry);

DrawCatalogEntriesFunction? _drawCatalogEntries;
ShowCatalogBrowserFunction? _showCatalogBrowser;
ObjectInfoDialogFunction? _objectInfoDialog;

void clientMain(
    DrawCatalogEntriesFunction? drawCatalogEntries,
    ShowCatalogBrowserFunction? showCatalogBrowser,
    ObjectInfoDialogFunction? objectInfoDialog) {
  _drawCatalogEntries = drawCatalogEntries;
  _showCatalogBrowser = showCatalogBrowser;
  _objectInfoDialog = objectInfoDialog;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    // Note that this has no effect when running as web app; it only works for
    // Android app. Not sure if it works for IOS app.
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  ).then(
    (_) => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: const MyApp(),
    )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cedar Aim',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: const MyHomePage(title: 'Cedar Aim'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

double _durationToMs(proto_duration.Duration duration) {
  return duration.seconds.toDouble() * 1000 +
      (duration.nanos.toDouble()) / 1000000;
}

proto_duration.Duration _msToDuration(int ms) {
  var duration = proto_duration.Duration();
  duration.seconds = Int64(ms ~/ 1000);
  duration.nanos = (ms * 1000000) % 1000000000;
  return duration;
}

double _deg2rad(double deg) {
  return deg / 180.0 * math.pi;
}

class _MainImagePainter extends CustomPainter {
  final MyHomePageState state;
  final BuildContext _context;

  _MainImagePainter(this.state, this._context);

  @override
  void paint(Canvas canvas, Size size) {
    const double hairline = 0.5;
    const double thin = 1;
    final Color color = Theme.of(_context).colorScheme.primary;
    if (state._setupMode &&
        !state._daylightMode &&
        state._centerRegion != null) {
      // Draw search box within which we search for the brightest star for
      // focusing.
      canvas.drawRect(
          state._centerRegion as Rect,
          Paint()
            ..color = color
            ..strokeWidth = thin
            ..style = PaintingStyle.stroke);
      // Draw box around location of the brightest star in search box.
      canvas.drawRect(
          state._centerPeakRegion as Rect,
          Paint()
            ..color = color
            ..strokeWidth = thin
            ..style = PaintingStyle.stroke);
      // Draw circles around the detected stars.
      if (state._focusAid && state._advanced) {
        for (var star in state._stars) {
          var offset = Offset(star.centroidPosition.x / state._binFactor,
              star.centroidPosition.y / state._binFactor);
          canvas.drawCircle(
              offset,
              3,
              Paint()
                ..color = color
                ..strokeWidth = hairline
                ..style = PaintingStyle.stroke);
        }
      }
    }

    final portrait =
        MediaQuery.of(_context).orientation == Orientation.portrait;

    // How many display pixels is the telescope FOV?
    var scopeFov = 0.0;
    if (!state._setupMode && state._hasSolution) {
      scopeFov = state.preferences!.eyepieceFov *
          state._imageRegion.width /
          state._solutionFOV;
    }
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
          scopeFov,
          /*rollAngleRad=*/ _deg2rad(state.bullseyeDirectionIndicator()),
          posInImage,
          slew.targetDistance,
          slew.targetAngle,
          /*drawDistanceText=*/ true,
          portrait);
      drawSlewDirections(
          state,
          slew.target,
          slew.targetCatalogEntry,
          canvas,
          color,
          slew.targetAngle >= 0.0 &&
                  slew.targetAngle <= 90.0 &&
                  slew.targetDistance > 0.5
              ? Offset(20, state._imageRegion.height - 220)
              : const Offset(20, 20),
          state.preferences?.mountType == cedar_rpc.MountType.ALT_AZ,
          state._northernHemisphere,
          slew.offsetRotationAxis,
          slew.offsetTiltAxis,
          portrait);
    } else {
      // Make a cross at the boresight position (if any) or else the image
      // center.
      if (state._setupMode || !state._hasSolution) {
        var bsPos = state._boresightPosition;
        if (state._daylightMode) {
          // Compute boresight position within the zoomed image.
          bsPos = Offset(
            state._fullResBoresightPosition.dx - state._fullResImageRegion.left,
            state._fullResBoresightPosition.dy - state._fullResImageRegion.top,
          );
        }
        drawGapCross(canvas, color, bsPos, /*radius=*/ 8, /*gapRadius=*/ 2,
            /*rollAngleRad=*/ 0.0, thin, thin);
      } else {
        var rollAngleRad = _deg2rad(state.bullseyeDirectionIndicator());
        drawBullseye(canvas, color, state._boresightPosition, scopeFov / 2,
            rollAngleRad);
      }
    }
    if (!state._setupMode &&
        state._labeledFovCatalogEntries.isNotEmpty &&
        state._slewRequest == null &&
        _drawCatalogEntries != null) {
      _drawCatalogEntries!(
          _context,
          canvas,
          color,
          state._labeledFovCatalogEntries,
          /*drawLabel=*/ true,
          state._binFactor,
          portrait);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _OverlayImagePainter extends CustomPainter {
  final MyHomePageState _state;
  final BuildContext _context;
  final double _scale;

  _OverlayImagePainter(this._state, this._context, this._scale);

  @override
  void paint(Canvas canvas, Size size) {
    final Color color = Theme.of(_context).colorScheme.primary;
    Offset overlayCenter = Offset(size.width / 2, size.height / 2);

    var slew = _state._slewRequest;
    Offset? posInImage;
    if (slew!.hasImagePos()) {
      posInImage = Offset(
          overlayCenter.dx +
              _scale * (slew.imagePos.x - _state._fullResBoresightPosition.dx),
          overlayCenter.dy +
              _scale * (slew.imagePos.y - _state._fullResBoresightPosition.dy));
    }
    // How many display pixels is the telescope FOV?
    final scopeFov = _scale *
        _state.preferences!.eyepieceFov *
        _state._fullResImageRegion.width /
        _state._solutionFOV;
    final portrait =
        MediaQuery.of(_context).orientation == Orientation.portrait;
    drawSlewTarget(
        _context,
        canvas,
        color,
        overlayCenter,
        scopeFov,
        /*rollAngleRad=*/ _deg2rad(_state.bullseyeDirectionIndicator()),
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
    refreshStateFromServer();
  }

  // Geolocation from map.
  LatLng? _mapPosition;
  bool _northernHemisphere = true;

  Duration _tzOffset = const Duration();

  int _skipCount = 0;

  // Information from most recent FrameResult.

  // Image data, binned by server.
  Uint8List _imageBytes = Uint8List(1);
  late Rect _imageRegion; // Scaled by _binFactor.
  late Rect _fullResImageRegion;
  int _binFactor = 1;

  cedar_rpc.ServerInformation? _serverInformation;
  var operationSettings = cedar_rpc.OperationSettings();
  bool _setupMode = false;
  bool _focusAid = false;
  bool _daylightMode = false;
  bool _advanced = false;
  bool _canAlign = false;
  bool _hasCedarSky = false;

  int _accuracy = 2; // 1-3.

  Offset _boresightPosition =
      const Offset(0, 0); // Scaled by main image's binning.
  Offset _fullResBoresightPosition = const Offset(0, 0);

  Rect? _centerRegion; // Scaled by main image's binning.
  Rect? _centerPeakRegion; // Scaled by binning.

  int _centerPeakWidth = 0;
  int _centerPeakHeight = 0;
  Uint8List? _centerPeakImageBytes;

  int _boresightImageWidth = 0;
  int _boresightImageHeight = 0;
  Uint8List? _boresightImageBytes;

  int _prevFrameId = -1;
  late List<cedar_rpc.StarCentroid> _stars;
  int _numStars = 0;
  var exposureTimeMs = 0.0;
  int _maxExposureTimeMs = 0;
  bool _hasSolution = false;

  List<MatchedStar>? _solutionMatches;
  List<Offset>? _solutionCentroids;
  // Degrees.
  double _solutionRA = 0.0;
  double _solutionDec = 0.0;
  double _solutionRollAngle = 0.0; // Degrees.
  double _solutionFOV = 0.0; // Degrees.

  // Arcsec.
  double solutionRMSE = 0.0;

  cedar_rpc.LocationBasedInfo? _locationBasedInfo;

  cedar_rpc.CalibrationData? _calibrationData;
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
  // so if the update rate setting is e.g.1 Hz. We put up a pacifier for this;
  // define a flag so we can know when it is done.
  bool _transitionToSetup = false;

  // Values set from on-screen controls.
  bool doRefreshes = true;
  int _expSettingMs = 0; // 0 is auto-exposure.

  cedar_rpc.CedarClient? _client;
  cedar_rpc.CedarClient client() {
    _client ??= getClient(); // Initialize if null.
    return _client!;
  }

  LatLng? get mapPosition => _mapPosition;
  set mapPosition(LatLng? newPos) {
    setState(() {
      _mapPosition = newPos;
      if (newPos != null) {
        setObserverLocation(newPos);
      }
    });
  }

  Duration get tzOffset => _tzOffset;

  void setStateFromFrameResult(cedar_rpc.FrameResult response) {
    _prevFrameId = response.frameId;
    _stars = response.starCandidates;
    _numStars = _stars.length;
    _maxExposureTimeMs =
        _durationToMs(response.fixedSettings.maxExposureTime).toInt();
    if (response.fixedSettings.hasObserverLocation()) {
      _mapPosition = LatLng(response.fixedSettings.observerLocation.latitude,
          response.fixedSettings.observerLocation.longitude);
      _northernHemisphere = _mapPosition!.latitude > 0.0;
    } else if (_mapPosition != null) {
      setObserverLocation(_mapPosition!);
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
    _serverInformation = response.serverInformation;
    _hasCedarSky =
        _serverInformation!.featureLevel != cedar_rpc.FeatureLevel.DIY;

    operationSettings = response.operationSettings;
    _accuracy = operationSettings.accuracy.value;
    _expSettingMs = _durationToMs(operationSettings.exposureTime).toInt();
    _setupMode =
        operationSettings.operatingMode == cedar_rpc.OperatingMode.SETUP;
    _daylightMode = operationSettings.daylightMode;
    if (_daylightMode) {
      _focusAid = false;
    }
    if (_setupMode) {
      _transitionToSetup = false;
    }

    _canAlign = false;
    if (_setupMode) {
      _canAlign = true;
    }
    preferences = response.preferences;
    _polarAlignAdvice = response.polarAlignAdvice;
    _labeledFovCatalogEntries = response.labeledCatalogEntries;
    _unlabeledFovCatalogEntries = response.unlabeledCatalogEntries;
    var settingsModel = Provider.of<SettingsModel>(context, listen: false);
    settingsModel.preferencesProto = preferences!.deepCopy();
    settingsModel.opSettingsProto = operationSettings.deepCopy();
    _advanced = preferences!.advanced;
    _calibrationData =
        response.hasCalibrationData() ? response.calibrationData : null;
    processingStats =
        response.hasProcessingStats() ? response.processingStats : null;
    _slewRequest = response.hasSlewRequest() ? response.slewRequest : null;
    if (_slewRequest != null && _slewRequest!.targetWithinCenterRegion) {
      _canAlign = true;
    }
    if (response.hasPlateSolution()) {
      SolveResult plateSolution = response.plateSolution;
      if (plateSolution.status == SolveStatus.MATCH_FOUND) {
        _hasSolution = true;
        _solutionMatches = plateSolution.matchedStars;
        _solutionCentroids = <Offset>[];
        for (var centroid in plateSolution.patternCentroids) {
          _solutionCentroids!.add(Offset(centroid.x, centroid.y));
        }
        if (plateSolution.targetCoords.isNotEmpty) {
          _solutionRA = plateSolution.targetCoords.first.ra;
          _solutionDec = plateSolution.targetCoords.first.dec;
        } else {
          _solutionRA = plateSolution.imageCenterCoords.ra;
          _solutionDec = plateSolution.imageCenterCoords.dec;
        }
        _solutionRollAngle = plateSolution.roll;
        solutionRMSE = plateSolution.rmse;
        _solutionFOV = plateSolution.fov;
        if (response.hasLocationBasedInfo()) {
          _locationBasedInfo = response.locationBasedInfo;
        }
      }
    }
    if (response.hasImage()) {
      _imageBytes = Uint8List.fromList(response.image.imageData);
      _binFactor = response.image.binningFactor;
      _imageRegion = Rect.fromLTWH(
          response.image.rectangle.originX.toDouble() / _binFactor,
          response.image.rectangle.originY.toDouble() / _binFactor,
          response.image.rectangle.width.toDouble() / _binFactor,
          response.image.rectangle.height.toDouble() / _binFactor);
      _fullResImageRegion = Rect.fromLTWH(
          response.image.rectangle.originX.toDouble(),
          response.image.rectangle.originY.toDouble(),
          response.image.rectangle.width.toDouble(),
          response.image.rectangle.height.toDouble());
    }
    _boresightPosition = Offset(response.boresightPosition.x / _binFactor,
        response.boresightPosition.y / _binFactor);
    _fullResBoresightPosition =
        Offset(response.boresightPosition.x, response.boresightPosition.y);
    if (response.hasCenterRegion()) {
      var cr = response.centerRegion;
      _centerRegion = Rect.fromLTWH(
          cr.originX.toDouble() / _binFactor,
          cr.originY.toDouble() / _binFactor,
          cr.width.toDouble() / _binFactor,
          cr.height.toDouble() / _binFactor);
    }
    if (response.hasExposureTime()) {
      exposureTimeMs = _durationToMs(response.exposureTime);
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
      _boresightImageHeight = response.boresightImage.rectangle.height;
    }
    if (response.hasCenterPeakPosition()) {
      var cp = response.centerPeakPosition;
      _centerPeakRegion = Rect.fromCenter(
          center: Offset(cp.x / _binFactor, cp.y / _binFactor),
          width: _centerPeakWidth.toDouble() / _binFactor,
          height: _centerPeakHeight.toDouble() / _binFactor);
    }
  }

  double bullseyeDirectionIndicator() {
    if (preferences?.mountType == cedar_rpc.MountType.ALT_AZ &&
        _locationBasedInfo != null) {
      return _locationBasedInfo!.zenithRollAngle;
    } else {
      return _solutionRollAngle; // Direction towards north.
    }
  }

  Future<void> updateFixedSettings(cedar_rpc.FixedSettings request) async {
    try {
      await client().updateFixedSettings(request,
          options: CallOptions(timeout: const Duration(seconds: 10)));
    } catch (e) {
      log('updateFixedSettings error: $e');
    }
  }

  Future<void> updateOperationSettings(
      cedar_rpc.OperationSettings request) async {
    try {
      await client().updateOperationSettings(request,
          options: CallOptions(timeout: const Duration(seconds: 10)));
    } catch (e) {
      log('updateOperationSettings error: $e');
    }
  }

  // Use request/response style of RPC.
  Future<void> getFrameFromServer() async {
    final request = cedar_rpc.FrameRequest()..prevFrameId = _prevFrameId;
    try {
      final response = await client().getFrame(request,
          options: CallOptions(timeout: const Duration(seconds: 10)));
      if (_skipCount > 0) {
        --_skipCount;
      } else {
        setState(() {
          setStateFromFrameResult(response);
        });
      }
    } catch (e) {
      log('getFrameFromServer error: $e');
    }
  }

  // Issue repeated request/response RPCs.
  Future<void> refreshStateFromServer() async {
    // See if we can get location from the platform. If we are a web app, served
    // over http (not https), we won't be able to get location here.
    var platformPosition = await getLocation();
    if (platformPosition != null) {
      _mapPosition =
          LatLng(platformPosition.latitude, platformPosition.longitude);
    }

    // Get platform time.
    final now = DateTime.now();
    _tzOffset = now.timeZoneOffset;
    setServerTime(now);

    await Future.doWhile(() async {
      var delay = 50;
      if (_setupMode && !_calibrating && doRefreshes) {
        delay = 10; // Fast updates for focusing.
      }
      await Future.delayed(Duration(milliseconds: delay));
      if (doRefreshes) {
        await getFrameFromServer();
      }
      return true; // Forever!
    });
  }

  Future<void> initiateAction(cedar_rpc.ActionRequest request) async {
    try {
      await client().initiateAction(request,
          options: CallOptions(timeout: const Duration(seconds: 10)));
    } catch (e) {
      log('initiateAction error: $e');
    }
  }

  Future<void> setServerTime(DateTime now) async {
    Timestamp ts = Timestamp();
    ts.seconds = Int64(now.millisecondsSinceEpoch ~/ 1000.0);
    ts.nanos = (now.millisecondsSinceEpoch % 1000) * 1000000;
    var request = cedar_rpc.FixedSettings();
    request.currentTime = ts;
    await updateFixedSettings(request);
  }

  Future<void> setObserverLocation(LatLng pos) async {
    cedar_rpc.LatLong posProto = cedar_rpc.LatLong();
    posProto.latitude = pos.latitude;
    posProto.longitude = pos.longitude;
    var request = cedar_rpc.FixedSettings();
    request.observerLocation = posProto;
    await updateFixedSettings(request);
  }

  Future<void> setExpTime() async {
    var request = cedar_rpc.OperationSettings();
    request.exposureTime = _msToDuration(_expSettingMs);
    await updateOperationSettings(request);
  }

  Future<void> captureBoresight() async {
    var request = cedar_rpc.ActionRequest();
    request.captureBoresight = true;
    await initiateAction(request);
  }

  Future<void> designateBoresight(Offset pos) async {
    final coord = cedar_rpc.ImageCoord(x: pos.dx, y: pos.dy);
    var request = cedar_rpc.ActionRequest();
    request.designateBoresight = coord;
    await initiateAction(request);
  }

  Future<void> stopSlew() async {
    var request = cedar_rpc.ActionRequest();
    request.stopSlew = true;
    await initiateAction(request);
  }

  Future<void> setOperatingMode(bool setup) async {
    var request = cedar_rpc.OperationSettings();
    request.operatingMode =
        setup ? cedar_rpc.OperatingMode.SETUP : cedar_rpc.OperatingMode.OPERATE;
    await updateOperationSettings(request);
  }

  Future<void> setAccuracy(int value) async {
    var request = cedar_rpc.OperationSettings();
    request.accuracy = cedar_rpc.Accuracy.valueOf(value)!;
    await updateOperationSettings(request);
  }

  Future<void> setDaylightMode(bool value) async {
    var request = cedar_rpc.OperationSettings();
    request.daylightMode = value;
    await updateOperationSettings(request);
  }

  Future<String> getServerLogs() async {
    var request = cedar_rpc.ServerLogRequest();
    request.logRequest = 20000;
    try {
      var infoResult = await client().getServerLog(request,
          options: CallOptions(timeout: const Duration(seconds: 10)));
      return infoResult.logContent;
    } catch (e) {
      log('getServerLogs error: $e');
      return "";
    }
  }

  void shutdownDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Shutdown Raspberry Pi?',
            textScaler: textScaler(context),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(
                  'Cancel',
                  textScaler: textScaler(context),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text(
                  'Shutdown',
                  textScaler: textScaler(context),
                ),
                onPressed: () {
                  shutdown();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }

  Future<void> shutdown() async {
    var request = cedar_rpc.ActionRequest();
    request.shutdownServer = true;
    await initiateAction(request);
  }

  Future<void> saveImage() async {
    var request = cedar_rpc.ActionRequest();
    request.saveImage = true;
    await initiateAction(request);
  }

  Future<void> cancelCalibration() async {
    await setOperatingMode(/*setup=*/ true);
  }

  Future<void> updatePreferences(cedar_rpc.Preferences changedPrefs) async {
    try {
      final newPrefs = await client().updatePreferences(changedPrefs,
          options: CallOptions(timeout: const Duration(seconds: 10)));
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
      log('updatePreferences error: $e');
    }
  }

  List<Widget> drawerControls(BuildContext context) {
    return <Widget>[
      CloseButton(
          style: ButtonStyle(
              alignment: Alignment.topLeft,
              iconColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary))),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: Text(
                "Preferences",
                textScaler: textScaler(context),
              ),
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()))
                    .then((value) {
                  setState(() {}); // Force rebuild of the drawer.
                });
              })),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _mapPosition == null
                  ? Text(
                      "Location unknown",
                      textScaler: textScaler(context),
                    )
                  : Text(
                      sprintf("Location %.1f %.1f",
                          [_mapPosition!.latitude, _mapPosition!.longitude]),
                      textScaler: textScaler(context),
                    ),
              icon: Icon(_mapPosition == null
                  ? Icons.not_listed_location
                  : Icons.edit_location_alt),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapScreen(this)));
              })),
      const SizedBox(height: 15),
      Column(children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(width: 10),
              Checkbox(
                value: _advanced,
                onChanged: (bool? selected) async {
                  _advanced = selected!;
                  var settingsModel =
                      Provider.of<SettingsModel>(context, listen: false);
                  settingsModel.preferencesProto.advanced = _advanced;
                  var prefs = cedar_rpc.Preferences();
                  prefs.advanced = _advanced;
                  await updatePreferences(prefs);
                },
                activeColor: Theme.of(context).colorScheme.surface,
                checkColor: Theme.of(context).colorScheme.primary,
              ),
              Text(
                "Advanced",
                textScaler: textScaler(context),
              ),
            ]))
      ]),
      _advanced
          ? Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
                  Text(
                    "Fast               Accurate",
                    textScaler: textScaler(context),
                  ),
                  SizedBox(
                      width: 180 * textScaleFactor(context),
                      height: 25,
                      child: Slider(
                        min: 1,
                        max: 3,
                        value: _accuracy.toDouble(),
                        onChanged: (double value) => {
                          setState(() {
                            _accuracy = value.toInt();
                            setAccuracy(value.toInt());
                          })
                        },
                      )),
                  Text(
                    sprintf("exposure: %.1f ms", [exposureTimeMs]),
                    textScaler: textScaler(context),
                  ),
                  const SizedBox(height: 15),
                ],
              ))
          : Container(),
      _advanced
          ? Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                Container(width: 20),
                Column(children: <Widget>[
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 140 * textScaleFactor(context),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2)),
                          child: Text(
                            "Save image",
                            textScaler: textScaler(context),
                          ),
                          onPressed: () {
                            saveImage();
                          })),
                ]),
              ]))
          : Container(),
      _advanced
          ? Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                Container(width: 20),
                Column(children: <Widget>[
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 140 * textScaleFactor(context),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2)),
                          child: Text(
                            "Show server log",
                            textScaler: textScaler(context),
                          ),
                          onPressed: () async {
                            var logs = await getServerLogs();
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => ServerLogPopUp(logs));
                            }
                          })),
                ])
              ]))
          : Container(),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: Row(children: [
            Container(width: 20),
            Column(children: <Widget>[
              SizedBox(
                  width: 140 * textScaleFactor(context),
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 2)),
                      child: Text(
                        "Shutdown",
                        textScaler: textScaler(context),
                      ),
                      onPressed: () {
                        shutdownDialog();
                      })),
            ]),
          ]))
    ];
  }

  List<Widget> controls() {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
        .preferencesProto
        .hideAppBar;
    return <Widget>[
      // Fake widget to consume changes to preferences and issue RPC to the
      // server.
      Consumer<SettingsModel>(
        builder: (context, settings, child) {
          final newPrefs = settings.preferencesProto;
          var prefsDiff = newPrefs.deepCopy();
          if (preferences != null && diffPreferences(preferences!, prefsDiff)) {
            updatePreferences(prefsDiff);
          }
          final newOpSettings = settings.opSettingsProto;
          var opSettingsDiff = newOpSettings.deepCopy();
          if (diffOperationSettings(operationSettings, opSettingsDiff)) {
            updateOperationSettings(opSettingsDiff);
          }
          return Container();
        },
      ),
      portrait && hideAppBar
          ? const SizedBox(width: 0, height: 40)
          : Container(),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: Column(children: <Widget>[
            primaryText("Setup  Aim"),
            Switch(
                activeTrackColor: Theme.of(context).colorScheme.surface,
                activeColor: Theme.of(context).colorScheme.primary,
                trackOutlineColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                thumbColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ),
                value: !_setupMode,
                onChanged: (bool value) {
                  if (!value) {
                    _transitionToSetup = true;
                  }
                  setOperatingMode(/*setup=*/ !value);
                }),
          ])),
      const SizedBox(width: 0, height: 15),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: SizedBox(
            width: 70 * textScaleFactor(context),
            height: 32,
            child: _canAlign && !_daylightMode
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 0)),
                    child: Text(
                      style: const TextStyle(fontSize: 12),
                      "Set Align",
                      textScaler: textScaler(context),
                    ),
                    onPressed: () {
                      captureBoresight();
                    })
                : (_slewRequest == null &&
                        !_setupMode &&
                        _hasCedarSky &&
                        _showCatalogBrowser != null
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0)),
                        child: Text(
                          style: const TextStyle(fontSize: 12),
                          "Catalog",
                          textScaler: textScaler(context),
                        ),
                        onPressed: () {
                          _showCatalogBrowser!(context, this);
                        })
                    : Container()),
          )),
      const SizedBox(width: 0, height: 15),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: SizedBox(
              width: 70 * textScaleFactor(context),
              height: 32,
              child: _slewRequest != null && !_setupMode
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 0)),
                      child: Text(
                        style: const TextStyle(fontSize: 12),
                        "End goto",
                        textScaler: textScaler(context),
                      ),
                      onPressed: () {
                        stopSlew();
                      })
                  : Container())),
    ];
  }

  String formatRightAscension(double ra, {bool short = false}) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.4f°", [ra]);
    }
    int hours = (ra / 15.0).floor();
    double fracHours = ra / 15.0 - hours;
    int minutes = (fracHours * 60.0).floor();
    double fracMinutes = fracHours * 60.0 - minutes;
    int seconds = (fracMinutes * 60).round();
    return short
        ? sprintf("%02d:%02d", [hours, minutes])
        : sprintf("%02d:%02d:%02d", [hours, minutes, seconds]);
  }

  String formatHourAngle(double ha) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.4f°", [ha]);
    }
    String sign = ha < 0 ? "-" : "+";
    if (ha < 0) {
      ha = -ha;
    }
    int hours = (ha / 15.0).floor();
    double fracHours = ha / 15.0 - hours;
    int minutes = (fracHours * 60.0).floor();
    double fracMinutes = fracHours * 60.0 - minutes;
    int seconds = (fracMinutes * 60).round();
    return sprintf("%s%02d:%02d:%02d", [sign, hours, minutes, seconds]);
  }

  String formatDeclination(double dec, {bool short = false}) {
    if (preferences?.celestialCoordFormat ==
        cedar_rpc.CelestialCoordFormat.DECIMAL) {
      return sprintf("%.4f°", [dec]);
    }
    String sign = dec < 0 ? "-" : "+";
    if (dec < 0) {
      dec = -dec;
    }
    int degrees = dec.floor();
    double fracDegrees = dec - degrees;
    int minutes = (fracDegrees * 60.0).floor();
    double fracMinutes = fracDegrees * 60.0 - minutes;
    int seconds = (fracMinutes * 60).round();
    return short
        ? sprintf("%s%02d:%02d", [sign, degrees, minutes])
        : sprintf("%s%02d:%02d:%02d", [sign, degrees, minutes, seconds]);
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

  String formatAdvice(cedar_rpc.ErrorBoundedValue? ebv) {
    return sprintf("%.2f±%.2f", [ebv!.value, ebv.error]);
  }

  Color starsSliderColor() {
    return _hasSolution
        ? Theme.of(context).colorScheme.primary
        : const Color(0xff606060);
  }

  Color solveTextColor() {
    return _hasSolution
        ? Theme.of(context).colorScheme.primary
        : const Color(0xff606060);
  }

  Text primaryText(String val) {
    return Text(
      val,
      style:
          TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
      textScaler: textScaler(context),
    );
  }

  Text solveText(String val, {double? size = 12}) {
    return Text(
      val,
      style: TextStyle(color: solveTextColor(), fontSize: size),
      textScaler: textScaler(context),
    );
  }

  bool hasPolarAdvice() {
    if (_polarAlignAdvice == null) {
      return false;
    }
    return _polarAlignAdvice!.hasAltitudeCorrection() ||
        _polarAlignAdvice!.hasAzimuthCorrection();
  }

  List<Widget> raDec(int width) {
    return [
      SizedBox(
          width: width * textScaleFactor(context),
          height: 14 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("RA"),
                solveText(formatRightAscension(_solutionRA))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 14 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("Dec"),
                solveText(formatDeclination(_solutionDec))
              ]))
    ];
  }

  List<Widget> azAlt(int width) {
    return [
      SizedBox(
          width: width * textScaleFactor(context),
          height: 14 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("Az"),
                solveText(formatAzimuth(_locationBasedInfo!.azimuth))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 14 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("Alt"),
                solveText(formatAltitude(_locationBasedInfo!.altitude))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 14 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("HA"),
                solveText(formatHourAngle(_locationBasedInfo!.hourAngle))
              ])),
    ];
  }

  List<Widget> coordInfo(bool mountAltAz, int width) {
    if (mountAltAz && _locationBasedInfo != null) {
      return azAlt(width) + [const SizedBox(height: 10)] + raDec(width);
    } else {
      if (_locationBasedInfo == null) {
        return raDec(width);
      } else {
        return raDec(width) + [const SizedBox(height: 10)] + azAlt(width);
      }
    }
  }

  List<Widget> dataItems(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return <Widget>[
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode && !(_focusAid && _advanced)
              ? const SizedBox(height: 75)
              : Column(children: <Widget>[
                  SizedBox(
                    width: 75,
                    height: 75,
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
                                  widget: solveText(sprintf("%d", [_numStars])),
                                ),
                                GaugeAnnotation(
                                  positionFactor: 0.4,
                                  angle: 90,
                                  widget: solveText("stars", size: 12),
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
                                    endValue:
                                        math.min(10, math.sqrt(_numStars)),
                                    color: starsSliderColor()),
                              ],
                            )
                          ],
                        )),
                  ),
                  // const SizedBox(width: 15, height: 15),
                  // TODO: move calibration data elsewhere, make more comprehensive
                  // _calibrationData != null &&
                  //         _calibrationData!.fovHorizontal > 0
                  //     ? Column(children: <Widget>[
                  //         primaryText(sprintf(
                  //             "FOV %.1f°", [_calibrationData!.fovHorizontal])),
                  //         primaryText(sprintf(
                  //             "Lens %.1f mm", [_calibrationData!.lensFlMm])),
                  //       ])
                  //     : Container(),
                ])),
      const SizedBox(width: 10, height: 10),
      RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: _setupMode
            ? SizedBox(
                width: 100 * textScaleFactor(context),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Checkbox(
                    value: _focusAid,
                    onChanged: _daylightMode
                        ? null
                        : (bool? selected) {
                            _focusAid = selected!;
                          },
                    activeColor: Theme.of(context).colorScheme.surface,
                    checkColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    "Focus aid",
                    textScaler: textScaler(context),
                  ),
                ]))
            : Container(),
      ),
      const SizedBox(width: 10, height: 10),
      RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: _setupMode
            ? SizedBox(
                width: 100 * textScaleFactor(context),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Checkbox(
                    value: _daylightMode,
                    onChanged: (bool? selected) {
                      _skipCount = 2;
                      setDaylightMode(selected!);
                    },
                    activeColor: Theme.of(context).colorScheme.surface,
                    checkColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    "Zoom",
                    textScaler: textScaler(context),
                  ),
                ]))
            : Container(),
      ),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode
              ? Container()
              : SizedBox(
                  width: 90 * textScaleFactor(context),
                  height: 85 * textScaleFactor(context),
                  child: Column(
                    children: coordInfo(
                        preferences?.mountType == cedar_rpc.MountType.ALT_AZ,
                        /*width=*/ 85),
                  ),
                )),
      const SizedBox(width: 15, height: 15),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: !hasPolarAdvice() || _setupMode
              ? Container()
              : SizedBox(
                  width: 140,
                  height: 120,
                  child: Column(children: <Widget>[
                    primaryText("Polar Align"),
                    _polarAlignAdvice!.hasAltitudeCorrection()
                        ? solveText(sprintf("alt %s", [
                            sprintf("%s\npolar axis->%s", [
                              formatAdvice(
                                  _polarAlignAdvice!.altitudeCorrection),
                              _polarAlignAdvice!.altitudeCorrection.value > 0
                                  ? "up"
                                  : "down"
                            ])
                          ]))
                        : Container(),
                    _polarAlignAdvice!.hasAzimuthCorrection()
                        ? solveText(sprintf("az %s", [
                            sprintf("%s\npolar axis->%s", [
                              formatAdvice(
                                  _polarAlignAdvice!.azimuthCorrection),
                              _polarAlignAdvice!.azimuthCorrection.value > 0
                                  ? "right"
                                  : "left"
                            ])
                          ]))
                        : Container(),
                  ]),
                )),
    ];
  }

  Widget mainImage() {
    return ClipRect(
        child: CustomPaint(
            foregroundPainter: _MainImagePainter(this, context),
            child: GestureDetector(
              child:
                  dart_widgets.Image.memory(_imageBytes, gaplessPlayback: true),
              onTapDown: (TapDownDetails details) async {
                Offset localPosition = Offset(
                    details.localPosition.dx * _binFactor,
                    details.localPosition.dy * _binFactor);
                if (_daylightMode) {
                  designateBoresight(localPosition);
                } else {
                  var object = _findObjectHit(localPosition, 30);
                  if (object != null && _objectInfoDialog != null) {
                    var selEntry = SelectedCatalogEntry(entry: object.entry);
                    _objectInfoDialog!(this, context, selEntry);
                  }
                }
              },
            )));
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
    if (closest != null && closestDistance < tolerance) {
      return closest;
    }
    return null;
  }

  Widget pacifier(BuildContext context, bool calibrating) {
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
                        cancelCalibration();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary),
                      child: Text(
                        'Cancel',
                        textScaler: textScaler(context),
                      ),
                    )
                  : Container(),
            ]));
  }

  Widget imageStack(BuildContext context) {
    Widget? overlayWidget;
    if (_setupMode && _focusAid && _centerPeakImageBytes != null) {
      overlayWidget = dart_widgets.Image.memory(_centerPeakImageBytes!,
          height: _imageRegion.width / 6,
          width: _imageRegion.width / 6,
          fit: BoxFit.fill,
          gaplessPlayback: true);
    } else if (!_setupMode && _boresightImageBytes != null) {
      var overlayImage = dart_widgets.Image.memory(_boresightImageBytes!,
          height: _imageRegion.width / 4,
          width: _imageRegion.width / 4,
          fit: BoxFit.fill,
          gaplessPlayback: true);
      overlayWidget = ClipRect(
          child: CustomPaint(
              foregroundPainter: _OverlayImagePainter(this, context,
                  (_imageRegion.width / 4) / _boresightImageWidth),
              child: overlayImage));
    }
    return Stack(alignment: Alignment.topRight, children: <Widget>[
      _prevFrameId != -1 ? mainImage() : Container(),
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
                  child: pacifier(context, _calibrating)))
          : Container(),
    ]);
  }

  Widget orientationLayout(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return RotatedBox(
      quarterTurns: portrait ? 1 : 0,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5, height: 0),
          Column(
              children: portrait ? controls().reversed.toList() : controls()),
          const SizedBox(width: 5, height: 0),
          imageStack(context),
          const SizedBox(width: 0, height: 0),
          Column(children: dataItems(context)),
          const SizedBox(width: 5, height: 0),
        ],
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
        .preferencesProto
        .hideAppBar;
    if (hideAppBar) {
      goFullScreen();
    } else {
      cancelFullScreen();
    }

    // This method is rerun every time setState() is called.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          toolbarHeight: hideAppBar ? 0 : 56,
          toolbarOpacity: hideAppBar ? 0.0 : 1.0,
          title: Text(widget.title),
          foregroundColor: Theme.of(context).colorScheme.primary),
      body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  left: 0,
                  top: 0,
                  child: hideAppBar
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          })
                      : Container()),
              FittedBox(
                child: orientationLayout(context),
              ),
            ],
          )),
      onDrawerChanged: (isOpened) {
        // This helps prevent jank on the fast/accurate slider.
        doRefreshes = !isOpened;
      },
      drawer: Drawer(
          width: 210 * textScaleFactor(context),
          child: ListView(
              padding: EdgeInsets.zero, children: drawerControls(context))),
      drawerEdgeDragWidth: 100,
    );
  }
}
