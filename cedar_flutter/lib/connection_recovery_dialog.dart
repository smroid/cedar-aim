// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:cedar_flutter/platform.dart';

class ConnectionRecoveryConfig {
  final String productName;
  final String title;
  final List<CedarDevice>? devices;
  final Function(CedarDevice)? onDeviceSelected;
  final Future<List<CedarDevice>> Function()? refreshDevices;

  ConnectionRecoveryConfig({
    required this.productName,
    required this.title,
    this.devices,
    this.onDeviceSelected,
    this.refreshDevices,
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

/// Opens the device's airplane mode settings.
Future<void> _openAirplaneModeSettings() async {
  try {
    await switch (OpenSettingsPlus.shared) {
      OpenSettingsPlusAndroid settings => settings.airplaneMode(),
      OpenSettingsPlusIOS settings => settings.general(),
      _ => throw Exception('Platform not supported'),
    };
  } catch (e) {
    debugPrint('Error opening airplane mode settings: $e');
  }
}

/// Generates the connection recovery dialog message.
String _getConnectionRecoveryMessage(String productName) {
  return "Your mobile device needs to connect to your $productName's WiFi.";
}

/// Generates the connection recovery dialog help text.
String _getConnectionRecoveryHelpText(String productName) {
  if (isAndroid()) {
    return 'You can also pair with $productName via Bluetooth. '
        'It may help to turn on airplane mode.';
  }
  return 'It may help to turn on airplane mode.';
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

/// Builds the device selection dropdown or message.
Widget _buildDeviceSection(
  List<CedarDevice>? currentDevices,
  ConnectionRecoveryConfig config,
  BuildContext dialogContext,
) {
  if (currentDevices == null || currentDevices.isEmpty) {
    return Text(
      'No Bluetooth devices paired. Please pair with '
      '${config.productName} first using Bluetooth settings.',
      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
    );
  }

  return DropdownButton<CedarDevice>(
    value: null,
    hint: Text('Use ${config.productName} with Bluetooth'),
    items: currentDevices.map((device) {
      final label = device.name ?? device.address;
      return DropdownMenuItem<CedarDevice>(
        value: device,
        child: Text(label),
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
  final helpText = _getConnectionRecoveryHelpText(config.productName);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      List<CedarDevice>? currentDevices = config.devices;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          Widget messageSection = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              Text(
                helpText,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          );

          Widget content;
          if (isLandscape) {
            // Two-column landscape layout using Table for reliable sizing.
            final leftColumnChildren = <Widget>[messageSection];
            if (isAndroid() && currentDevices != null) {
              leftColumnChildren.add(const SizedBox(height: 20));
              leftColumnChildren.add(_buildDeviceSection(currentDevices, config, dialogContext));
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
            title: Text(config.title),
            content: content,
            actions: [
              // Refresh Devices button (if refresh callback available).
              if (config.refreshDevices != null)
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Devices'),
                  onPressed: () async {
                    final refreshedDevices = await config.refreshDevices!();
                    if (context.mounted) {
                      setState(() {
                        currentDevices = refreshedDevices;
                      });
                    }
                  },
                ),
              // WiFi Settings button (Android/iOS only).
              if (hasSettingsAccess)
                TextButton.icon(
                  icon: const Icon(Icons.wifi),
                  label: const Text('WiFi Settings'),
                  onPressed: () {
                    _openWiFiSettings();
                  },
                ),

              // Bluetooth Settings button (Android/iOS only).
              if (hasSettingsAccess)
                TextButton.icon(
                  icon: const Icon(Icons.bluetooth),
                  label: const Text('Bluetooth Settings'),
                  onPressed: () {
                    _openBluetoothSettings();
                  },
                ),

              // Airplane Mode button (Android/iOS only).
              if (hasSettingsAccess)
                TextButton.icon(
                  icon: const Icon(Icons.airplanemode_active),
                  label: const Text('Airplane Mode'),
                  onPressed: () {
                    _openAirplaneModeSettings();
                  },
                ),

              // For web, just dismiss the dialog.
              // The connection retry logic will attempt reconnection when the
              // dialog is closed.

              // Cancel/OK button.
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}
