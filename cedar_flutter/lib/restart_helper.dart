// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/platform.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

Text _scaledText(String str, BuildContext context) {
  return Text(
    str,
    textScaler: textScaler(context),
    style: TextStyle(color: Theme.of(context).colorScheme.primary),
  );
}

/// Performs a server restart with progress dialog and app exit.
///
/// Shows a progress dialog, initiates the restart, waits for it to complete,
/// then closes the restart confirmation dialog and progress dialog, and exits the app.
///
/// Parameters:
/// - context: The build context for showing dialogs
/// - homePageState: The home page state to call restart() on
/// - productName: The product name to display in dialogs
Future<void> performRestart(
  BuildContext context,
  MyHomePageState homePageState,
  String productName,
) async {
  late BuildContext dialogContext;

  // Show restart progress dialog.
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogCtx) {
      dialogContext = dialogCtx;
      return AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _scaledText('Restarting $productName', dialogCtx),
          const SizedBox(height: 10),
          _scaledText('You will likely need to reconnect to $productName\'s WiFi', dialogCtx),
          const SizedBox(height: 10),
          const CircularProgressIndicator()
        ]),
      );
    },
  );

  // Initiate server restart.
  homePageState.restart();

  // Wait for the server to restart.
  await Future.delayed(const Duration(seconds: 15));

  if (dialogContext.mounted) {
    // Close progress dialog and restart confirmation dialog, then exit app.
    Navigator.of(dialogContext).pop(); // Close progress dialog.
    Navigator.of(dialogContext).pop(); // Close restart confirmation dialog.
    homePageState.closeDrawer();
    // Exit the app since the server has restarted and user needs to reconnect
    exitApp();
  }
}