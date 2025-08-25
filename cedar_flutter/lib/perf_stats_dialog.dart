// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/cedar.pb.dart' as cedar_rpc;
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

// Dialog layout constants
const double _kDialogWidth = 200.0;
const double _kBorderRadius = 10.0;
const EdgeInsets _kDialogPadding = EdgeInsets.fromLTRB(10, 5, 10, 10);
const Duration _kUpdateInterval = Duration(seconds: 1);
const double groupGap = 6.0;

Text _scaledText(String str, BuildContext context) {
  return Text(str,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      textScaler: textScaler(context));
}

String _formatPercentage(double value) {
  return sprintf("%2d", [(value * 100).toInt()]);
}

String _formatMilliseconds(double seconds) {
  double millis = seconds * 1000;
  if (millis >= 10.0) {
    return sprintf("%.0f", [millis]);
  } else {
    return sprintf("%.1f", [millis]);
  }
}

String _formatHz(double seconds) {
  if (seconds > 0.0) {
    double hz = 1.0 / seconds;
    if (hz >= 10.0) {
      return sprintf("%.0f", [hz]);
    } else {
      return sprintf("%.1f", [hz]);
    }
  }
  return "0.0";
}

/// A row widget that displays a label and value with optional bold styling and tap handling.
///
/// Used in the performance stats dialog to show metrics. Supports:
/// - Bold text styling for selected metrics
/// - Tap callbacks for interactive rows
/// - Consistent styling with theme colors and text scaling
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;
  final bool bold;
  final VoidCallback? onTap;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.context,
    this.bold = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      height: 1.25,
      color: Theme.of(context).colorScheme.primary,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textStyle,
          textScaler: textScaler(context),
        ),
        Text(
          value,
          style: textStyle,
          textScaler: textScaler(context),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 18 * textScaleFactor(context),
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
          child: row,
        ),
      );
    }
    return row;
  }
}

/// Displays a performance statistics overlay dialog with clickable metric selection.
///
/// Shows various performance metrics including exposure time, star count, solve rates,
/// and timing statistics. Users can click on exposure time, stars, or solve interval
/// to select which metric is displayed in the main UI gauge.
///
/// The dialog updates every second and closes when tapping outside the dialog area.
Future<void> perfStatsDialog(
    MyHomePageState state, BuildContext context) async {

  // Helper function to update gauge choice
  Future<void> updateGaugeChoice(String choice) async {
    // Copy existing preferences and update only the specific field
    var prefs = state.preferences?.deepCopy() ?? cedar_rpc.Preferences();
    prefs.perfGaugeChoice = choice;
    await state.updatePreferences(prefs);
  }

  OverlayEntry? dialogOverlayEntry;
  GlobalKey dialogOverlayKey = GlobalKey();

  Timer timer = Timer.periodic(_kUpdateInterval, (_) async {
    dialogOverlayEntry?.markNeedsBuild();
  });

  Color color = Theme.of(context).colorScheme.primary;
  final width = _kDialogWidth * textScaleFactor(context);

  bool tapInsideOverlay = false;

  dialogOverlayEntry = OverlayEntry(builder: (BuildContext context) {
    // Get current gauge choice preference (recalculated on each rebuild)
    String currentChoice = (state.preferences?.perfGaugeChoice.isEmpty ?? true)
        ? "stars"
        : state.preferences!.perfGaugeChoice;
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
              padding: _kDialogPadding,
              decoration: BoxDecoration(
                border: Border.all(color: color),
                color: Colors.black,
                borderRadius: BorderRadius.circular(_kBorderRadius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _scaledText("Performance", context),
                  ]),
                  SizedBox(height: groupGap * textScaleFactor(context)),
                  StatRow(
                    context: context,
                    label: "Exposure time",
                    value: sprintf("%.0f ms", [state.exposureTimeMs]),
                    bold: currentChoice == "exposure_time",
                    onTap: () async {
                      await updateGaugeChoice("exposure_time");
                      dialogOverlayEntry!.markNeedsBuild();
                    },
                  ),
                  StatRow(
                    context: context,
                    label: "Stars",
                    value: sprintf("%d", [state.numStars]),
                    bold: currentChoice == "stars",
                    onTap: () async {
                      await updateGaugeChoice("stars");
                      dialogOverlayEntry!.markNeedsBuild();
                    },
                  ),
                  SizedBox(height: groupGap * textScaleFactor(context)),
                  ...[ if (state.processingStats != null)
                    Column(children: [
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Acquire",
                          value: sprintf("%s ms", [_formatMilliseconds(
                            state.processingStats!.acquireLatency.recent.mean
                          )]),
                        ),
                      ],
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Detect+Solve",
                          value: sprintf("%s+%s ms", [
                            _formatMilliseconds(
                              state.processingStats!.detectLatency.recent.mean),
                            _formatMilliseconds(
                              state.processingStats!.solveLatency.recent.mean),
                          ]),
                        ),
                      ],
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Serve",
                          value: sprintf("%s ms", [_formatMilliseconds(
                            state.processingStats!.serveLatency.recent.mean
                          )]),
                        ),
                      ],
                      SizedBox(height: groupGap * textScaleFactor(context)),
                      StatRow(
                        context: context,
                        label: "Solve try/pass",
                        value: sprintf("%s/%s %", [
                          _formatPercentage(
                            state.processingStats!.solveAttemptFraction.recent.mean),
                          _formatPercentage(
                            state.processingStats!.solveSuccessFraction.recent.mean),
                        ]),
                      ),
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Solve rate",
                          value: sprintf("%s Hz", [_formatHz(
                            state.processingStats!.solveInterval.recent.mean
                          )]),
                          bold: currentChoice == "solve_interval",
                          onTap: () async {
                            await updateGaugeChoice("solve_interval");
                            dialogOverlayEntry!.markNeedsBuild();
                          },
                        ),
                      ],
                    ])
                  ],
                  SizedBox(height: groupGap * textScaleFactor(context)),
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
