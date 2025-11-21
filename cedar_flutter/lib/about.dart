// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';
import 'dart:math';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/platform.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'google/protobuf/timestamp.pb.dart';

OverlayEntry? _aboutOverlayEntry;
OverlayEntry? _serverTimeOverlayEntry;
Timer? _timer;

late BuildContext _context;

// Consistent styling for all "view" buttons.
final ButtonStyle _viewButtonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontWeight: FontWeight.normal),
  backgroundColor: Colors.white10,
  minimumSize: const Size(0, 32),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
);

// Common spacing for dialog rows and sections.
const SizedBox _dialogRowSpacing = SizedBox(width: 20);
const SizedBox _sectionHeaderSpacing = SizedBox(height: 15);
const SizedBox _sectionDividerSpacing = SizedBox(height: 15);
const SizedBox _dialogItemSpacing = SizedBox(height: 8);
const SizedBox _dialogSectionSpacing = SizedBox(height: 10);
const SizedBox _headerTopSpacing = SizedBox(height: 5);

Text _scaledText(String str) {
  return Text(
    str,
    textScaler: textScaler(_context),
    style: TextStyle(color: Theme.of(_context).colorScheme.primary),
  );
}

TextStyle _dialogTextStyle() {
  return TextStyle(
    fontSize: 14 * textScaleFactor(_context),
    color: Theme.of(_context).colorScheme.primary,
  );
}

TextStyle _headerTextStyle() {
  return TextStyle(
    fontSize: 18 * textScaleFactor(_context),
    color: Theme.of(_context).colorScheme.primary,
  );
}

// Common dialog container decoration.
BoxDecoration _dialogDecoration() {
  return BoxDecoration(
    border: Border.all(color: Theme.of(_context).colorScheme.primary),
    color: Colors.black,
    borderRadius: BorderRadius.circular(10),
  );
}

String formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDateTime();
  DateTime localDateTime = dateTime.toLocal();
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return '${formatter.format(localDateTime)}\n${localDateTime.timeZoneName}';
}

String formatTime(Timestamp timestamp) {
  final dateTime = timestamp.toDateTime();
  DateTime localDateTime = dateTime.toLocal();
  DateFormat formatter = DateFormat('HH:mm');
  return formatter.format(localDateTime);
}

double _calculateMagnitude(double x, double y, double z) {
  return sqrt(x * x + y * y + z * z);
}

Future<void> aboutScreen(MyHomePageState state, BuildContext context) async {
  final rightHanded =
      state.preferences != null ? state.preferences!.rightHanded : true;
  _context = context;
  _aboutOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Material(
          color: Colors.black,
          child: DefaultTextStyle.merge(
              style: const TextStyle(fontFamilyFallback: ['Roboto']),
              child: Stack(
                alignment: rightHanded ? Alignment.topRight : Alignment.topLeft,
                children: [
                  RotatedBox(
                      quarterTurns: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 1
                          : 0,
                      child: Row(children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: systemInfo(state),
                        )),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: calibrationInfo(state),
                        )),
                      ])),
                  IconButton(
                    icon: const Icon(Icons.close, size: 30),
                    onPressed: () {
                      _aboutOverlayEntry?.remove();
                      _aboutOverlayEntry = null;
                      _timer?.cancel();
                      state.closeDrawer();
                    },
                  ),
                ],
              ))));

  _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    _serverTimeOverlayEntry?.markNeedsBuild();
    _aboutOverlayEntry?.markNeedsBuild();
  });

  Overlay.of(context).insert(_aboutOverlayEntry!);
}

Widget systemInfo(MyHomePageState state) {
  final portrait = MediaQuery.of(_context).orientation == Orientation.portrait;
  final serverInfo = state.serverInformation!;
  var platform = "Unknown";
  if (isWeb()) {
    platform = "Web";
  } else if (isIOS()) {
    platform = "iOS";
  } else if (isAndroid()) {
    platform = "Android";
  }

  return RotatedBox(
      quarterTurns: portrait ? 3 : 0,
      child: Column(children: <Widget>[
        _headerTopSpacing,
        Text(
          "Cedar™ system",
          style: _headerTextStyle(),
        ),
        _sectionHeaderSpacing,
        Expanded(
            child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Product"),
            _scaledText(serverInfo.featureLevel.toString().toLowerCase().isEmpty
                ? serverInfo.productName
                : "${serverInfo.productName} / ${serverInfo.featureLevel.toString().toLowerCase()}")
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Versions"),
            TextButton(
              style: _viewButtonStyle,
              onPressed: () {
                versionsDialog(serverInfo.cedarServerVersion, getUpdaterVersion());
              },
              child: _scaledText("view"),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Copyright"),
            TextButton(
              style: _viewButtonStyle,
              onPressed: () {
                copyrightDialog(serverInfo.copyright);
              },
              child: _scaledText("view"),
            ),
          ]),
          _sectionDividerSpacing,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Server time"),
            TextButton(
              style: _viewButtonStyle,
              onPressed: () {
                serverTimeDialog(state);
              },
              child: _scaledText(formatTime(serverInfo.serverTime)),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("CPU temp"),
            _scaledText(sprintf("%.0f°C", [serverInfo.cpuTemperature]))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Processor/OS"),
            TextButton(
              style: _viewButtonStyle,
              onPressed: () {
                processorOsDialog(serverInfo.processorModel,
                    serverInfo.osVersion, serverInfo.serialNumber);
              },
              child: _scaledText("view"),
            ),
          ]),
          _sectionDividerSpacing,
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_scaledText("Platform"), _scaledText(platform)]),
        ]))
      ]));
}

Widget calibrationInfo(MyHomePageState state) {
  final portrait = MediaQuery.of(_context).orientation == Orientation.portrait;
  final calData = state.calibrationData!;
  final serverInfo = state.serverInformation!;

  final Timestamp defaultTS = Timestamp();
  bool calibrated = calData.calibrationTime != defaultTS;

  return RotatedBox(
      quarterTurns: portrait ? 3 : 0,
      child: Column(children: <Widget>[
        _headerTopSpacing,
        Text(
          "Calibration",
          style: _headerTextStyle(),
        ),
        _sectionHeaderSpacing,
        Expanded(
            child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Last calibration"),
            _scaledText(
                calibrated ? formatTime(calData.calibrationTime) : "never"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Baseline exp. time"),
            _scaledText(calibrated
                ? sprintf("%.1fms",
                    [durationToMs(calData.targetExposureTime).toDouble()])
                : "unknown"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Match max. error"),
            _scaledText(calData.hasMatchMaxError()
                ? sprintf("%.3f", [calData.matchMaxError])
                : "unknown"),
          ]),
          _sectionDividerSpacing,
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Camera"),
            TextButton(
              style: _viewButtonStyle,
              onPressed: () {
                cameraDialog(serverInfo, calData);
              },
              child: _scaledText("view"),
            ),
          ]),
          if (serverInfo.hasImuModel()) ...[
            _dialogSectionSpacing,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _scaledText("Gyro"),
              TextButton(
                style: _viewButtonStyle,
                onPressed: () {
                  imuCalibrationDialog(serverInfo, calData);
                },
                child: _scaledText("view"),
              ),
            ]),
          ],
        ]))
      ]));
}

void serverTimeDialog(MyHomePageState state) {
  _serverTimeOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        _serverTimeOverlayEntry!.remove();
        _serverTimeOverlayEntry = null;
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: _dialogDecoration(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _scaledText(
                      formatTimestamp(state.serverInformation!.serverTime)),
                ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(_serverTimeOverlayEntry!);
}

void copyrightDialog(String copyright) {
  OverlayEntry? dialogOverlayEntry;
  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: _dialogDecoration(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    copyright,
                    textAlign: TextAlign.center,
                    textScaler: textScaler(_context),
                    style: TextStyle(
                        color: Theme.of(_context).colorScheme.primary),
                  ),
                ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}

void processorOsDialog(
    String processor, String osVersion, String serialNumber) {
  OverlayEntry? dialogOverlayEntry;

  // Clean up processor string - replace 'Raspberry Pi' with 'RPi'.
  String cleanProcessor = processor.replaceAll(
      RegExp(r'Raspberry Pi', caseSensitive: false), 'RPi');

  // Clean up OS version string - replace GNU/Linux with Linux.
  String cleanOsVersion = osVersion.replaceAll('GNU/Linux', 'Linux');

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: _dialogDecoration(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Processor:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              cleanProcessor,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("OS version:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              cleanOsVersion,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Serial #:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              serialNumber,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                    ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}

void versionsDialog(String serverVersion, String? updaterVersion) async {
  OverlayEntry? dialogOverlayEntry;

  // Get client version info.
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String clientVersion =
      packageInfo.version; // Only show version, not build number.

  // Check if context is still mounted after async operation.
  if (!_context.mounted) {
    return;
  }

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: _dialogDecoration(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Server version:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              serverVersion,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogSectionSpacing,
                      if (updaterVersion != null) ...[
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _scaledText("Updater version:"),
                              _dialogRowSpacing,
                              Expanded(
                                  child: Text(
                                updaterVersion,
                                textAlign: TextAlign.right,
                                style: _dialogTextStyle(),
                              )),
                            ]),
                        _dialogSectionSpacing,
                      ],
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Client version:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              clientVersion,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                    ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}

void cameraDialog(dynamic serverInfo, dynamic calData) {
  OverlayEntry? dialogOverlayEntry;

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: _dialogDecoration(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Model:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              serverInfo.hasCamera()
                                  ? serverInfo.camera.model
                                  : "no camera",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Resolution:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              serverInfo.hasCamera()
                                  ? sprintf("%d x %d", [
                                      serverInfo.camera.imageWidth,
                                      serverInfo.camera.imageHeight
                                    ])
                                  : "no camera",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Lens focal length:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasLensFlMm()
                                  ? sprintf("%.1fmm", [calData.lensFlMm])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("FOV:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasFovHorizontal()
                                  ? sprintf("%.1f° x %.1f°", [
                                      calData.fovHorizontal,
                                      calData.fovVertical
                                    ])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Pixel angular size:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasPixelAngularSize()
                                  ? calData.pixelAngularSize > 1.0 / 60
                                      ? sprintf("%.1f arcmin",
                                          [calData.pixelAngularSize * 60.0])
                                      : sprintf("%.0f arcsec",
                                          [calData.pixelAngularSize * 3600.0])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Lens distortion:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasLensDistortion()
                                  ? sprintf("%.3f", [calData.lensDistortion])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                    ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}

void imuCalibrationDialog(dynamic serverInfo, dynamic calData) {
  OverlayEntry? dialogOverlayEntry;

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: _dialogDecoration(),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Model:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              serverInfo.imuModel,
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Calibration error:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasGyroTransformErrorFraction()
                                  ? sprintf("%.1f%%", [calData.gyroTransformErrorFraction * 100])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Zero bias:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasGyroZeroBiasX()
                                  ? sprintf("%.4f°/s", [
                                      _calculateMagnitude(
                                          calData.gyroZeroBiasX,
                                          calData.gyroZeroBiasY,
                                          calData.gyroZeroBiasZ)
                                    ])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Camera view axis:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasCameraViewGyroAxis()
                                  ? calData.cameraViewGyroAxis
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("  Misalignment:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasCameraViewGyroAxis()
                                  ? sprintf("%.1f°", [calData.cameraViewMisalignment])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("Camera up axis:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasCameraUpGyroAxis()
                                  ? calData.cameraUpGyroAxis
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                      _dialogItemSpacing,
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _scaledText("  Misalignment:"),
                            _dialogRowSpacing,
                            Expanded(
                                child: Text(
                              calData.hasCameraUpGyroAxis()
                                  ? sprintf("%.1f°", [calData.cameraUpMisalignment])
                                  : "unknown",
                              textAlign: TextAlign.right,
                              style: _dialogTextStyle(),
                            )),
                          ]),
                    ]),
              ),
            )),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}
