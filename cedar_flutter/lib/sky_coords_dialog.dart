// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'cedar.pbgrpc.dart' as cedar_rpc;

Future<void> skyCoordsDialog(
    MyHomePageState state, BuildContext context) async {
  final Color color = Theme.of(context).colorScheme.primary;

  Text scaledText(String str, bool highlight) {
    return Text(str,
        style: TextStyle(
          color: color,
          fontWeight: highlight ? FontWeight.bold : null,
        ),
        textScaler: textScaler(context));
  }

  OverlayEntry? dialogOverlayEntry;
  final GlobalKey dialogOverlayKey = GlobalKey();

  Timer timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    dialogOverlayEntry?.markNeedsBuild();
  });

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    bool tapInsideOverlay = false;
    bool displayAltAz = state.locationBasedInfo != null;
    bool preferRaDec = false;
    bool preferAzAlt = false;
    if (state.preferences != null && displayAltAz) {
      if (state.preferences!.celestialCoordChoice ==
          cedar_rpc.CelestialCoordChoice.RA_DEC) {
        preferRaDec = true;
      } else {
        preferAzAlt = true;
      }
    }
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
      },
      child: Material(
        color: Colors.black54,
        child: Center(
            child: Container(
          key: dialogOverlayKey,
          width: 210.0 * textScaleFactor(context),
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
                scaledText("Sky Location", false),
              ]),
              const SizedBox(height: 5),
              GestureDetector(
                  onTap: () async {
                    var prefs = cedar_rpc.Preferences();
                    prefs.celestialCoordChoice =
                        cedar_rpc.CelestialCoordChoice.RA_DEC;
                    await state.updatePreferences(prefs);
                    dialogOverlayEntry!.markNeedsBuild();
                  },
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          scaledText(
                              "Right ascension", /*highlight=*/ preferRaDec),
                          state.solveText(
                              state.formatRightAscension(state.solutionRA)),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          scaledText("Declination", /*highlight=*/ preferRaDec),
                          state.solveText(
                              state.formatDeclination(state.solutionDec)),
                        ])
                  ])),
              displayAltAz
                  ? GestureDetector(
                      onTap: () async {
                        var prefs = cedar_rpc.Preferences();
                        prefs.celestialCoordChoice =
                            cedar_rpc.CelestialCoordChoice.ALT_AZ_HA;
                        await state.updatePreferences(prefs);
                        dialogOverlayEntry!.markNeedsBuild();
                      },
                      child: Column(children: [
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              scaledText("Azimuth", /*highlight=*/ preferAzAlt),
                              state.solveText(state.formatAzimuth(
                                  state.locationBasedInfo!.azimuth))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              scaledText(
                                  "Altitude", /*highlight=*/ preferAzAlt),
                              state.solveText(state.formatAltitude(
                                  state.locationBasedInfo!.altitude))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              scaledText(
                                  "Hour angle", /*highlight=*/ preferAzAlt),
                              state.solveText(state.formatHourAngle(
                                  state.locationBasedInfo!.hourAngle))
                            ]),
                      ]))
                  : Container(),
            ],
          ),
        )),
      ),
    );
  });

  Overlay.of(context).insert(dialogOverlayEntry);
}
