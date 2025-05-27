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
            onPressed: () {
              state.restart();
              // Go back to main screen. It will complain about loss of
              // connectivity while the server restarts.
              Navigator.of(context).pop();
              state.closeDrawer();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            child: _scaledText("Restart", context),
          ),
          ElevatedButton(
            onPressed: () async {
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
              // TODO: time shutdown of Rpi Zero 2W.
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
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            child: _scaledText("Shutdown", context),
          ),
        ],
      );
    },
  );
}
