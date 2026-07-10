// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:cedar_flutter/platform.dart';

class ConnectionRecoveryConfig {
  final String productName;
  final String title;
  final bool everConnected;
  final List<CedarDevice>? devices;
  final Function(CedarDevice)? onDeviceSelected;
  final Future<List<CedarDevice>> Function()? refreshDevices;
  final String? errorMessage;
  // Issues the server-side action to bring the WiFi access point back up.
  // Called (over the current transport, e.g. BT) before switching to WiFi —
  // best-effort, since a manual power-cycle also brings WiFi back.
  final Future<void> Function()? onWifiRequested;

  ConnectionRecoveryConfig({
    required this.productName,
    required this.title,
    this.everConnected = false,
    this.devices,
    this.onDeviceSelected,
    this.refreshDevices,
    this.errorMessage,
    this.onWifiRequested,
  });
}

/// Opens the device's WiFi settings.
Future<void> _openWiFiSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => settings.wifi(),
      OpenSettingsPlusIOS settings => settings.wifi(),
      _ => throw Exception('Platform not supported'),
    };
  } catch (e) {
    debugPrint('Error opening WiFi settings: $e');
  }
}

/// Opens the device's Bluetooth settings.
Future<void> _openBluetoothSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => settings.bluetooth(),
      OpenSettingsPlusIOS settings => settings.bluetooth(),
      _ => throw Exception('Platform not supported'),
    };
  } catch (e) {
    debugPrint('Error opening Bluetooth settings: $e');
  }
}

/// Generates the connection recovery dialog message.
String _getConnectionRecoveryMessage(String productName) {
  return "Your mobile device needs to connect to your $productName's WiFi.";
}

/// Generates the connection recovery dialog help text.
String _getConnectionRecoveryHelpText(String productName, bool everConnected) {
  if (isAndroid()) {
    return 'Tip: In WiFi Settings, select $productName\'s network. '
        'If Android asks "No internet — stay connected?" tap Yes.';
  }
  return '';
}

/// Selects a device and persists the selection.
/// Persistence is handled by setActiveDevice() in platform_mobile.dart.
Future<void> _selectDevice(
  CedarDevice device,
  ConnectionRecoveryConfig config,
) async {
  try {
    await setActiveDevice(device);
  } catch (e) {
    rethrow;
  }

  // Call any additional callback if provided.
  if (config.onDeviceSelected != null) {
    config.onDeviceSelected!(device);
  }
}

/// Switches to WiFi and persists the selection. This is effective until the
/// user picks a Bluetooth device again (e.g. from this same dialog, should a
/// WiFi connection problem bring them back here).
Future<void> _selectWifi(ConnectionRecoveryConfig config) async {
  // Ask the server to bring its WiFi access point up before switching this
  // client to WiFi — otherwise there may be nothing to connect to yet.
  // Sent over the current transport (e.g. BT), so must happen before
  // _selectDevice() switches us away from it. Best-effort: proceed with the
  // switch even if this fails (e.g. the user already power-cycled the
  // device, which also brings WiFi back).
  try {
    await config.onWifiRequested?.call();
  } catch (e) {
    debugPrint('Error requesting WiFi enable: $e');
  }
  await _selectDevice(wifiDevice(), config);
}

/// Builds the device selection dropdown or message.
Widget _buildDeviceSection(
  List<CedarDevice>? currentDevices,
  ConnectionRecoveryConfig config,
  BuildContext dialogContext,
) {
  final theme = Theme.of(dialogContext);
  final primaryColor = theme.colorScheme.primary;

  if (currentDevices == null || currentDevices.isEmpty) {
    return Text(
      'No Bluetooth devices paired. Please pair with '
      '${config.productName} first using Bluetooth settings.',
      style: TextStyle(
          fontSize: 12, fontStyle: FontStyle.italic, color: primaryColor),
    );
  }

  return DropdownButton<CedarDevice>(
    value: null,
    hint: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bluetooth, size: 16, color: primaryColor),
        const SizedBox(width: 6),
        Text(
          'Use ${config.productName} with Bluetooth',
          style: TextStyle(color: primaryColor),
        ),
      ],
    ),
    iconEnabledColor: primaryColor,
    iconDisabledColor: primaryColor,
    underline: Container(
      height: 1,
      color: primaryColor,
    ),
    items: currentDevices.map((device) {
      final label = device.name ?? device.address;
      return DropdownMenuItem<CedarDevice>(
        value: device,
        child: Text(
          label,
          style: TextStyle(color: primaryColor),
        ),
      );
    }).toList(),
    onChanged: (device) async {
      if (device != null) {
        try {
          await _selectDevice(device, config);
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        } catch (e) {
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
        }
      }
    },
  );
}

/// Shows a connection recovery dialog.
Future<void> showConnectionRecoveryDialog({
  required BuildContext context,
  required ConnectionRecoveryConfig config,
}) async {
  if (!context.mounted) {
    return;
  }
  final hasSettingsAccess = isAndroid() || isIOS();

  // Generate message and help text based on product name
  final message = _getConnectionRecoveryMessage(config.productName);
  final helpText = _getConnectionRecoveryHelpText(config.productName, config.everConnected);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      List<CedarDevice>? currentDevices = config.devices;
      AppLifecycleListener? lifecycleListener;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          final primaryColor = Theme.of(context).colorScheme.primary;

          // Set up lifecycle listener on first build to refresh when app
          // resumes, i.e. after user returns from the mobile's Bluetooth
          // settings.
          if (lifecycleListener == null && config.refreshDevices != null && isAndroid()) {
            lifecycleListener = AppLifecycleListener(
              onResume: () async {
                if (dialogContext.mounted) {
                  final refreshedDevices = await config.refreshDevices!();
                  if (dialogContext.mounted) {
                    setState(() {
                      currentDevices = refreshedDevices;
                    });
                  }
                }
              },
            );
          }

          Widget messageSection = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(color: primaryColor),
              ),
              if (helpText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  helpText,
                  style: TextStyle(fontSize: 14, color: primaryColor),
                ),
              ],
            ],
          );

          Widget content;
          if (isLandscape) {
            // Two-column landscape layout using Table for reliable sizing.
            final leftColumnChildren = <Widget>[messageSection];
            if (isAndroid() && currentDevices != null) {
              leftColumnChildren.add(const SizedBox(height: 20));
              leftColumnChildren.add(
                  _buildDeviceSection(currentDevices, config, dialogContext));
            }

            content = Table(
              columnWidths: const {
                0: FixedColumnWidth(300),
                1: FixedColumnWidth(24),
                2: FixedColumnWidth(300),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                TableRow(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leftColumnChildren,
                    ),
                    const SizedBox(), // Spacer column
                    const SizedBox(), // Empty right column
                  ],
                ),
              ],
            );
          } else {
            // Single-column portrait layout.
            content = SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messageSection,
                  if (isAndroid() && currentDevices != null) ...[
                    const SizedBox(height: 20),
                    _buildDeviceSection(currentDevices, config, dialogContext),
                  ],
                ],
              ),
            );
          }

          return AlertDialog(
            title: Text(
              config.title,
              style: TextStyle(color: primaryColor),
            ),
            content: content,
            actions: [
              // Switch to WiFi (Android only). Asks the server to bring its
              // WiFi access point back up (see onWifiRequested), so this
              // works even if the user hasn't power-cycled the device.
              // Effective until the user picks a Bluetooth device again,
              // including from this same dialog.
              if (isAndroid())
                TextButton.icon(
                  icon: const Icon(Icons.wifi),
                  label: const Text('Use WiFi'),
                  onPressed: () async {
                    try {
                      await _selectWifi(config);
                    } finally {
                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    }
                  },
                ),

              if (hasSettingsAccess)
                TextButton.icon(
                  icon: const Icon(Icons.wifi_find),
                  label: const Text('WiFi Settings'),
                  onPressed: () async {
                    await _openWiFiSettings();
                  },
                ),

              // Bluetooth Settings button (Android only).
              if (isAndroid())
                TextButton.icon(
                  icon: const Icon(Icons.bluetooth_searching),
                  label: const Text('Bluetooth Settings'),
                  onPressed: () async {
                    await _openBluetoothSettings();
                  },
                ),

              // Show Error button (only if error message is available).
              if (config.errorMessage != null)
                TextButton.icon(
                  icon: const Icon(Icons.error_outline),
                  label: const Text('Show Error'),
                  onPressed: () {
                    showDialog(
                      context: dialogContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Connection Error'),
                        content: SingleChildScrollView(
                          child: SelectableText(config.errorMessage!),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

              // For web, just dismiss the dialog.
              // The connection retry logic will attempt reconnection when the
              // dialog is closed.

              // Dismiss button — the connection retry logic attempts
              // reconnection when the dialog closes, so this reads as "Retry".
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Retry'),
              ),
            ],
          );
        },
      );
    },
  );
}
