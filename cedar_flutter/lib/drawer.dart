// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;
import 'package:sprintf/sprintf.dart';

import 'package:cedar_flutter/about.dart';
import 'package:cedar_flutter/cedar.pbgrpc.dart' as cedar_rpc;
import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/geolocation.dart';
import 'package:cedar_flutter/server_log.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:cedar_flutter/shutdown_dialog.dart';


/// Interface for drawer state and callbacks
class CedarDrawerController {
  // State variables
  final bool setupMode;
  final bool focusAid;
  final bool offerMap;
  final LatLng? mapPosition;
  final bool advanced;
  final bool demoMode;
  final List<String> demoFiles;
  final bool systemMenuExpanded;
  final String demoFile;
  final bool hasWifiControl;
  final bool badServerState;
  final UpdateServerSoftwareDialogFunction? updateServerSoftwareDialogFunction;
  final RestartCedarServerFunction? restartCedarServerFunction;
  final WifiAccessPointDialogFunction? wifiAccessPointDialog;

  // Callbacks
  final Future<void> Function(bool setupMode, bool focusAid) setOperatingMode;
  final Future<void> Function(String) setDemoImage;
  final Future<void> Function() saveImage;
  final Future<String> Function() getServerLogs;
  final Future<void> Function() crashServer;
  final Future<void> Function() restartCedarServer;
  final Future<void> Function(cedar_rpc.ActionRequest) initiateAction;
  final Future<void> Function(cedar_rpc.Preferences) updatePreferences;
  final Future<void> Function(bool) setAdvanced;
  final Future<void> Function(bool) setDemoMode;
  final Function(bool) setSystemMenuExpanded;
  final VoidCallback onStateChanged;
  final VoidCallback closeDrawer;

  // Context and styling
  final BuildContext context;
  final MyHomePageState homePageState;

  CedarDrawerController({
    required this.setupMode,
    required this.focusAid,
    required this.offerMap,
    required this.mapPosition,
    required this.advanced,
    required this.demoMode,
    required this.demoFiles,
    required this.systemMenuExpanded,
    required this.demoFile,
    required this.hasWifiControl,
    required this.badServerState,
    required this.updateServerSoftwareDialogFunction,
    required this.restartCedarServerFunction,
    required this.wifiAccessPointDialog,
    required this.setOperatingMode,
    required this.setDemoImage,
    required this.saveImage,
    required this.getServerLogs,
    required this.crashServer,
    required this.restartCedarServer,
    required this.initiateAction,
    required this.updatePreferences,
    required this.setAdvanced,
    required this.setDemoMode,
    required this.setSystemMenuExpanded,
    required this.onStateChanged,
    required this.closeDrawer,
    required this.context,
    required this.homePageState,
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

  // Helper method for Check for Update button
  Widget? _buildCheckForUpdateButton() {
    if (controller.updateServerSoftwareDialogFunction == null) return null;

    return Align(
      alignment: Alignment.topLeft,
      child: TextButton.icon(
          label: _scaledText("Check for Update"),
          icon: const Icon(Icons.system_update_alt),
          onPressed: () {
            controller.closeDrawer();
            controller.updateServerSoftwareDialogFunction!(controller.homePageState, controller.context);
          }),
    );
  }

  // Helper method for Restart Cedar Server button
  Widget? _buildRestartServerButton() {
    if (controller.restartCedarServerFunction == null) return null;

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
                          await controller.restartCedarServerFunction!();
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
      const SizedBox(height: 15),
      const CloseButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white10),
              alignment: Alignment.center)),
      const SizedBox(height: 15),

      Center(
        child: _scaledText("Server Recovery"),
      ),
      const SizedBox(height: 20),
      ...[
        if (_buildCheckForUpdateButton() != null) ...[
          _buildCheckForUpdateButton()!,
          const SizedBox(height: 10),
        ],
        if (_buildRestartServerButton() != null) ...[
          _buildRestartServerButton()!,
          const SizedBox(height: 10),
        ],
      ],

      const SizedBox(height: 15),
    ];
  }

  List<Widget> _buildDrawerControls() {
    // Show simplified menu during bad server state.
    if (controller.badServerState) {
      return _buildBadServerStateControls();
    }

    return <Widget>[
      const SizedBox(height: 15),
      const CloseButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.white10),
              alignment: Alignment.center)),
      const SizedBox(height: 15),

      // Mode selection dropdown
      Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
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
                  width: 120 * textScaleFactor(controller.context),
                  requestFocusOnTap: false,
                  initialSelection: controller.setupMode
                      ? (controller.focusAid ? "Focus" : "Align")
                      : "Aim",
                  label: _primaryText("Mode", size: 12),
                  dropdownMenuEntries: ["Focus", "Align", "Aim"]
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
                  onSelected: (String? newValue) async {
                    if (newValue == "Focus") {
                      await controller.setOperatingMode(true, true);
                      controller.onStateChanged();
                    } else if (newValue == "Align") {
                      await controller.setOperatingMode(true, false);
                      controller.onStateChanged();
                    } else {
                      // Aim.
                      await controller.setOperatingMode(false, false);
                      controller.onStateChanged();
                    }
                    if (controller.context.mounted) {
                      Navigator.of(controller.context).pop();
                    }
                  }),
            ],
          )),

      const SizedBox(height: 15),

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
      SizedBox(height: controller.offerMap ? 15 : 0),
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

      const SizedBox(height: 15),

      // Advanced toggle
      Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
              label: _scaledText("Advanced"),
              icon: controller.advanced
                  ? const Icon(Icons.check)
                  : const Icon(Icons.check_box_outline_blank),
              onPressed: () async {
                await controller.setAdvanced(!controller.advanced);
              })),

      const SizedBox(height: 15),

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

      // Demo mode section (conditional)
      if ((controller.advanced || controller.demoMode) && controller.demoFiles.isNotEmpty) ...[
        Column(children: <Widget>[
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                label: _scaledText("Demo mode"),
                icon: controller.demoMode
                    ? const Icon(Icons.check)
                    : const Icon(Icons.check_box_outline_blank),
                onPressed: () async {
                  await controller.setDemoMode(!controller.demoMode);
                },
              )),
          const SizedBox(height: 10)
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
                onSelected: (String? newValue) async {
                  await controller.setDemoImage(newValue!);
                  controller.onStateChanged();
                  if (controller.context.mounted) {
                    Navigator.of(controller.context).pop();
                  }
                })
          ]),
          const SizedBox(height: 8),
        ]),
      ],

      // System submenu (conditional)
      if (controller.advanced) ...[
        const SizedBox(height: 10),
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

        // System submenu items (conditional)
        if (controller.systemMenuExpanded) ...[
          const SizedBox(height: 5),

          // About button
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

          const SizedBox(height: 5),

          // Check for Update button (conditional)
          if (_buildCheckForUpdateButton() != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildCheckForUpdateButton()!,
            ),
            const SizedBox(height: 5),
          ],

          // Crash Server button (debug/testing only)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Crash Server (DEBUG)"),
                  icon: const Icon(Icons.build),
                  onPressed: () {
                    // Show confirmation dialog since this is destructive
                    showDialog(
                      context: controller.context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Crash Server", style: TextStyle(color: primaryColor)),
                          content: Text("This will crash the Cedar server for testing purposes. Are you sure?",
                                        style: TextStyle(color: primaryColor)),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel", style: TextStyle(color: primaryColor)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.closeDrawer();
                                controller.crashServer();
                              },
                              child: Text("Crash Server", style: TextStyle(color: primaryColor)),
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
          ),

          const SizedBox(height: 5),

          // Restart Cedar Server button (conditional)
          if (_buildRestartServerButton() != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildRestartServerButton()!,
            ),
            const SizedBox(height: 5),
          ],

          // Server log button
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Show server log"),
                  icon: const Icon(Icons.text_snippet_outlined),
                  onPressed: () async {
                    var logs = await controller.getServerLogs();
                    if (controller.context.mounted) {
                      showDialog(
                          context: controller.context,
                          builder: (context) => ServerLogPopUp(controller.homePageState, logs));
                    }
                  }),
            ),
          ),

          const SizedBox(height: 5),

          // WiFi button (conditional)
          if (controller.hasWifiControl && controller.wifiAccessPointDialog != null) ...[
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
            const SizedBox(height: 5),
          ],
        ],
      ],

      // Save image button (conditional)
      if (controller.advanced) ...[
        Column(children: [
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Save image"),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () async {
                    await controller.saveImage();
                    // Brief delay to give user feedback that action was triggered
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (controller.context.mounted) {
                      controller.closeDrawer();
                    }
                  }))
        ]),
      ],

      // Reset "Don't show again" button (conditional)
      if (controller.advanced) ...[
        Column(children: [
          const SizedBox(height: 10),
          Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                  label: _scaledText("Reset 'Don't show again'"),
                  icon: const Icon(Icons.undo),
                  onPressed: () async {
                    final request =
                        cedar_rpc.ActionRequest(clearDontShowItems: true);
                    await controller.initiateAction(request);
                    if (controller.context.mounted) {
                      Navigator.of(controller.context).pop();
                    }
                  }))
        ]),
      ],

      const SizedBox(height: 15),
    ];
  }
}