// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

Future<void> perfStatsDialog(
    MyHomePageState state, BuildContext context) async {
  OverlayEntry? dialogOverlayEntry;

  Timer timer = Timer.periodic(const Duration(seconds: 1), (_) async {
    dialogOverlayEntry?.markNeedsBuild();
  });

  Color color = Theme.of(context).colorScheme.primary;
  final width = 200.0 * textScaleFactor(context);

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    return GestureDetector(
      onTap: () {
        timer.cancel();
        dialogOverlayEntry!.remove();
      },
      child: Material(
        color: Colors.black54,
        child: Center(
            child: Container(
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
                Text(
                  "Performance",
                  textScaler: textScaler(context),
                ),
              ]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Exposure time",
                  textScaler: textScaler(context),
                ),
                Text(
                  sprintf("%.1f ms", [state.exposureTimeMs]),
                  textScaler: textScaler(context),
                ),
              ]),
              state.processingStats != null
                  ? Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Detect",
                              textScaler: textScaler(context),
                            ),
                            Text(
                              sprintf("%.1f ms", [
                                state.processingStats!.detectLatency.recent
                                        .mean *
                                    1000
                              ]),
                              textScaler: textScaler(context),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Solve",
                              textScaler: textScaler(context),
                            ),
                            Text(
                              sprintf("%.1f ms", [
                                state.processingStats!.solveLatency.recent
                                        .mean *
                                    1000
                              ]),
                              textScaler: textScaler(context),
                            ),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Solve attempt",
                              textScaler: textScaler(context),
                            ),
                            Text(
                              sprintf("%2d%%", [
                                (state.processingStats!.solveAttemptFraction
                                            .recent.mean *
                                        100)
                                    .toInt()
                              ]),
                              textScaler: textScaler(context),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Solve success",
                              textScaler: textScaler(context),
                            ),
                            Text(
                              sprintf("%2d%%", [
                                (state.processingStats!.solveSuccessFraction
                                            .recent.mean *
                                        100)
                                    .toInt()
                              ]),
                              textScaler: textScaler(context),
                            ),
                          ]),
                    ])
                  : Container(),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "RMS Error",
                  textScaler: textScaler(context),
                ),
                Text(
                  state.solutionRMSE > 60
                      ? sprintf("%.1f arcmin", [state.solutionRMSE / 60])
                      : sprintf("%.0f arcsec", [state.solutionRMSE]),
                  textScaler: textScaler(context),
                ),
                // solveText(),
              ]),
            ],
          ),
        )),
      ),
    );
  });

  Overlay.of(context).insert(dialogOverlayEntry);
}
