// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

Future<void> perfStatsDialog(
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
  final width = 200.0 * textScaleFactor(context);

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
      },
      child: Material(
        color: Colors.black54,
        child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
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
                    scaledText("Performance"),
                  ]),
                  const SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        scaledText("Exposure time"),
                        scaledText(sprintf("%.0f ms", [state.exposureTimeMs])),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        scaledText("Stars"),
                        scaledText(sprintf("%d", [state.numStars])),
                      ]),
                  state.processingStats != null
                      ? Column(children: [
                          state.advanced
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      scaledText("Detect"),
                                      scaledText(sprintf("%.1f ms", [
                                        state.processingStats!.detectLatency
                                                .recent.mean *
                                            1000
                                      ])),
                                    ])
                              : Container(),
                          state.advanced
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      scaledText("Solve"),
                                      scaledText(sprintf("%.1f ms", [
                                        state.processingStats!.solveLatency
                                                .recent.mean *
                                            1000
                                      ])),
                                    ])
                              : Container(),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                scaledText("Solve attempt"),
                                scaledText(sprintf("%2d%%", [
                                  (state.processingStats!.solveAttemptFraction
                                              .recent.mean *
                                          100)
                                      .toInt()
                                ])),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                scaledText("Solve success"),
                                scaledText(sprintf("%2d%%", [
                                  (state.processingStats!.solveSuccessFraction
                                              .recent.mean *
                                          100)
                                      .toInt()
                                ])),
                              ]),
                          state.advanced
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      scaledText("Solve interval"),
                                      scaledText(sprintf("%.0f ms", [
                                        state.processingStats!.solveInterval
                                                .recent.mean *
                                            1000
                                      ])),
                                    ])
                              : Container(),
                        ])
                      : Container(),
                  const SizedBox(height: 10),
                  state.advanced
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              scaledText("Position RMSE"),
                              scaledText(state.solutionRMSE > 60
                                  ? sprintf(
                                      "%.1f arcmin", [state.solutionRMSE / 60])
                                  : sprintf(
                                      "%.0f arcsec", [state.solutionRMSE])),
                            ])
                      : Container(),
                  state.advanced
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              scaledText("Image noise"),
                              scaledText(
                                  sprintf("%.1f ADU", [state.noiseEstimate])),
                            ])
                      : Container(),
                ],
              ),
            ))),
      ),
    );
  });

  Overlay.of(context).insert(dialogOverlayEntry);
}
