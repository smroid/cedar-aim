// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          textScaler: textScaler(context),
        ),
        Text(
          value,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
          textScaler: textScaler(context),
        ),
      ],
    );
  }
}

Future<void> perfStatsDialog(
    MyHomePageState state, BuildContext context) async {
  Text scaledText(String str) {
    return Text(str,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        textScaler: textScaler(context));
  }

  String formatPercentage(double value) {
    return sprintf("%2d%%", [(value * 100).toInt()]);
  }

  String formatMilliseconds(double seconds) {
    return sprintf("%.1f ms", [seconds * 1000]);
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
                  StatRow(
                    context: context,
                    label: "Exposure time",
                    value: sprintf("%.0f ms", [state.exposureTimeMs]),
                  ),
                  StatRow(
                    context: context,
                    label: "Stars",
                    value: sprintf("%d", [state.numStars]),
                  ),
                  ...[ if (state.processingStats != null)
                    Column(children: [
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Detect",
                          value: formatMilliseconds(
                            state.processingStats!.detectLatency.recent.mean
                          ),
                        ),
                      ],
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Solve",
                          value: formatMilliseconds(
                            state.processingStats!.solveLatency.recent.mean
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      StatRow(
                        context: context,
                        label: "Solve attempt",
                        value: formatPercentage(
                          state.processingStats!.solveAttemptFraction.recent.mean
                        ),
                      ),
                      StatRow(
                        context: context,
                        label: "Solve success",
                        value: formatPercentage(
                          state.processingStats!.solveSuccessFraction.recent.mean
                        ),
                      ),
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Solve interval",
                          value: formatMilliseconds(
                            state.processingStats!.solveInterval.recent.mean
                          ),
                        ),
                      ],
                    ])
                  ],
                  const SizedBox(height: 10),
                  ...[ if (state.advanced)
                    StatRow(
                      context: context,
                      label: "Position RMSE",
                      value: state.solutionRMSE > 60
                          ? sprintf("%.1f arcmin", [state.solutionRMSE / 60])
                          : sprintf("%.0f arcsec", [state.solutionRMSE]),
                    ),
                  ],
                  ...[ if (state.advanced)
                    StatRow(
                      context: context,
                      label: "Image noise",
                      value: sprintf("%.1f ADU", [state.noiseEstimate]),
                    ),
                  ],
                ],
              ),
            ))),
      ),
    );
  });

  Overlay.of(context).insert(dialogOverlayEntry);
}
