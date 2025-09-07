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
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              _scaledText('You can unplug $productName', context),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                exitApp(); // Might not work on Web.
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10),
              child: _scaledText("OK", context),
            ),
          ],
        );
      },
    );
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
              // Show restart progress dialog.
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      _scaledText('Restarting $productName', context),
                      const SizedBox(height: 10),
                      _scaledText('You will likely need to reconnect to $productName\'s WiFi', context),
                      const SizedBox(height: 10),
                      const CircularProgressIndicator()
                    ]),
                  );
                },
              );
              // Initiate server restart.
              state.restart();
              // Wait for the server to restart.
              await Future.delayed(const Duration(seconds: 15));
              if (context.mounted) {
                // Close progress dialog and main dialog, then exit app.
                Navigator.of(context).pop(); // Close progress dialog.
                Navigator.of(context).pop(); // Close main shutdown dialog.
                state.closeDrawer();
                // Exit the app since the server has restarted and user needs to reconnect
                exitApp();
              }
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
            child: ElevatedButton(
              onPressed: () {}, // Empty function to keep button enabled for GestureDetector.
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: _scaledText("Shutdown", context),
            ),
          ),
        ],
      );
    },
  );
}
