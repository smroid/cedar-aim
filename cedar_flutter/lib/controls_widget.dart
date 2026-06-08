// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:math' as math;

import 'package:cedar_flutter/cedar.pb.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget that builds the controls interface for the Cedar Aim app. The
/// controls are grouped together in a "pane" that is below the main image or
/// to its left or right in landscape mode.
class ControlsWidget extends StatelessWidget {
  // Layout state.
  final Map<String, double> layoutCalculations;

  // App state.
  final bool focusAid;
  final bool daylightMode;
  final bool canAlign;
  final bool setupMode;
  final dynamic slewRequest;
  final dynamic boresightImageBytes;
  final Preferences? preferences;
  final OperationSettings operationSettings;
  final bool showCatalogBrowser;
  final bool skipFocus;
  final bool skipAlignment;
  final bool skipFocusActive;

  // Callbacks.
  final Function(bool) onSetDaylightMode;
  final Function(bool) onSkipFocusUpdate;
  final Function(bool) onSkipAlignmentUpdate;

  // Button factories.
  final Widget Function({double? fontSize}) focusDoneButton;
  final Widget Function({double? fontSize}) setupAlignSkipOrDoneButton;
  final Widget Function({double? fontSize}) slewReAlignButton;
  final Widget Function(double size) catalogButton;
  final Widget Function({double? fontSize}) endGotoButton;
  final Widget Function(double size, double scaleFactor) perfGauge;

  // Helper functions.
  final Widget Function(String) scaledText;
  final Widget Function(bool portrait, List<Widget> children) rowOrColumn;

  const ControlsWidget({
    super.key,
    required this.layoutCalculations,
    required this.focusAid,
    required this.daylightMode,
    required this.canAlign,
    required this.setupMode,
    required this.slewRequest,
    required this.boresightImageBytes,
    required this.preferences,
    required this.operationSettings,
    required this.showCatalogBrowser,
    required this.skipFocus,
    required this.skipAlignment,
    required this.skipFocusActive,
    required this.onSetDaylightMode,
    required this.onSkipFocusUpdate,
    required this.onSkipAlignmentUpdate,
    required this.focusDoneButton,
    required this.setupAlignSkipOrDoneButton,
    required this.slewReAlignButton,
    required this.catalogButton,
    required this.endGotoButton,
    required this.perfGauge,
    required this.scaledText,
    required this.rowOrColumn,
  });

  @override
  Widget build(BuildContext context) {
    var settingsModel = Provider.of<SettingsModel>(context, listen: false);
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final color = Theme.of(context).colorScheme.primary;

    final textScale = textScaleFactor(context);

    // Use the same panelScaleFactor formula as _dataItems so that sizing
    // tracks available panel space consistently across both panels.
    final constraints = MediaQuery.of(context).size;
    final shortDimension = portrait ? constraints.width : constraints.height;
    final panelWidth = layoutCalculations['panelWidth']!;
    final coordInfoSize = 85.0 * textScale;
    final objectLabelSize = 60.0 * textScale;
    final mainDimensionBasedScale = shortDimension / (2.0 * coordInfoSize + objectLabelSize);
    final crossDimensionBasedScale = panelWidth / math.max(coordInfoSize, objectLabelSize);
    final panelScaleFactor = math.min(mainDimensionBasedScale, crossDimensionBasedScale).clamp(0.5, 1.2);

    // Calculate responsive sizes based on panel scale and text scale.
    final textBoxWidth = 90 * panelScaleFactor * textScale;
    final textBoxHeight = 100 * panelScaleFactor * textScale;
    final buttonWidth = 55 * panelScaleFactor * textScale;
    final buttonHeight = 20 * panelScaleFactor * textScale;
    final buttonFont = 11.0 * panelScaleFactor;
    final catalogButtonSize = 40.0 * panelScaleFactor * textScale;

    final rightHanded = settingsModel.preferencesProto.rightHanded;

    // Builds the instruction text widget for focus/align setup modes.
    Widget instructionText() => RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: focusAid
              ? SizedBox(
                  width: textBoxWidth,
                  height: textBoxHeight,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        skipFocusActive
                            ? "Retrying..."
                            : (daylightMode
                                ? "Tap to select focus area"
                                : "Adjust focus"),
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: color, fontSize: 11 * panelScaleFactor),
                        textScaler: textScaler(context),
                      )))
              : daylightMode
                  ? SizedBox(
                      width: textBoxWidth,
                      height: textBoxHeight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "2. Tap image where scope is pointed",
                            maxLines: 8,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: color,
                                fontSize: 12 * panelScaleFactor),
                            textScaler: textScaler(context),
                          )))
                  : rowOrColumn(portrait, [
                      SizedBox(
                          width: textBoxWidth,
                          height: textBoxHeight,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "3. Tap object scope is pointed at",
                                maxLines: 8,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12 * panelScaleFactor),
                                textScaler: textScaler(context),
                              ))),
                    ]),
        );

    final controlWidgets = <Widget>[
        // Instruction text slot A: shown before buttons in landscape and
        // right-handed portrait (buttons end up on the right after reversal).
        if ((focusAid || (canAlign && slewRequest == null)) &&
            (!portrait || rightHanded)) ...[
          instructionText(),
        ],

        // In mission mode, the gauge and catalog button are adjacent. Their
        // order depends on orientation and handedness:
        //   Landscape: gauge above, catalog below (gauge earlier in list).
        //   Portrait right-handed: catalog on right, gauge on left
        //     → catalog earlier in list (list is reversed for portrait).
        //   Portrait left-handed: gauge on right, catalog on left
        //     → gauge earlier in list.
        // So: gauge comes before catalog in list UNLESS portrait + right-handed.
        // We split the main button block and gauge into two ordered slots.

        // Slot A: gauge (mission mode, landscape or right-handed portrait).
        if (!setupMode && slewRequest == null &&
            (!portrait || rightHanded)) ...[
          RotatedBox(
            quarterTurns: portrait ? 3 : 0,
            child: perfGauge(45 * panelScaleFactor * textScale, panelScaleFactor),
          ),
        ],

        // Main control buttons (omitted entirely on DIY mission mode with no
        // visible button, so the gauge centers via spaceEvenly).
        if (focusAid || canAlign ||
            (!setupMode && !settingsModel.isDIY && showCatalogBrowser)) ...[
        RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Done/Skip button or Exit button.
              if (skipFocusActive && focusAid) ...[
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      onSkipFocusUpdate(false);
                    },
                    child: Text(
                      "Exit",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: buttonFont),
                      textScaler: textScaler(context),
                    ),
                  ),
                ),
              ] else if (!skipFocus || canAlign || !setupMode) ...[
                if (slewRequest == null &&
                    !setupMode &&
                    !focusAid &&
                    !canAlign &&
                    !settingsModel.isDIY &&
                    showCatalogBrowser)
                  catalogButton(catalogButtonSize)
                else
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: focusAid
                        ? focusDoneButton(fontSize: buttonFont)
                        : (canAlign
                            ? (slewRequest == null
                                ? setupAlignSkipOrDoneButton(fontSize: buttonFont)
                                : (boresightImageBytes != null
                                    ? slewReAlignButton(fontSize: buttonFont)
                                    : Container()))
                            : Container()),
                  ),
              ],

              // Skip and Day checkboxes (only in setup mode).
              if (setupMode) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5 * panelScaleFactor),
                    if (!skipFocus || !focusAid) ...[
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * panelScaleFactor),
                            iconSize: 18 * panelScaleFactor,
                          ),
                          label: scaledText("Day"),
                          icon: daylightMode
                              ? const Icon(Icons.check)
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () async {
                            onSetDaylightMode(!daylightMode);
                          }),
                    ],
                    if (focusAid && !daylightMode && !skipFocusActive) ...[
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * panelScaleFactor),
                            iconSize: 18 * panelScaleFactor,
                          ),
                          label: scaledText("Skip"),
                          icon: skipFocus
                              ? const Icon(Icons.check)
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            onSkipFocusUpdate(!skipFocus);
                          }),
                    ] else if (canAlign && slewRequest == null &&
                               !daylightMode && !skipFocusActive) ...[
                      TextButton.icon(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * panelScaleFactor),
                            iconSize: 18 * panelScaleFactor,
                          ),
                          label: scaledText("Skip"),
                          icon: skipAlignment
                              ? const Icon(Icons.check)
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            onSkipAlignmentUpdate(!skipAlignment);
                          }),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        ],

        // Instruction text slot B: left-handed portrait only (buttons end up
        // on the left after reversal, instruction text on the right).
        if ((focusAid || (canAlign && slewRequest == null)) &&
            portrait && !rightHanded) ...[
          instructionText(),
        ],

        // Slot B: gauge (mission mode, left-handed portrait only).
        if (!setupMode && slewRequest == null &&
            portrait && !rightHanded) ...[
          RotatedBox(
            quarterTurns: 3,
            child: perfGauge(45 * panelScaleFactor * textScale, panelScaleFactor),
          ),
        ],

        // Catalog button during slew.
        if (slewRequest != null && !setupMode && showCatalogBrowser) ...[
          RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: catalogButton(catalogButtonSize)),
        ],

        // End goto button.
        if (slewRequest != null && !setupMode) ...[
          RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: endGotoButton(fontSize: buttonFont))),
        ],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: portrait ? controlWidgets.reversed.toList() : controlWidgets,
    );
  }
}