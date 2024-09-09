// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/cedar.pb.dart';
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'google/protobuf/timestamp.pb.dart';

OverlayEntry? _aboutOverlayEntry;
OverlayEntry? _serverTimeOverlayEntry;
Timer? _timer;

late BuildContext _context;

Text _scaledText(String str) {
  return Text(str, textScaler: textScaler(_context));
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

Future<void> aboutScreen(MyHomePageState state, BuildContext context) async {
  _context = context;
  _aboutOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Material(
          color: Colors.black,
          child: Stack(
            children: [
              RotatedBox(
                  quarterTurns:
                      MediaQuery.of(context).orientation == Orientation.portrait
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
                      child: serverInfo(state),
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
                icon: const Icon(Icons.close),
                onPressed: () {
                  _aboutOverlayEntry?.remove();
                  _aboutOverlayEntry = null;
                  _timer?.cancel();
                },
              ),
            ],
          )));

  _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    _serverTimeOverlayEntry?.markNeedsBuild();
    _aboutOverlayEntry?.markNeedsBuild();
  });

  Overlay.of(context).insert(_aboutOverlayEntry!);
}

Widget serverInfo(MyHomePageState state) {
  final portrait = MediaQuery.of(_context).orientation == Orientation.portrait;
  final serverInfo = state.serverInformation!;

  return RotatedBox(
      quarterTurns: portrait ? 3 : 0,
      child: Column(children: <Widget>[
        const SizedBox(height: 5),
        Text(
          style: const TextStyle(fontSize: 18),
          "Cedar™ server",
          textScaler: textScaler(_context),
        ),
        const SizedBox(height: 20),
        Expanded(
            child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Product"),
            _scaledText(serverInfo.productName)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Feature level"),
            _scaledText(serverInfo.featureLevel.toString().toLowerCase())
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Version"),
            _scaledText(serverInfo.cedarServerVersion)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Copyright"),
            TextButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                  backgroundColor: Colors.white10),
              onPressed: () {
                copyrightDialog(serverInfo.copyright);
              },
              child: _scaledText("view"),
            ),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Server time"),
            TextButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                  backgroundColor: Colors.white10),
              onPressed: () {
                serverTimeDialog(state);
              },
              child: _scaledText(formatTime(serverInfo.serverTime)),
            ),

            // _scaledText(formatTimestamp(serverInfo.serverTime)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("CPU temp"),
            _scaledText(sprintf("%.0f°C", [serverInfo.cpuTemperature]))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Processor/OS"),
            TextButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontWeight: FontWeight.normal),
                  backgroundColor: Colors.white10),
              onPressed: () {
                processorOsDialog(
                    serverInfo.processorModel, serverInfo.osVersion);
              },
              child: _scaledText("view"),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Serial #"),
            _scaledText(serverInfo.serialNumber)
          ]),
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
        const SizedBox(height: 5),
        Text(
          style: const TextStyle(fontSize: 18),
          "Calibration",
          textScaler: textScaler(_context),
        ),
        const SizedBox(height: 20),
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
            _scaledText("Camera offset"),
            _scaledText(
                calibrated ? sprintf("%d", [calData.cameraOffset]) : "unknown"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Match max. error"),
            _scaledText(calData.hasMatchMaxError()
                ? sprintf("%.3f", [calData.matchMaxError])
                : "unknown"),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Camera"),
            _scaledText(serverInfo.cameraModel),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Resolution"),
            _scaledText(sprintf("%dx%d",
                [serverInfo.cameraImageWidth, serverInfo.cameraImageHeight])),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Lens focal length"),
            _scaledText(calData.hasLensFlMm()
                ? sprintf("%.1fmm", [calData.lensFlMm])
                : "unknown"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("FOV (horiz)"),
            _scaledText(calData.hasFovHorizontal()
                ? sprintf("%.1f°", [calData.fovHorizontal])
                : "unknown"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Pixel angular size"),
            _scaledText(calData.hasPixelAngularSize()
                ? sprintf("%.1f'", [calData.pixelAngularSize * 60])
                : "unknown"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _scaledText("Lens distortion"),
            _scaledText(calData.hasLensDistortion()
                ? sprintf("%.3f", [calData.lensDistortion])
                : "unknown"),
          ]),
        ]))
      ]));
}

void serverTimeDialog(MyHomePageState state) {
  Color color = Theme.of(_context).colorScheme.primary;
  _serverTimeOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        _serverTimeOverlayEntry!.remove();
        _serverTimeOverlayEntry = null;
      },
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Container(
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
              _scaledText(formatTimestamp(state.serverInformation!.serverTime)),
            ]),
          ),
        ),
      ),
    );
  });

  Overlay.of(_context).insert(_serverTimeOverlayEntry!);
}

void copyrightDialog(String copyright) {
  OverlayEntry? dialogOverlayEntry;
  Color color = Theme.of(_context).colorScheme.primary;
  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Container(
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
              _scaledText(copyright),
            ]),
          ),
        ),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}

void processorOsDialog(String processor, String osVersion) {
  OverlayEntry? dialogOverlayEntry;
  Color color = Theme.of(_context).colorScheme.primary;
  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: Center(
          child: Container(
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
              _scaledText(processor),
              _scaledText(osVersion),
            ]),
          ),
        ),
      ),
    );
  });

  Overlay.of(_context).insert(dialogOverlayEntry);
}
