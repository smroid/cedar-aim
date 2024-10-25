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
import 'package:path/path.dart' as path;
import 'package:protobuf/protobuf.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;
import 'tetra3.pb.dart';
import 'get_cedar_client_for_web.dart'
    if (dart.library.io) 'get_cedar_client.dart';

// To generate release build:
// flutter build web --web-renderer canvaskit --no-web-resources-cdn

typedef DrawCatalogEntriesFunction = void Function(BuildContext, Canvas, Color,
    List<cedar_rpc.FovCatalogEntry>, bool, int, bool);

typedef ShowCatalogBrowserFunction = void Function(
    BuildContext, MyHomePageState);

typedef ObjectInfoDialogFunction = void Function(
    MyHomePageState, BuildContext, SelectedCatalogEntry);

typedef WifiDialogFunction = void Function(MyHomePageState, BuildContext);

DrawCatalogEntriesFunction? _drawCatalogEntries;
ShowCatalogBrowserFunction? _showCatalogBrowser;
ObjectInfoDialogFunction? _objectInfoDialog;
WifiDialogFunction? _wifiDialog;

void clientMain(
    DrawCatalogEntriesFunction? drawCatalogEntries,
    ShowCatalogBrowserFunction? showCatalogBrowser,
    ObjectInfoDialogFunction? objectInfoDialog,
    WifiDialogFunction? wifiDialog) {
  _drawCatalogEntries = drawCatalogEntries;
  _showCatalogBrowser = showCatalogBrowser;
  _objectInfoDialog = objectInfoDialog;
  _wifiDialog = wifiDialog;

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

  void _paint(Canvas canvas, Size size) {
    const double hairline = 0.5;
    const double thin = 1;
    const double thick = 1.5;
    final Color color = Theme.of(_context).colorScheme.primary;
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
      if (state._advanced) {
        // Draw circles around the detected stars.
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
          state._scopeFov,
          /*rollAngleRad=*/ _deg2rad(state.bullseyeDirectionIndicator()),
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
          const Offset(5, 5),
          state.preferences?.mountType == cedar_rpc.MountType.ALT_AZ,
          state._northernHemisphere,
          slew.offsetRotationAxis,
          slew.offsetTiltAxis,
          portrait);
    } else if (!state._focusAid &&
        !state._calibrating &&
        !state._transitionToSetup) {
      var rollAngleRad = _deg2rad(state.bullseyeDirectionIndicator());
      drawBullseye(canvas, color, state._boresightPosition, state._scopeFov / 2,
          rollAngleRad);
      if (state._labeledFovCatalogEntries.isNotEmpty &&
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
    if (state._setupMode &&
        !state._focusAid &&
        !state._daylightMode &&
        state._stars.isNotEmpty) {
      // Draw alignment targets: the N brightest stars (or planets).
      Paint paint = Paint()
        ..color = color
        ..strokeWidth = thick
        ..style = PaintingStyle.stroke;
      int numTargets = 0;
      for (var star in state._stars) {
        if (++numTargets > state._numTargets) {
          break;
        }
        canvas.drawRect(
            Rect.fromCenter(
                center: Offset(star.centroidPosition.x / state._binFactor,
                    star.centroidPosition.y / state._binFactor),
                width: 16,
                height: 16),
            paint);
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
    final scopeFov = _scale * _state._scopeFov;
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
  bool _hasCamera = false;
  bool isDIY = false;
  bool isBasic = false;
  bool isPlus = false;
  bool _paintPending = false;
  bool _inhibitRefresh = false;

  bool _serverConnected = false;
  bool _everConnected = false;
  DateTime _lastServerResponseTime = DateTime.now();

  // State for align mode.
  final _numTargets = 3;
  bool _alignTargetTapped = false;

  // Information from most recent FrameResult.

  // Image data, binned by server.
  Uint8List _imageBytes = Uint8List(1);
  late Rect _imageRegion; // Scaled by _binFactor.
  int _binFactor = 1;

  cedar_rpc.ServerInformation? serverInformation;
  var fixedSettings = cedar_rpc.FixedSettings();
  var operationSettings = cedar_rpc.OperationSettings();
  bool _setupMode = false;
  bool _focusAid = false;
  bool _daylightMode = false;
  bool _demoMode = false;
  List<String> _demoFiles = [];
  String _demoFile = "";
  bool _advanced = false;
  bool _canAlign = false;
  bool _hasWifiControl = false;

  double _scopeFov = 0.0;

  Offset _boresightPosition =
      const Offset(0, 0); // Scaled by main image's binning.
  Offset _fullResBoresightPosition = const Offset(0, 0);

  Rect? _centerPeakRegion; // Scaled by binning.

  int _centerPeakWidth = 0;
  int _centerPeakHeight = 0;
  Uint8List? _centerPeakImageBytes;

  int _boresightImageWidth = 0;
  Uint8List? _boresightImageBytes;

  int _prevFrameId = -1;
  late List<cedar_rpc.StarCentroid> _stars;
  int _numStars = 0;
  var exposureTimeMs = 0.0;
  bool _hasSolution = false;

  List<Offset>? _solutionCentroids;
  // Degrees.
  double _solutionRA = 0.0;
  double _solutionDec = 0.0;
  double _solutionRollAngle = 0.0; // Degrees.
  double _solutionFOV = 0.0; // Degrees.

  // Arcsec.
  double solutionRMSE = 0.0;

  cedar_rpc.LocationBasedInfo? _locationBasedInfo;

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

  // Values set from on-screen controls.

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
    serverInformation = response.serverInformation;
    _hasWifiControl =
        serverInformation!.featureLevel != cedar_rpc.FeatureLevel.DIY;
    _hasCamera = serverInformation!.hasCamera();
    isDIY = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.DIY;
    isBasic = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.BASIC;
    isPlus = serverInformation!.featureLevel == cedar_rpc.FeatureLevel.PLUS;
    _demoFiles = serverInformation!.demoImageNames;
    if (_demoFiles.isEmpty) {
      _demoFile = "";
    } else if (_demoFile.isEmpty) {
      _demoFile = _demoFiles[0];
    }

    fixedSettings = response.fixedSettings;
    operationSettings = response.operationSettings;
    _setupMode =
        operationSettings.operatingMode == cedar_rpc.OperatingMode.SETUP;
    _focusAid = operationSettings.focusAssistMode;
    _daylightMode = operationSettings.daylightMode;
    if (_setupMode) {
      _transitionToSetup = false;
    }

    _canAlign = _setupMode;
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
    _advanced = preferences!.advanced;
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
      _imageRegion = Rect.fromLTWH(
          response.image.rectangle.originX.toDouble() / _binFactor,
          response.image.rectangle.originY.toDouble() / _binFactor,
          response.image.rectangle.width.toDouble() / _binFactor,
          response.image.rectangle.height.toDouble() / _binFactor);
    }
    if (response.hasPlateSolution()) {
      SolveResult plateSolution = response.plateSolution;
      if (plateSolution.status == SolveStatus.MATCH_FOUND) {
        _hasSolution = true;
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
        _scopeFov =
            preferences!.eyepieceFov * _imageRegion.width / _solutionFOV;
      }
    }
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
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint('updateFixedSettings error: $e');
    }
  }

  Future<void> updateOperationSettings(
      cedar_rpc.OperationSettings request) async {
    try {
      await client().updateOperationSettings(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint('updateOperationSettings error: $e');
    }
  }

  // Use request/response style of RPC.
  Future<void> getFrameFromServer() async {
    final request = cedar_rpc.FrameRequest()..prevFrameId = _prevFrameId;
    try {
      final response = await client().getFrame(request,
          options: CallOptions(
            timeout: const Duration(seconds: 2),
            metadata: {
              'grpc-timeout': '2s',
            },
          ));
      if (!_serverConnected) {
        // Connecting for first time, or reconnecting.
        setServerTime(DateTime.now()); // Send our time to server.
      }
      _serverConnected = true;
      _everConnected = true;
      _lastServerResponseTime = DateTime.now();
      if (_inhibitRefresh) {
        _prevFrameId = response.frameId;
        return;
      }
      _paintPending = true;
      setState(() {
        setStateFromFrameResult(response);
      });
    } catch (e) {
      debugPrint('getFrameFromServer error: $e');
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
  Future<void> refreshStateFromServer() async {
    // See if we can get location from the platform. If we are a web app, served
    // over http (not https), we won't be able to get location here.
    var platformPosition = await getLocation();
    if (platformPosition != null) {
      _mapPosition =
          LatLng(platformPosition.latitude, platformPosition.longitude);
    }
    _tzOffset = DateTime.now().timeZoneOffset; // Get platform timezone.

    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!_paintPending) {
        await getFrameFromServer();
      }
      return true; // Forever!
    });
  }

  Future<void> initiateAction(cedar_rpc.ActionRequest request) async {
    try {
      await client().initiateAction(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
    } catch (e) {
      debugPrint('initiateAction error: $e');
    }
  }

  Future<void> setServerTime(DateTime now) async {
    final ts = Timestamp(
        seconds: Int64(now.millisecondsSinceEpoch ~/ 1000.0),
        nanos: (now.millisecondsSinceEpoch % 1000) * 1000000);
    var request = cedar_rpc.FixedSettings();
    request.currentTime = ts;
    await updateFixedSettings(request);
  }

  Future<void> setObserverLocation(LatLng pos) async {
    final posProto =
        cedar_rpc.LatLong(latitude: pos.latitude, longitude: pos.longitude);
    var request = cedar_rpc.FixedSettings();
    request.observerLocation = posProto;
    await updateFixedSettings(request);
  }

  Future<void> captureBoresight() async {
    final request = cedar_rpc.ActionRequest(captureBoresight: true);
    await initiateAction(request);
  }

  Future<void> designateBoresight(Offset pos) async {
    final coord = cedar_rpc.ImageCoord(x: pos.dx, y: pos.dy);
    final request = cedar_rpc.ActionRequest(designateBoresight: coord);
    await initiateAction(request);
  }

  Future<void> stopSlew() async {
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
  Future<void> setDemoImage(String imageFile) async {
    final request = cedar_rpc.OperationSettings(demoImageFilename: imageFile);
    await updateOperationSettings(request);
  }

  Future<String> getServerLogs() async {
    final request = cedar_rpc.ServerLogRequest(logRequest: 20000);
    try {
      final infoResult = await client().getServerLog(request,
          options: CallOptions(timeout: const Duration(seconds: 2)));
      return infoResult.logContent;
    } catch (e) {
      debugPrint('getServerLogs error: $e');
      return "";
    }
  }

  Text scaledText(String str) {
    return Text(str, textScaler: textScaler(context));
  }

  void shutdownDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: scaledText("Shutdown Raspberry Pi?"),
          actionsOverflowButtonSpacing: 5,
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: scaledText("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                restart();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: scaledText("Restart"),
            ),
            ElevatedButton(
              onPressed: () {
                shutdown();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: scaledText("Shutdown"),
            ),
          ],
        );
      },
    );
  }

  Future<void> shutdown() async {
    final request = cedar_rpc.ActionRequest(shutdownServer: true);
    await initiateAction(request);
  }

  Future<void> restart() async {
    final request = cedar_rpc.ActionRequest(restartServer: true);
    await initiateAction(request);
  }

  Future<void> saveImage() async {
    final request = cedar_rpc.ActionRequest(saveImage: true);
    await initiateAction(request);
  }

  Future<void> updateWifi(String ssid, String psk, int channel) async {
    final updateWifi = WiFiAccessPoint(ssid: ssid, psk: psk, channel: channel);
    final request = cedar_rpc.ActionRequest(updateWifiAccessPoint: updateWifi);
    await initiateAction(request);
  }

  Future<void> cancelCalibration() async {
    await _setOperatingMode(/*setupMode=*/ true, _daylightMode);
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
      debugPrint('updatePreferences error: $e');
    }
  }

  String _removeExtension(String filename) {
    return path.basenameWithoutExtension(filename);
  }

  List<Widget> drawerControls(BuildContext context) {
    return <Widget>[
      const CloseButton(style: ButtonStyle(alignment: Alignment.topLeft)),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Container(width: 15),
              DropdownMenu<String>(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    constraints:
                        BoxConstraints.tight(const Size.fromHeight(40)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  width: 100 * textScaleFactor(context),
                  requestFocusOnTap: false,
                  initialSelection:
                      _setupMode ? (_focusAid ? "Focus" : "Align") : "Aim",
                  label: primaryText("Mode", size: 12),
                  dropdownMenuEntries: ["Focus", "Align", "Aim"]
                      .map<DropdownMenuEntry<String>>((String s) {
                    return DropdownMenuEntry<String>(
                      value: s,
                      label: s,
                      labelWidget: primaryText(s),
                      enabled: true,
                    );
                  }).toList(),
                  textStyle: TextStyle(
                      fontSize: 14 * textScaleFactor(context),
                      color: Theme.of(context).colorScheme.primary),
                  onSelected: (String? newValue) async {
                    if (newValue == "Focus") {
                      setState(() {
                        if (!_setupMode) {
                          _transitionToSetup = true;
                        }
                        _setOperatingMode(
                            /*setupMode=*/ true, /*focusAid=*/ true);
                      });
                    } else if (newValue == "Align") {
                      setState(() {
                        _alignTargetTapped = false;
                        if (!_setupMode) {
                          _transitionToSetup = true;
                        }
                        _setOperatingMode(
                            /*setupMode=*/ true, /*focusAid=*/ false);
                      });
                    } else {
                      // Aim.
                      setState(() {
                        _setOperatingMode(
                            /*setupMode=*/ false, /*focusAid*/ false);
                      });
                    }
                    Navigator.of(context).pop();
                  })
            ],
          )),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: scaledText("Preferences"),
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
                  ? scaledText("Location unknown")
                  : scaledText(sprintf("Location %.1f %.1f",
                      [_mapPosition!.latitude, _mapPosition!.longitude])),
              icon: Icon(_mapPosition == null
                  ? Icons.not_listed_location
                  : Icons.edit_location_alt),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapScreen(this)));
              })),
      const SizedBox(height: 15),
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: scaledText("Advanced"),
              icon: _advanced
                  ? const Icon(Icons.check)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () async {
                _advanced = !_advanced;
                var settingsModel =
                    Provider.of<SettingsModel>(context, listen: false);
                settingsModel.preferencesProto.advanced = _advanced;
                var prefs = cedar_rpc.Preferences();
                prefs.advanced = _advanced;
                await updatePreferences(prefs);
              })),
      (_advanced || _demoMode) && _demoFiles.isNotEmpty
          ? Column(children: <Widget>[
              const SizedBox(height: 15),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    label: scaledText("Demo mode"),
                    icon: _demoMode
                        ? const Icon(Icons.check)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        _demoMode = !_demoMode;
                        if (_demoMode) {
                          if (_demoFile.isNotEmpty) {
                            setDemoImage(_demoFile);
                          }
                        } else {
                          setDemoImage(""); // Turn off.
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
                    label: primaryText("Image file", size: 12),
                    dropdownMenuEntries:
                        _demoFiles.map<DropdownMenuEntry<String>>((String s) {
                      return DropdownMenuEntry<String>(
                        value: s,
                        label: _removeExtension(s),
                        labelWidget: primaryText(_removeExtension(s)),
                        enabled: true,
                      );
                    }).toList(),
                    textStyle: TextStyle(
                        fontSize: 12 * textScaleFactor(context),
                        color: Theme.of(context).colorScheme.primary),
                    onSelected: (String? newValue) async {
                      setState(() {
                        _demoFile = newValue!;
                        setDemoImage(_demoFile);
                      });
                    })
              ]),
              const SizedBox(height: 15),
            ])
          : Container(),
      const SizedBox(height: 5),
      _advanced
          ? Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: scaledText("About"),
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
              label: scaledText("Shutdown"),
              icon: const Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                shutdownDialog();
              })),
      _advanced
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: scaledText("Save image"),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () {
                        saveImage();
                      }))
            ])
          : Container(),
      _advanced
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: scaledText("Show server log"),
                      icon: const Icon(Icons.text_snippet_outlined),
                      onPressed: () async {
                        var logs = await getServerLogs();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) => ServerLogPopUp(logs));
                        }
                      })),
            ])
          : Container(),
      _advanced && _hasWifiControl && _wifiDialog != null
          ? Column(children: [
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                      label: scaledText("Wifi"),
                      icon: const Icon(Icons.wifi),
                      onPressed: () {
                        _wifiDialog!(this, context);
                      }))
            ])
          : Container(),
      const SizedBox(height: 15),
    ];
  }

  Widget rowOrColumn(bool row, List<Widget> children) {
    return row ? Row(children: children) : Column(children: children);
  }

  List<Widget> controls() {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final color = Theme.of(context).colorScheme.primary;
    // bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
    //     .preferencesProto
    //     .hideAppBar;
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
      // hideAppBar
      //     ? SizedBox(width: 0, height: (portrait ? 30 : 50))
      //     : Container(),
      RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: _focusAid
            ? SizedBox(
                width: (portrait ? 120 : 80) * textScaleFactor(context),
                child: Text(
                  _daylightMode
                      ? "Aim at distant object and adjust focus"
                      : "Adjust focus",
                  maxLines: 8,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontSize: 12),
                  textScaler: textScaler(context),
                ))
            : (_canAlign && _slewRequest == null
                ? _daylightMode
                    ? SizedBox(
                        width: (portrait ? 120 : 80) * textScaleFactor(context),
                        child: Text(
                          "Tap image where telescope is pointed",
                          maxLines: 8,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color, fontSize: 12),
                          textScaler: textScaler(context),
                        ))
                    : rowOrColumn(portrait, [
                        SizedBox(
                            width: (portrait ? 120 : 80) *
                                textScaleFactor(context),
                            child: Text(
                              "Center a highlighted object in telescope, then tap the object",
                              maxLines: 8,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: color, fontSize: 12),
                              textScaler: textScaler(context),
                            )),
                        // const SizedBox(width: 5, height: 0),
                        // const SizedBox(width: 5, height: 15),
                      ])
                : Container()),
      ),
      const SizedBox(height: 15),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: SizedBox(
            width: 70 * textScaleFactor(context),
            height: 25 * textScaleFactor(context),
            child: _focusAid
                ? OutlinedButton(
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
                        _setOperatingMode(
                            /*setupMode=*/ true, /*focusAid=*/ false);
                      });
                    })
                : (_canAlign
                    ? OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0)),
                        child: Text(
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                          _slewRequest == null
                              ? (_alignTargetTapped ? "Done" : "Skip")
                              : "Re-align",
                          textScaler: textScaler(context),
                        ),
                        onPressed: () {
                          // Transition to aim mode.
                          if (_slewRequest == null) {
                            setState(() {
                              _setOperatingMode(
                                  /*setupMode=*/ false, _focusAid);
                            });
                          } else {
                            captureBoresight();
                          }
                        })
                    : (_slewRequest == null &&
                            !_setupMode &&
                            _showCatalogBrowser != null
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0)),
                            child: Text(
                              style: const TextStyle(fontSize: 14),
                              "Catalog",
                              textScaler: textScaler(context),
                            ),
                            onPressed: () {
                              _showCatalogBrowser!(context, this);
                            })
                        : Container())),
          )),
      const SizedBox(width: 0, height: 25),
      _slewRequest != null
          ? RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: SizedBox(
                  width: 70 * textScaleFactor(context),
                  height: 25 * textScaleFactor(context),
                  child: _slewRequest != null && !_setupMode
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0)),
                          child: Text(
                            style: const TextStyle(fontSize: 14),
                            "End goto",
                            textScaler: textScaler(context),
                          ),
                          onPressed: () {
                            stopSlew();
                          })
                      : Container()))
          : Container(),
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

  Text primaryText(String val, {double? size = 16}) {
    return Text(
      val,
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary, fontSize: size),
      textScaler: textScaler(context),
    );
  }

  Text solveText(String val, {double? size = 16}) {
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
          height: 20 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("RA"),
                solveText(formatRightAscension(_solutionRA))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 20 * textScaleFactor(context),
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
          height: 20 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("Az"),
                solveText(formatAzimuth(_locationBasedInfo!.azimuth))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 20 * textScaleFactor(context),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                solveText("Alt"),
                solveText(formatAltitude(_locationBasedInfo!.altitude))
              ])),
      SizedBox(
          width: width * textScaleFactor(context),
          height: 20 * textScaleFactor(context),
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
          child: _setupMode && !(_focusAid && _advanced && !_daylightMode)
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
                                  widget: solveText(sprintf("%d", [_numStars]),
                                      size: 18),
                                ),
                                GaugeAnnotation(
                                  positionFactor: 0.4,
                                  angle: 90,
                                  widget: solveText("stars", size: 16),
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
                ])),
      const SizedBox(width: 10, height: 10),
      // Define a spacer for situations where data items column is empty.
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: SizedBox(
            width: 90 * textScaleFactor(context),
            child: Container(),
          )),
      const SizedBox(width: 10, height: 10),
      RotatedBox(
        quarterTurns: portrait ? 3 : 0,
        child: _setupMode
            ? SizedBox(
                width: 100 * textScaleFactor(context),
                child: GestureDetector(
                    onTap: () {
                      _setDaylightMode(!_daylightMode);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _daylightMode,
                            onChanged: (bool? selected) {
                              _setDaylightMode(selected!);
                            },
                            activeColor: Theme.of(context).colorScheme.surface,
                            checkColor: Theme.of(context).colorScheme.primary,
                          ),
                          primaryText("Daytime"),
                        ])))
            : Container(),
      ),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: _setupMode
              ? Container()
              : SizedBox(
                  width: 110 * textScaleFactor(context),
                  height: 120 * textScaleFactor(context),
                  child: Column(
                    children: coordInfo(
                        preferences?.mountType == cedar_rpc.MountType.ALT_AZ,
                        /*width=*/ 110),
                  ),
                )),
      const SizedBox(width: 15, height: 15),
      RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: hasPolarAdvice() && !_setupMode
              ? SizedBox(
                  width: 140 * textScaleFactor(context),
                  height: 140,
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
                )
              : Container()),
    ];
  }

  Widget loadImage() {
    return dart_widgets.Image.memory(_imageBytes, gaplessPlayback: true);
  }

  Widget mainImage() {
    return ClipRect(
        child: CustomPaint(
            foregroundPainter: _MainImagePainter(this, context),
            child: GestureDetector(
              child: loadImage(),
              onTapDown: (TapDownDetails details) async {
                Offset localPosition = Offset(
                    details.localPosition.dx * _binFactor,
                    details.localPosition.dy * _binFactor);
                if (_setupMode) {
                  if (!_focusAid) {
                    // Align mode.
                    if (_daylightMode) {
                      designateBoresight(localPosition);
                      _alignTargetTapped = true;
                    } else {
                      var star = _findStarHit(localPosition, 30);
                      if (star != null) {
                        designateBoresight(Offset(
                            star.centroidPosition.x, star.centroidPosition.y));
                        _alignTargetTapped = true;
                      }
                    }
                  }
                } else {
                  // Aim mode.
                  var object = _findObjectHit(localPosition, 30);
                  if (object != null && _objectInfoDialog != null) {
                    var selEntry = SelectedCatalogEntry(entry: object.entry);
                    _objectInfoDialog!(this, context, selEntry);
                  }
                }
              },
            )));
  }

  StarCentroid? _findStarHit(Offset tapPosition, int tolerance) {
    StarCentroid? closest;
    double closestDistance = 0;

    int numTargets = 0;
    for (var star in _stars) {
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

    if (closest != null && closestDistance < tolerance) {
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
                      child: scaledText('Cancel'),
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
      _prevFrameId != -1
          ? mainImage()
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
                  child: pacifier(context, _calibrating)))
          : Container(),
    ]);
  }

  Widget orientationLayout(BuildContext context) {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final controlsColumn = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: portrait ? controls().reversed.toList() : controls());
    return RotatedBox(
      quarterTurns: portrait ? 1 : 0,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5, height: 0),
          SizedBox(height: _imageRegion.height, child: controlsColumn),
          const SizedBox(width: 5, height: 0),
          imageStack(context),
          const SizedBox(width: 5, height: 0),
          Column(children: dataItems(context)),
          const SizedBox(width: 5, height: 0),
        ],
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool healthy = _serverConnected && (_hasCamera || _demoMode);

    // This method is rerun every time setState() is called.
    bool hideAppBar = Provider.of<SettingsModel>(context, listen: false)
        .preferencesProto
        .hideAppBar;
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
              healthy
                  ? FittedBox(child: orientationLayout(context))
                  : badServerState(),
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
            ],
          )),
      onDrawerChanged: (isOpened) {
        // Prevent jank in demo mode image file selector.
        _inhibitRefresh = isOpened;
      },
      drawer: _serverConnected
          ? Drawer(
              width: 240 * textScaleFactor(context),
              child: ListView(
                  padding: EdgeInsets.zero, children: drawerControls(context)))
          : Container(),
      drawerEdgeDragWidth: 100,
    );
  }

  Widget badServerState() {
    Color color = Theme.of(context).colorScheme.primary;
    final connMessage = _everConnected
        ? "Connection lost to Cedar server"
        : "No connection to Cedar server";
    _paintPending = false;
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
                maxLines: 5,
                style: const TextStyle(fontSize: 20),
                _serverConnected
                    ? "Cedar could not detect a camera. "
                        "Please check the camera connection."
                    : "$connMessage. Please ensure that Cedar "
                        "server is running, connect this device to the Cedar WiFi "
                        "hotspot, and navigate to http://cedar.local or "
                        "http://192.168.4.1."),
          ]),
        ),
      ),
    );
  }
} // MyHomePageState
