// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// A simple dialog box message with no functionality other than to be dismissed.

import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

Future<void> showInterstitial(String message, BuildContext context) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return interstitialDialog(message, context, popContext: true);
      });
}

AlertDialog interstitialDialog(String message, BuildContext context,
    {VoidCallback? onConfirm, bool popContext = false}) {
  return AlertDialog(
    content: Text(
      message,
      textScaler: textScaler(context),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          if (popContext) {
            Navigator.of(context).pop();
          }
          if (onConfirm != null) {
            onConfirm();
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
        child: Text("OK", textScaler: textScaler(context)),
      )
    ],
  );
}
