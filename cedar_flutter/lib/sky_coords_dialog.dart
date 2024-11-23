// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;

Future<void> skyCoordsDialog(
    MyHomePageState state, BuildContext context) async {
  Text scaledText(String str) {
    return Text(str,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        textScaler: textScaler(context));
  }

  OverlayEntry? dialogOverlayEntry;
  GlobalKey dialogOverlayKey = GlobalKey();

  Timer timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    dialogOverlayEntry?.markNeedsBuild();
  });

  Color color = Theme.of(context).colorScheme.primary;
  final width = 210.0 * textScaleFactor(context);

  bool displayAltAz = state.locationBasedInfo != null;

  bool tapInsideOverlay = false;

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        RenderBox? renderBox =
            dialogOverlayKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          Offset offset = renderBox.localToGlobal(Offset.zero);
          Rect bounds = Rect.fromLTWH(offset.dx, offset.dy,
              renderBox.size.width, renderBox.size.height);
          if (bounds.contains(details.globalPosition)) {
            tapInsideOverlay = true;
          } else {
            tapInsideOverlay = false;
          }
        }
      },
      onTap: () {
        if (!tapInsideOverlay) {
          timer.cancel();
          dialogOverlayEntry!.remove();
        }
        // TODO: for taps inside the overlay, use the tap to determine what
        // coordinate items should be seen in the main display.
      },
      child: Material(
        color: Colors.black54,
        child: Center(
            child: Container(
          key: dialogOverlayKey,
          width: width,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                scaledText("Sky Location"),
              ]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                scaledText("Right ascension"),
                state.solveText(state.formatRightAscension(state.solutionRA)),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                scaledText("Declination"),
                state.solveText(state.formatDeclination(state.solutionDec)),
              ]),
              displayAltAz
                  ? Column(children: [
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            scaledText("Azimuth"),
                            state.solveText(state.formatAzimuth(
                                state.locationBasedInfo!.azimuth))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            scaledText("Altitude"),
                            state.solveText(state.formatAltitude(
                                state.locationBasedInfo!.altitude))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            scaledText("Hour angle"),
                            state.solveText(state.formatHourAngle(
                                state.locationBasedInfo!.hourAngle))
                          ]),
                    ])
                  : Container(),
            ],
          ),
        )),
      ),
    );
  });

  Overlay.of(context).insert(dialogOverlayEntry);
}
