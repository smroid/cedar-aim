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

Text _scaledText(String str, BuildContext context) {
  return Text(str,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      textScaler: textScaler(context));
}

String _formatPercentage(double value) {
  return sprintf("%2d%%", [(value * 100).toInt()]);
}

String _formatMilliseconds(double seconds) {
  return sprintf("%.1f ms", [seconds * 1000]);
}

String _formatHz(double seconds) {
  if (seconds > 0.0) {
    return sprintf("%.1f Hz", [1.0 / seconds]);
  }
  return "0.0 Hz";
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
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                  const SizedBox(height: 5),
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
                  ...[ if (state.processingStats != null)
                    Column(children: [
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Detect",
                          value: _formatMilliseconds(
                            state.processingStats!.detectLatency.recent.mean
                          ),
                        ),
                      ],
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Solve",
                          value: _formatMilliseconds(
                            state.processingStats!.solveLatency.recent.mean
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      StatRow(
                        context: context,
                        label: "Solve attempt",
                        value: _formatPercentage(
                          state.processingStats!.solveAttemptFraction.recent.mean
                        ),
                      ),
                      StatRow(
                        context: context,
                        label: "Solve success",
                        value: _formatPercentage(
                          state.processingStats!.solveSuccessFraction.recent.mean
                        ),
                      ),
                      ...[ if (state.advanced)
                        StatRow(
                          context: context,
                          label: "Solve rate",
                          value: _formatHz(
                            state.processingStats!.solveInterval.recent.mean
                          ),
                          bold: currentChoice == "solve_interval",
                          onTap: () async {
                            await updateGaugeChoice("solve_interval");
                            dialogOverlayEntry!.markNeedsBuild();
                          },
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
