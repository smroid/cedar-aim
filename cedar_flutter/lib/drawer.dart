// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:path/path.dart' as path;
import 'package:sprintf/sprintf.dart';

import 'package:cedar_flutter/about.dart';
import 'package:cedar_flutter/bluetooth.dart';
import 'package:cedar_flutter/cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/geolocation.dart';
import 'package:cedar_flutter/overlay_popup.dart';
import 'package:cedar_flutter/server_log.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:cedar_flutter/shutdown_dialog.dart';
import 'platform.dart';

const double _kDrawerSpacing = 10.0;
const double _kDrawerSpacingCondensed = 5.0;

/// Interface for drawer state and callbacks.
class CedarDrawerController {
  // State variables
  final bool setupMode;
  final bool focusAid;
  final bool offerMap;
  final LatLng? mapPosition;
  final bool advanced;
  final bool expert;
  final bool demoMode;
  final List<String> demoFiles;
  final bool systemMenuExpanded;
  final bool connectionMenuExpanded;
  final String demoFile;
  final bool isDIY;
  final bool badServerState;
  final UpdaterInfo? updaterInfo;
  final bool updateServiceAvailable;
  final WifiAccessPointDialogFunction? wifiAccessPointDialog;
  final bool skipFocus;
  final bool skipAlignment;
  final String productName;

  // Callbacks
  final AppLogCallbacks? appLogCallbacks;
  final void Function(bool setupMode, bool focusAid) setOperatingMode;
  final void Function(String) setDemoImage;
  final Future<String?> Function() saveImage;
  final Future<String> Function() getServerLogs;
  final Future<void> Function() crashServer;
  final Future<void> Function() restartCedarServer;
  final Future<void> Function(cedar_rpc.ActionRequest) initiateAction;
  final Future<void> Function(cedar_rpc.Preferences) updatePreferences;
  final void Function(bool) setAdvanced;
  final void Function(bool) setExpert;
  final void Function(bool) setDemoMode;
  final Function(bool) setSystemMenuExpanded;
  final Function(bool) setConnectionMenuExpanded;
  final VoidCallback onStateChanged;
  final VoidCallback closeDrawer;

  // Context and styling
  final BuildContext context;
  final MyHomePageState homePageState;

  // Optional callback for RA/Dec Goto dialog (Advanced only).
  final VoidCallback? onGotoRaDec;

  CedarDrawerController({
    required this.setupMode,
    required this.focusAid,
    required this.offerMap,
    required this.mapPosition,
    required this.advanced,
    required this.expert,
    required this.demoMode,
    required this.demoFiles,
    required this.systemMenuExpanded,
    required this.connectionMenuExpanded,
    required this.demoFile,
    required this.isDIY,
    required this.badServerState,
    required this.updaterInfo,
    required this.updateServiceAvailable,
    required this.wifiAccessPointDialog,
    required this.skipFocus,
    required this.skipAlignment,
    required this.productName,
    required this.setOperatingMode,
    required this.setDemoImage,
    required this.saveImage,
    required this.getServerLogs,
    this.appLogCallbacks,
    required this.crashServer,
    required this.restartCedarServer,
    required this.initiateAction,
    required this.updatePreferences,
    required this.setAdvanced,
    required this.setExpert,
    required this.setDemoMode,
    required this.setSystemMenuExpanded,
    required this.setConnectionMenuExpanded,
    required this.onStateChanged,
    required this.closeDrawer,
    required this.context,
    required this.homePageState,
    this.onGotoRaDec,
  });
}

/// Custom drawer widget for the Cedar Aim app
class CedarDrawer extends StatelessWidget {
  final CedarDrawerController controller;

  const CedarDrawer({
    super.key,
    required this.controller,
  });

  Color get primaryColor => Theme.of(controller.context).colorScheme.primary;

  // Helper methods for text styling
  Text _scaledText(String text) {
    return Text(
      text,
      textScaler: textScaler(controller.context),
      style: TextStyle(
        color: primaryColor,
      ),
    );
  }

  Text _primaryText(String text, {double? size}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: (size ?? 14) * textScaleFactor(controller.context),
        color: primaryColor,
      ),
    );
  }

  String _removeExtension(String filename) {
    return path.basenameWithoutExtension(filename);
  }

  // Helper method to generate contextual message for re-enabling focus/align steps.
  String _getReenableButtonLabel(bool skipFocus, bool skipAlignment) {
    if (skipFocus && skipAlignment) {
      return "Re-enable focus/align steps";
    } else if (skipFocus) {
      return "Re-enable focus step";
    } else {
      return "Re-enable alignment step";
    }
  }

  // Helper method for Check for Update button.
  Widget? _buildCheckForUpdateButton() {
    if (controller.updaterInfo == null) {
      return null;
    }
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          // Normal tap: filter some files when looking for Cedar updates.
          controller.closeDrawer();
          controller.updaterInfo!.updateServerSoftwareDialogFunction(
            controller.homePageState,
            controller.context,
            filterUpdateFiles: true,
          );
        },
        onLongPress: () {
          // Long press: show all updates (useful for debugging).
          controller.closeDrawer();
          controller.updaterInfo!.updateServerSoftwareDialogFunction(
            controller.homePageState,
            controller.context,
            filterUpdateFiles: false,
          );
        },
        child: TextButton.icon(
          style: TextButton.styleFrom(disabledForegroundColor: primaryColor),
          label: _scaledText("Check for Update"),
          icon: const Icon(Icons.system_update_alt),
          onPressed: null, // Handled by GestureDetector.
        ),
      ),
    );
  }

  // Helper method for Restart Cedar Server button.
  Widget? _buildRestartServerButton() {
    if (controller.updaterInfo == null) {
      return null;
    }
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton.icon(
          label: _scaledText("Restart Cedar Server"),
          icon: const Icon(Icons.restart_alt),
          onPressed: () {
            // Show confirmation dialog since this affects the running system
            showDialog(
              context: controller.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Restart Cedar Server", style: TextStyle(color: primaryColor)),
                  content: Text("This will restart the Cedar server component. The app will reconnect automatically. Continue?", style: TextStyle(color: primaryColor)),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel", style: TextStyle(color: primaryColor)),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        controller.closeDrawer();

                        // Capture context before async call
                        final scaffoldContext = controller.context;

                        try {
                          await controller.updaterInfo!.restartCedarServerFunction();
                          // Show success message
                          if (scaffoldContext.mounted) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              const SnackBar(content: Text("Cedar server restart initiated")),
                            );
                          }
                        } catch (e) {
                          // Show error message
                          if (scaffoldContext.mounted) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              SnackBar(
                                content: Text("Failed to restart Cedar server: $e"),
                              ),
                            );
                          }
                        }
                      },
                      child: Text("Restart", style: TextStyle(color: primaryColor)),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 240 * textScaleFactor(context),
        child: ListView(
          padding: EdgeInsets.zero,
          children: _buildDrawerControls(),
        ),
      ),
    );
  }

  List<Widget> _buildBadServerStateControls() {
    return <Widget>[
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
      const CloseButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white10),
              alignment: Alignment.center)),
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

      // Only show Server Recovery section if update service is available
      if (controller.updaterInfo != null && controller.updateServiceAvailable) ...[
        Center(
          child: _scaledText("Server Recovery"),
        ),
        SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
        if (_buildCheckForUpdateButton() != null) ...[
          _buildCheckForUpdateButton()!,
          SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
        ],
        if (_buildRestartServerButton() != null) ...[
          _buildRestartServerButton()!,
          SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
        ],
      ],
    ];
  }

  List<Widget> _buildDrawerControls() {
    // Show simplified menu during bad server state.
    if (controller.badServerState) {
      return _buildBadServerStateControls();
    }

    return <Widget>[
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
      const CloseButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white10),
              alignment: Alignment.center)),
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

      // Mode selection dropdown and RA/Dec button. The dropdown is hidden
      // if both skip_focus and skip_alignment are set (nothing to select
      // between); the RA/Dec button stays in this row either way.
      Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              if (!(controller.skipFocus && controller.skipAlignment)) ...[
                Container(width: 15),
                DropdownMenu<String>(
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      constraints:
                          BoxConstraints.tight(const Size.fromHeight(40)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    width: 95 * textScaleFactor(controller.context),
                    requestFocusOnTap: false,
                    initialSelection: controller.setupMode
                        ? (controller.focusAid ? "Focus" : "Align")
                        : "Aim",
                    label: _primaryText("Mode", size: 12),
                    dropdownMenuEntries: [
                      if (!controller.skipFocus) "Focus",
                      if (!controller.skipAlignment) "Align",
                      "Aim",
                    ]
                        .map<DropdownMenuEntry<String>>((String s) {
                      return DropdownMenuEntry<String>(
                        value: s,
                        label: s,
                        labelWidget: _primaryText(s),
                        enabled: true,
                      );
                    }).toList(),
                    textStyle: TextStyle(
                        fontSize: 12 * textScaleFactor(controller.context),
                        color: primaryColor),
                    onSelected: (String? newValue) {
                      if (newValue == "Focus") {
                        controller.setOperatingMode(true, true);
                      } else if (newValue == "Align") {
                        controller.setOperatingMode(true, false);
                      } else {
                        // Aim.
                        controller.setOperatingMode(false, false);
                      }
                      controller.onStateChanged();
                      Navigator.of(controller.context).pop();
                    }),
                const SizedBox(width: 4),
              ],
              if (controller.onGotoRaDec != null)
                TextButton.icon(
                  icon: const Icon(Icons.gps_fixed),
                  label: _scaledText("RA/Dec"),
                  onPressed: () {
                    controller.closeDrawer();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.onGotoRaDec!();
                    });
                  },
                ),
            ],
          )),

      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

      // Re-enable focus/align steps button (shown if either skip flag is set)
      if (controller.skipFocus || controller.skipAlignment) ...[
        Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
                label: _scaledText(_getReenableButtonLabel(
                  controller.skipFocus, controller.skipAlignment)),
                icon: const Icon(Icons.undo),
                onPressed: () {
                  final prefs = cedar_rpc.Preferences()
                    ..skipFocus = false
                    ..skipAlignment = false;
                  controller.updatePreferences(prefs);
                  Navigator.of(controller.context).pop();
                })),
        SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
      ],

      // Preferences button
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Preferences"),
              icon: const Icon(Icons.settings),
              onPressed: () {
                controller.closeDrawer();
                Navigator.push(
                        controller.context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(controller.homePageState)))
                    .then((value) {
                  controller.onStateChanged();
                });
              })),

      // Map location (conditional)
      SizedBox(height: controller.offerMap ? _kDrawerSpacing * textScaleFactor(controller.context) : 0),
      if (controller.offerMap) ...[
        Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
                label: controller.mapPosition == null
                    ? _scaledText("Location unknown")
                    : _scaledText(sprintf("Location %.1f %.1f",
                        [controller.mapPosition!.latitude, controller.mapPosition!.longitude])),
                icon: Icon(controller.mapPosition == null
                    ? Icons.not_listed_location
                    : Icons.edit_location_alt),
                onPressed: () {
                  controller.closeDrawer();
                  Navigator.push(controller.context,
                      MaterialPageRoute(builder: (context) => MapScreen(controller.homePageState)));
                })),
      ],
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

      // Advanced/Expert toggle
      Align(
          alignment: Alignment.topLeft,
          child: GestureDetector(
              onLongPress: () {
                if (controller.advanced) {
                  controller.setExpert(true);
                }
              },
              child: TextButton.icon(
                  label: _scaledText(
                      controller.expert ? "Expert" : "Advanced"),
                  icon: controller.advanced
                      ? const Icon(Icons.check)
                      : const Icon(Icons.check_box_outline_blank),
                  onPressed: () {
                    if (controller.advanced) {
                      controller.setAdvanced(false);
                      controller.setExpert(false);
                    } else {
                      controller.setAdvanced(true);
                    }
                  }))),
      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

      // Shutdown button
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Shutdown"),
              icon: const Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                controller.closeDrawer();
                shutdownDialog(controller.homePageState, controller.context);
              })),

      if (isAndroid() && controller.advanced) ...[
        SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),

        // PIP button.
        Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
                label: _scaledText("Picture-in-Picture"),
                icon: const Icon(Icons.picture_in_picture),
                onPressed: () async {
                  controller.closeDrawer();
                  await controller.homePageState.pip.start();
                })),
      ],

      // Demo mode section (conditional)
      if ((controller.advanced || controller.demoMode) && controller.demoFiles.isNotEmpty) ...[
        Column(children: <Widget>[
          SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                label: _scaledText("Demo mode"),
                icon: controller.demoMode
                    ? const Icon(Icons.check)
                    : const Icon(Icons.check_box_outline_blank),
                onPressed: () {
                  controller.setDemoMode(!controller.demoMode);
                },
              )),
        ]),
      ],

      // Demo file selector (conditional)
      if (controller.demoMode && controller.demoFiles.isNotEmpty) ...[
        Column(children: [
          Row(children: [
            Container(width: 15),
            DropdownMenu<String>(
                menuHeight: 200,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  constraints: BoxConstraints.tight(const Size.fromHeight(40)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                width: 200 * textScaleFactor(controller.context),
                requestFocusOnTap: false,
                initialSelection: controller.demoFile.isEmpty ? "" : controller.demoFile,
                label: _primaryText("Image file", size: 12),
                dropdownMenuEntries:
                    controller.demoFiles.map<DropdownMenuEntry<String>>((String s) {
                  return DropdownMenuEntry<String>(
                    value: s,
                    label: _removeExtension(s),
                    labelWidget: _primaryText(_removeExtension(s)),
                    enabled: true,
                  );
                }).toList(),
                textStyle: TextStyle(
                    fontSize: 12 * textScaleFactor(controller.context),
                    color: primaryColor),
                onSelected: (String? newValue) {
                  controller.setDemoImage(newValue!);
                  controller.onStateChanged();
                  Navigator.of(controller.context).pop();
                })
          ]),
        ]),
      ],

      // System submenu (advanced only).
      if (controller.advanced) ...[
        SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("System"),
              icon: controller.systemMenuExpanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
              onPressed: () {
                controller.setSystemMenuExpanded(!controller.systemMenuExpanded);
              }),
        ),

        // System submenu items.
        if (controller.systemMenuExpanded) ...[
          SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),

          // About button.
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("About"),
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    controller.closeDrawer();
                    aboutScreen(controller.homePageState, controller.context);
                  }),
            ),
          ),

          SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),

          // Check for Update button.
          if (_buildCheckForUpdateButton() != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildCheckForUpdateButton()!,
            ),
            SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),
          ],

          // App log button (only shown when app log callbacks are provided).
          if (controller.appLogCallbacks != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                    label: _scaledText("Show Cedar Aim log"),
                    icon: const Icon(Icons.phone_android_outlined),
                    onPressed: () {
                      showDialog(
                          context: controller.context,
                          builder: (context) => AppLogPopUp(
                              controller.homePageState, controller.appLogCallbacks!, controller.isDIY));
                    }),
              ),
            ),
            SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),
          ],

          // Server log button.
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Show ${controller.productName} log"),
                  icon: const Icon(Icons.text_snippet_outlined),
                  onPressed: () async {
                    var logs = await controller.getServerLogs();
                    if (controller.context.mounted) {
                      showDialog(
                          context: controller.context,
                          builder: (context) => ServerLogPopUp(controller.homePageState, logs, controller.productName, controller.isDIY));
                    }
                  }),
            ),
          ),
          SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),

          // Restart Cedar Server button.
          if (_buildRestartServerButton() != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildRestartServerButton()!,
            ),
            SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),
          ],
        ],
      ],

      // Connection submenu (advanced only).
      if (controller.advanced) ...[
        SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Connection"),
              icon: controller.connectionMenuExpanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
              onPressed: () {
                controller.setConnectionMenuExpanded(!controller.connectionMenuExpanded);
              }),
        ),

        // Connection submenu items.
        if (controller.connectionMenuExpanded) ...[
          SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),

          // Connection status line (Android only — iOS can't communicate with
          // the server over Bluetooth, so there is no transport to toggle).
          if (isAndroid()) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                    icon: Icon(
                        isBluetoothInUse() ? Icons.bluetooth : Icons.wifi),
                    label: _scaledText(controller.badServerState
                        ? "Not connected to ${controller.productName}"
                        : "Connected to ${controller.productName} via "
                            "${isBluetoothInUse() ? 'Bluetooth' : 'WiFi'}"),
                    onPressed: () {
                      controller.closeDrawer();
                      final serverInfo =
                          controller.homePageState.serverInformation;
                      final hasWifiInfo =
                          serverInfo != null && serverInfo.hasWifiAccessPoint();
                      final wifiSsid =
                          hasWifiInfo ? serverInfo.wifiAccessPoint.ssid : null;
                      // Older servers don't report enabled state; assume
                      // enabled so we don't warn unnecessarily.
                      final wifiEnabled = !hasWifiInfo ||
                          !serverInfo.wifiAccessPoint.hasEnabled() ||
                          serverInfo.wifiAccessPoint.enabled;
                      _connectionTransportDialog(
                          controller.context,
                          controller.productName,
                          controller.initiateAction,
                          wifiSsid,
                          wifiEnabled);
                    }),
              ),
            ),
            SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),
          ],

          // WiFi button.
          if (controller.wifiAccessPointDialog != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                    label: _scaledText("WiFi"),
                    icon: const Icon(Icons.wifi),
                    onPressed: () {
                      controller.closeDrawer();
                      controller.wifiAccessPointDialog!(controller.homePageState, controller.context);
                    }),
              ),
            ),
            SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),
          ],

          // Bluetooth button.
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Bluetooth"),
                  icon: const Icon(Icons.bluetooth),
                  onPressed: () {
                    controller.closeDrawer();
                    _bluetoothDialog(controller.context, controller.productName);
                  }),
            ),
          ),
          SizedBox(height: _kDrawerSpacingCondensed * textScaleFactor(controller.context)),

          // Connections status button.
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Connections to ${controller.productName}"),
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: () {
                    connectionsDialog(
                        controller.context,
                        controller.productName,
                        controller.homePageState.serverInformation!.connectionStatus);
                  }),
            ),
          ),
        ],
      ],

      // Save image button.
      if (controller.advanced) ...[
        Column(children: [
          SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Save image"),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () async {
                    final context = controller.context;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _scaledText("Saving image"),
                                const SizedBox(height: 10),
                                const CircularProgressIndicator()
                              ]),
                        );
                      },
                    );
                    final started = DateTime.now();
                    String? path;
                    try {
                      path = await controller.saveImage();
                    } catch (e) {
                      path = null;
                    }
                    final elapsed = DateTime.now().difference(started);
                    const minDuration = Duration(milliseconds: 500);
                    if (elapsed < minDuration) {
                      await Future.delayed(minDuration - elapsed);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop(); // Close "Saving image" dialog
                      controller.closeDrawer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(path == null
                              ? 'Failed to save image'
                              : 'Image saved'),
                        ),
                      );
                    }
                  }))
        ]),
      ],

      // Reset "Don't show again" button (conditional)
      if (controller.advanced) ...[
        Column(children: [
          SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Reset 'Don't show again'"),
                  icon: const Icon(Icons.undo),
                  onPressed: () {
                    final request =
                        cedar_rpc.ActionRequest(clearDontShowItems: true);
                    controller.initiateAction(request);
                    Navigator.of(controller.context).pop();
                  }))
        ]),
      ],

      SizedBox(height: _kDrawerSpacing * textScaleFactor(controller.context)),
    ];
  }
}

/// Opens the device's Bluetooth settings.
Future<void> openBluetoothSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => settings.bluetooth(),
      OpenSettingsPlusIOS settings => settings.bluetooth(),
      _ => throw Exception('Platform not supported'),
    };
  } catch (e) {
    // Silently fail if platform not supported
    debugPrint('Error opening Bluetooth settings: $e');
  }
}


/// Result of checking whether this device is paired with the server over
/// Bluetooth: whether it's bonded, and (if so) the server's Bluetooth
/// address and name.
class _BtPairingStatus {
  final bool bonded;
  final String address;
  final String name;
  _BtPairingStatus({required this.bonded, required this.address, required this.name});
}

/// Determines whether this device is paired with the server over Bluetooth,
/// by asking the server for its own Bluetooth adapter address/name and
/// checking the phone's OS bond list for that address.
Future<_BtPairingStatus> _checkHopperBluetoothPairing(String productName) async {
  String address = '';
  String name = productName;
  bool bonded = false;
  try {
    final client = await getClient();
    final nameResponse = await client.getBluetoothName(
        cedar_rpc.EmptyMessage(),
        options: CallOptions(timeout: const Duration(seconds: 5)));
    address = nameResponse.address;
    bonded = await isBtDeviceBonded(address);
    if (bonded && nameResponse.name.isNotEmpty) {
      name = nameResponse.name;
    }
  } catch (e) {
    debugPrint('Error determining Bluetooth pairing status: $e');
  }
  return _BtPairingStatus(bonded: bonded, address: address, name: name);
}

/// Shows a dialog with Bluetooth-related actions: controlling pairing mode
/// and viewing/removing paired devices. Styled to match the WiFi dialog
/// (a bordered black overlay rather than a Material AlertDialog).
Future<void> _bluetoothDialog(BuildContext context, String productName) async {
  if (!context.mounted) {
    return;
  }
  // Outer context, used to re-open this dialog after a sub-flow returns.
  final outerContext = context;
  final color = Theme.of(context).colorScheme.primary;
  final width = 220.0 * textScaleFactor(context);
  OverlayEntry? dialogOverlayEntry;

  // Removes this dialog, runs [action] (a sub-flow whose UI must appear above
  // this dialog), then re-opens this dialog (so its pairing status refreshes)
  // if [action] returns true. The dialog is a raw OverlayEntry, so sub-flow
  // dialogs/routes would otherwise render beneath it; removing it first avoids
  // that.
  Future<void> runSubFlow(Future<bool> Function() action) async {
    dialogOverlayEntry?.remove();
    final reopen = await action();
    if (reopen && outerContext.mounted) {
      _bluetoothDialog(outerContext, productName);
    }
  }

  // Current Bluetooth pairing status (Android only). Null while still being
  // determined; otherwise a human-readable status line.
  String? pairingStatus;

  Text scaledText(String str) {
    return Text(
      str,
      textScaler: textScaler(context),
      style: TextStyle(color: color, fontWeight: FontWeight.normal),
    );
  }

  // Determines whether this device is paired to the server over Bluetooth,
  // and if so its name, updating the status row when done.
  Future<void> refreshPairingStatus() async {
    if (!isAndroid()) {
      return;
    }
    final result = await _checkHopperBluetoothPairing(productName);
    pairingStatus =
        result.bonded ? "Paired to ${result.name}" : "Not paired to $productName";
    dialogOverlayEntry?.markNeedsBuild();
  }

  if (isAndroid()) {
    pairingStatus = "Checking pairing status…";
    refreshPairingStatus();
  }

  dialogOverlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => dialogOverlayEntry!.remove(),
        child: Material(
          color: Colors.black87,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Stop tap propagation to prevent dialog dismissal.
                },
                child: Container(
                  width: width,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: color),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [scaledText("Bluetooth")]),
                      const SizedBox(height: 10),
                      if (pairingStatus != null) ...[
                        Align(
                          alignment: Alignment.topLeft,
                          child: scaledText(pairingStatus!),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          icon: Icon(Icons.bluetooth_searching, color: color),
                          label: scaledText('Control pairing on $productName'),
                          onPressed: () {
                            runSubFlow(() => _controlBluetoothPairing(
                                outerContext, productName));
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          icon: Icon(Icons.devices, color: color),
                          label: scaledText('Devices paired to $productName'),
                          onPressed: () {
                            runSubFlow(() async {
                              await Navigator.push(
                                  outerContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BluetoothScreen()));
                              return true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => dialogOverlayEntry!.remove(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10),
                        child: scaledText("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(dialogOverlayEntry);
}

/// Shows a dialog to switch the active transport (WiFi or Bluetooth) used to
/// talk to the server, or to pair over Bluetooth if not already paired.
/// Android only — iOS can't communicate with the server over Bluetooth.
Future<void> _connectionTransportDialog(
    BuildContext context,
    String productName,
    Future<void> Function(cedar_rpc.ActionRequest) initiateAction,
    String? wifiSsid,
    bool wifiEnabled) async {
  if (!context.mounted) {
    return;
  }
  final outerContext = context;
  final color = Theme.of(context).colorScheme.primary;
  final width = 240.0 * textScaleFactor(context);
  OverlayEntry? dialogOverlayEntry;

  // Null while still being determined.
  _BtPairingStatus? pairing;

  Text scaledText(String str) {
    return Text(
      str,
      textScaler: textScaler(context),
      style: TextStyle(color: color, fontWeight: FontWeight.normal),
    );
  }

  Future<void> refreshPairingStatus() async {
    pairing = await _checkHopperBluetoothPairing(productName);
    dialogOverlayEntry?.markNeedsBuild();
  }

  Future<void> selectWifi() async {
    // If the WiFi access point is currently disabled, we're about to
    // re-enable it. Warn the user they may need to reconnect to it in their
    // mobile device's WiFi settings, since re-enabling the AP doesn't
    // automatically reconnect a phone that's forgotten or moved on from it.
    // Let them cancel rather than proceeding unexpectedly.
    if (!wifiEnabled) {
      final proceed = await confirmOverlay(
          outerContext,
          "Enabling $productName's WiFi access point. You might need to "
          "reconnect to its WiFi network in your mobile device's WiFi "
          "settings. Proceed?",
          above: dialogOverlayEntry);
      if (!proceed || !outerContext.mounted) {
        return;
      }
    }

    // Ask the server to bring its WiFi access point up before switching —
    // sent over the current transport (Bluetooth), so it must happen before
    // setActiveDevice() switches us away from it. Best-effort.
    try {
      await initiateAction(cedar_rpc.ActionRequest(wifiEnabled: true));
    } catch (e) {
      debugPrint('Error requesting WiFi enable: $e');
    }
    await setActiveDevice(wifiDevice());
    dialogOverlayEntry?.remove();
  }

  Future<void> selectBluetooth() async {
    final status = pairing;
    if (status == null || !status.bonded) {
      return;
    }
    await setActiveDevice(
        CedarDevice(address: status.address, name: status.name));
    dialogOverlayEntry?.remove();
  }

  void pairThenRefresh() {
    dialogOverlayEntry?.remove();
    // _controlBluetoothPairing returns false when pairing was actually
    // enabled/disabled (a snackbar is shown in that case) — don't reopen this
    // dialog then, or it would cover the snackbar. Only reopen on cancel/error.
    _controlBluetoothPairing(outerContext, productName).then((reopen) {
      if (reopen && outerContext.mounted) {
        _connectionTransportDialog(outerContext, productName, initiateAction,
            wifiSsid, wifiEnabled);
      }
    });
  }

  refreshPairingStatus();

  dialogOverlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => dialogOverlayEntry!.remove(),
        child: Material(
          color: Colors.black87,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamilyFallback: ['Roboto']),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Stop tap propagation to prevent dialog dismissal.
                },
                child: Container(
                  width: width,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: color),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [scaledText("Connection")]),
                      const SizedBox(height: 10),

                      // WiFi option.
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton.icon(
                          icon: Icon(
                              isBluetoothInUse() ? Icons.wifi : Icons.check,
                              color: color),
                          label: scaledText(
                              wifiSsid != null ? "WiFi ($wifiSsid)" : "WiFi"),
                          onPressed:
                              isBluetoothInUse() ? () => selectWifi() : null,
                        ),
                      ),

                      // Bluetooth option, or pairing affordance.
                      if (pairing == null) ...[
                        Align(
                          alignment: Alignment.topLeft,
                          child: scaledText("Checking Bluetooth pairing…"),
                        ),
                      ] else if (pairing!.bonded) ...[
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton.icon(
                            icon: Icon(
                                isBluetoothInUse()
                                    ? Icons.check
                                    : Icons.bluetooth,
                                color: color),
                            label: scaledText("Bluetooth (${pairing!.name})"),
                            onPressed: isBluetoothInUse()
                                ? null
                                : () => selectBluetooth(),
                          ),
                        ),
                      ] else ...[
                        Align(
                          alignment: Alignment.topLeft,
                          child: TextButton.icon(
                            icon: Icon(Icons.bluetooth_disabled, color: color),
                            label: scaledText(
                                "Not paired with $productName over Bluetooth — tap to pair"),
                            onPressed: pairThenRefresh,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => dialogOverlayEntry!.remove(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10),
                        child: scaledText("Close"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(dialogOverlayEntry);
}

/// Control Bluetooth pairing mode on the Cedar server. Returns true if the
/// caller should re-open the Bluetooth dialog afterward (cancel or error), or
/// false if pairing was enabled or disabled — in those cases a snackbar is
/// shown (and, for enable, the user is directed to OS Bluetooth settings), so
/// re-showing the dialog would cover the snackbar and be in the way.
Future<bool> _controlBluetoothPairing(BuildContext context, String productName) async {
  if (!context.mounted) {
     return true;
  }
  try {
    final client = await getClient();
    if (!context.mounted) {
      return true;
    }
    // Show a dialog to select enable or disable.
    final choice = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        final color = Theme.of(dialogContext).colorScheme.primary;
        final rightButtons = [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'cancel'),
            child: Text('Cancel', style: TextStyle(color: color)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'disable'),
            child: Text('Disable', style: TextStyle(color: color)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'enable'),
            child: Text('Enable', style: TextStyle(color: color)),
          ),
        ];
        return AlertDialog(
          title: Text('Control $productName Bluetooth Pairing',
              style: TextStyle(color: color)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Enable or disable pairing on $productName?',
                  style: TextStyle(color: color)),
              if (isIOS()) ...[
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    showDialog<void>(
                      context: dialogContext,
                      builder: (BuildContext context) {
                        final color = Theme.of(context).colorScheme.primary;
                        return AlertDialog(
                          title: Text('About Bluetooth Pairing',
                              style: TextStyle(color: color)),
                          content: Text(
                              '$productName can communicate over Bluetooth '
                              'with Android devices, but not your iOS device.\n\n'
                              'This item is available on your iOS device to '
                              'control $productName\'s Bluetooth pairing with '
                              'Android devices.',
                              style: TextStyle(color: color)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK', style: TextStyle(color: color)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.help_outline, size: 16, color: color),
                      const SizedBox(width: 4),
                      Text('About', style: TextStyle(color: color)),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: rightButtons,
        );
      },
    );
    if (choice == 'cancel' || !context.mounted) {
      return true;
    }
    if (choice == 'disable') {
      // Disable pairing.
      await client.setPairingMode(
        cedar_rpc.SetPairingModeRequest(enabled: false),
        options: CallOptions(timeout: const Duration(seconds: 5)),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pairing disabled on $productName')),
        );
      }
      // Don't re-open the Bluetooth dialog — it would cover the snackbar.
      return false;
    }
    // 'enable' selected. Show dialog for forever option
    bool forever = false;
    final enableForever = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final color = Theme.of(context).colorScheme.primary;
            return AlertDialog(
              title: Text('Enable $productName Pairing',
                  style: TextStyle(color: color)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text('Keep pairing enabled indefinitely',
                        style: TextStyle(color: color)),
                    value: forever,
                    onChanged: (bool? value) {
                      setState(() {
                        forever = value ?? false;
                      });
                    },
                    activeColor: color,
                    checkColor: Colors.black,
                    side: BorderSide(width: 2, color: color),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, null),
                  child: Text('Cancel', style: TextStyle(color: color)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, forever),
                  child: Text('Enable', style: TextStyle(color: color)),
                ),
              ],
            );
          },
        );
      },
    );
    if (enableForever == null || !context.mounted) {
      // User cancelled the enable confirmation — return to the Bluetooth dialog.
      return true;
    }
    // Get the device's Bluetooth name to show in the confirmation message.
    final nameResponse = await client.getBluetoothName(cedar_rpc.EmptyMessage(),
        options: CallOptions(timeout: const Duration(seconds: 5)));

    // Enable pairing mode.
    await client.setPairingMode(
      cedar_rpc.SetPairingModeRequest(enabled: true, forever: enableForever),
      options: CallOptions(timeout: const Duration(seconds: 5)),
    );

    if (context.mounted) {
      final durationText = enableForever ? '(indefinitely)' : '(few minutes)';
      final isSupported = isAndroid() || isIOS();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pairing enabled on $productName $durationText — select ${nameResponse.name} in Bluetooth settings',
          ),
          duration: const Duration(seconds: 7),
          action: isSupported
              ? SnackBarAction(
                  label: 'Bluetooth Settings',
                  onPressed: () {
                    openBluetoothSettings();
                  },
                )
              : null,
        ),
      );
    }
    // Pairing was enabled — the user should go to OS Bluetooth settings, so
    // don't re-open the Bluetooth dialog.
    return false;
  } catch (e) {
    debugPrint('Error controlling Bluetooth pairing: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to control pairing: $e')),
      );
    }
  }
  return true;
}
