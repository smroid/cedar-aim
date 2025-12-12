import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/platform.dart';
import 'package:cedar_flutter/restart_helper.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

Text _scaledText(String str, BuildContext context) {
  return Text(
    str,
    textScaler: textScaler(context),
    style: TextStyle(color: Theme.of(context).colorScheme.primary),
  );
}

// Helper function to perform the actual shutdown process.
Future<void> _performShutdown(MyHomePageState state, BuildContext context, String productName) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _scaledText('Shutting down $productName', context),
          const SizedBox(height: 10),
          const CircularProgressIndicator()
        ]),
      );
    },
  );
  // Initiate server shutdown.
  state.shutdown();
  // Wait for the server to have shut down.
  await Future.delayed(const Duration(seconds: 15));
  if (context.mounted) {
    // Close the shutdown progress dialog and the main shutdown dialog
    Navigator.of(context).pop(); // Close "Shutting down..." dialog
    Navigator.of(context).pop(); // Close "Shutdown $productName?" dialog

    // Get the root context for showing the Snackbar
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    if (rootContext.mounted) {
      const duration = Duration(seconds: 10);
      bool snackBarDismissed = false;

      final snackBar = SnackBar(
        content: Text('You can unplug $productName'),
        duration: duration,
        action: SnackBarAction(
          label: 'Exit',
          onPressed: () {
            snackBarDismissed = true;
            exitApp(); // Might not work on Web.
          },
        ),
        onVisible: () {
          // Exit the app after the snackbar duration if not manually dismissed.
          Future.delayed(duration, () {
            if (!snackBarDismissed) {
              exitApp(); // Might not work on Web.
            }
          });
        },
      );
      ScaffoldMessenger.of(rootContext).showSnackBar(snackBar);
    }
  }
}

void shutdownDialog(MyHomePageState state, BuildContext context) {
  final serverInfo = state.serverInformation!;
  var productName = serverInfo.productName;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: _scaledText("Shutdown $productName?", context),
        actionsOverflowButtonSpacing: 5,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            child: _scaledText("Cancel", context),
          ),
          ElevatedButton(
            onPressed: () async {
              await performRestart(context, state, productName);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            child: _scaledText("Restart", context),
          ),
          GestureDetector(
            onTap: () async {
              await _performShutdown(state, context, productName);
            },
            onLongPress: () {
              // Show confirmation dialog for clearing observer location.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: _scaledText("This will also clear the observer location", context),
                    actionsOverflowButtonSpacing: 5,
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
                        child: _scaledText("Cancel", context),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Get the parent context before we start async operations
                          final parentContext = Navigator.of(context, rootNavigator: true).context;

                          // Clear observer location first.
                          await clearObserverLocation();

                          // Close confirmation dialog.
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }

                          // Perform shutdown using the parent context
                          if (parentContext.mounted) {
                            await _performShutdown(state, parentContext, productName);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
                        child: _scaledText("Clear & Shutdown", context),
                      ),
                    ],
                  );
                },
              );
            },
            child: AbsorbPointer(
              absorbing: false,
              child: ElevatedButton(
                onPressed: null, // Disabled to let GestureDetector handle all events
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Theme.of(context).colorScheme.primary, // Keep text color active
                ),
                child: _scaledText("Shutdown", context),
              ),
            ),
          ),
        ],
      );
    },
  );
}
