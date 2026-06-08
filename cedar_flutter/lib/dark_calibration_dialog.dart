// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/cedar.pb.dart' as cedar_rpc;
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

const Duration _darkFrameWarmup = Duration(seconds: 5);
const Duration _darkFrameCalibrationTimeout = Duration(seconds: 30);

void calibrateDarkFrameDialog(
    MyHomePageState state, BuildContext context,
    [OverlayEntry? cameraDialogEntry]) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(builder: (BuildContext context) {
    return _DarkCalibrationDialog(
      state: state,
      overlayEntry: overlayEntry,
      cameraDialogEntry: cameraDialogEntry,
    );
  });
  Overlay.of(context).insert(overlayEntry);
}

class _DarkCalibrationDialog extends StatefulWidget {
  final MyHomePageState state;
  final OverlayEntry? overlayEntry;
  final OverlayEntry? cameraDialogEntry;

  const _DarkCalibrationDialog(
      {required this.state, this.overlayEntry, this.cameraDialogEntry});

  @override
  State<_DarkCalibrationDialog> createState() => _DarkCalibrationDialogState();
}

class _DarkCalibrationDialogState extends State<_DarkCalibrationDialog> {
  bool _started = false;
  bool _warmupDone = false;
  String? _errorMessage;
  Timer? _calibrationTimer;

  @override
  void dispose() {
    _calibrationTimer?.cancel();
    super.dispose();
  }

  void _dismiss() {
    _calibrationTimer?.cancel();
    widget.overlayEntry?.remove();
    widget.cameraDialogEntry?.markNeedsBuild();
  }

  Future<void> _start() async {
    setState(() => _started = true);
    final error = await widget.state
        .initiateAction(cedar_rpc.ActionRequest(calibrateDarkFrame: true));
    if (error != null) {
      setState(() {
        _started = false;
        _errorMessage = error;
      });
      return;
    }
    final startTime = DateTime.now();
    _calibrationTimer = Timer(_darkFrameWarmup, () {
      if (mounted) setState(() => _warmupDone = true);
      _calibrationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!widget.state.calibrating) {
          _calibrationTimer?.cancel();
          if (mounted) _dismiss();
        } else if (DateTime.now().difference(startTime) >
            _darkFrameCalibrationTimeout) {
          _calibrationTimer?.cancel();
          if (mounted) {
            setState(() =>
                _errorMessage = "Timed out waiting for calibration to complete.");
          }
        } else {
          if (mounted) setState(() {});
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Material(
      color: Colors.black54,
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontFamilyFallback: ['Roboto']),
        child: Center(child: AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        if (_errorMessage != null) ...[
          Text("Error: $_errorMessage",
              style: TextStyle(fontSize: 12, color: color),
              textScaler: textScaler(context)),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            onPressed: _dismiss,
            child: Text("Dismiss", style: TextStyle(color: color)),
          ),
        ] else if (!_started) ...[
          Text("Close the lens cover, then start dark frame calibration.",
              style: TextStyle(fontSize: 12, color: color),
              textScaler: textScaler(context)),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton(
              onPressed: _dismiss,
              child: Text("Cancel", style: TextStyle(color: color)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              onPressed: _start,
              child: Text("Start", style: TextStyle(color: color)),
            ),
          ]),
        ] else ...[
          Text("Calibrating dark frame...",
              style: TextStyle(fontSize: 12, color: color),
              textScaler: textScaler(context)),
          const SizedBox(height: 15),
          CircularProgressIndicator(
              value: _warmupDone && widget.state.calibrating
                  ? widget.state.calibrationProgress
                  : null,
              color: color),
        ],
      ]),
    ))));
  }
}
