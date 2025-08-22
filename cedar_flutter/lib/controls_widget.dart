// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

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

  // Callbacks.
  final Function(Preferences) onPreferencesUpdate;
  final Function(OperationSettings) onOperationSettingsUpdate;
  final VoidCallback onGoFullScreen;
  final VoidCallback onCancelFullScreen;
  final Function(bool) onSetWakeLock;
  final Function(bool) onSetDaylightMode;

  // Button factories.
  final Widget Function({double? fontSize}) focusDoneButton;
  final Widget Function({double? fontSize}) setupAlignSkipOrDoneButton;
  final Widget Function({double? fontSize}) slewReAlignButton;
  final Widget Function({double? fontSize}) catalogButton;
  final Widget Function({double? fontSize}) endGotoButton;

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
    required this.onPreferencesUpdate,
    required this.onOperationSettingsUpdate,
    required this.onGoFullScreen,
    required this.onCancelFullScreen,
    required this.onSetWakeLock,
    required this.onSetDaylightMode,
    required this.focusDoneButton,
    required this.setupAlignSkipOrDoneButton,
    required this.slewReAlignButton,
    required this.catalogButton,
    required this.endGotoButton,
    required this.scaledText,
    required this.rowOrColumn,
  });

  @override
  Widget build(BuildContext context) {
    var settingsModel = Provider.of<SettingsModel>(context, listen: false);
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final color = Theme.of(context).colorScheme.primary;

    // Scale widgets based on constraining dimension
    final constraints = MediaQuery.of(context).size;
    final constrainingDimension = portrait ? constraints.width : constraints.height;
    const referenceSize = 400.0;
    final dimensionBasedScale = (constrainingDimension / referenceSize).clamp(0.5, 1.0);

    final panelScaleFactor = dimensionBasedScale;
    final textScale = textScaleFactor(context);

    // Calculate responsive sizes based on panel scale and text scale.
    final textBoxWidth = 90 * panelScaleFactor * textScale;
    final textBoxHeight = 100 * panelScaleFactor * textScale;
    final buttonWidth = 55 * panelScaleFactor * textScale;
    final buttonHeight = 20 * panelScaleFactor * textScale;
    final buttonFont = 11.0 * panelScaleFactor;

    final controlWidgets = <Widget>[
        // Settings consumer - handles preference updates.
        Consumer<SettingsModel>(
          builder: (context, settings, child) {
            final newPrefs = settings.preferencesProto;
            var prefsDiff = newPrefs.deepCopy();
            if (preferences != null && diffPreferences(preferences!, prefsDiff)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onPreferencesUpdate(prefsDiff);
              });
              if (prefsDiff.hasHideAppBar()) {
                if (prefsDiff.hideAppBar) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onGoFullScreen();
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    onCancelFullScreen();
                  });
                }
              }
              if (prefsDiff.hasScreenAlwaysOn()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onSetWakeLock(prefsDiff.screenAlwaysOn);
                });
              }
            }
            final newOpSettings = settings.opSettingsProto;
            var opSettingsDiff = newOpSettings.deepCopy();
            if (diffOperationSettings(operationSettings, opSettingsDiff)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onOperationSettingsUpdate(opSettingsDiff);
              });
            }
            return Container();
          },
        ),

        // Main instruction text
        RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: focusAid
              ? SizedBox(
                  width: textBoxWidth,
                  height: textBoxHeight,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        daylightMode
                            ? "Tap to select focus area"
                            : "Adjust focus",
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: color, fontSize: 11 * panelScaleFactor),
                        textScaler: textScaler(context),
                      )))
              : (canAlign && slewRequest == null
                  ? daylightMode
                      ? SizedBox(
                          width: textBoxWidth,
                          height: textBoxHeight,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Tap image where scope is pointed",
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
                                    "Move scope to center a highlighted object, then tap object",
                                    maxLines: 8,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: color,
                                        fontSize: 10 * panelScaleFactor),
                                    textScaler: textScaler(context),
                                  ))),
                        ])
                  : Container()),
        ),

        const SizedBox(height: 10),

        // Main control buttons.
        RotatedBox(
          quarterTurns: portrait ? 3 : 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Done/Skip button.
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
                        : (slewRequest == null &&
                                !setupMode &&
                                !settingsModel.isDIY &&
                                showCatalogBrowser
                            ? catalogButton(fontSize: buttonFont)
                            : Container())),
              ),

              // Day checkbox (only in setup mode).
              if (setupMode) ...[
                Column(
                  children: [
                    SizedBox(height: 10 * panelScaleFactor),
                    Transform.scale(
                      scale: panelScaleFactor,
                      child: TextButton.icon(
                          label: scaledText("Day"),
                          icon: daylightMode
                              ? const Icon(Icons.check)
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () async {
                            onSetDaylightMode(!daylightMode);
                          }),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Catalog button during slew.
        if (slewRequest != null && !setupMode && showCatalogBrowser) ...[
          RotatedBox(
              quarterTurns: portrait ? 3 : 0,
              child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: catalogButton(fontSize: buttonFont))),
        ],

        const SizedBox(height: 10),

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
      mainAxisSize: MainAxisSize.min,
      children: portrait ? controlWidgets.reversed.toList() : controlWidgets,
    );
  }
}