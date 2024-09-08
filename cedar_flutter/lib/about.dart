// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:async';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

OverlayEntry? _aboutOverlayEntry;
Timer? _timer;

Future<void> aboutScreen(MyHomePageState state, BuildContext context) async {
  _aboutOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Material(
          color: Colors.black,
          child: Stack(
            children: [
              RotatedBox(
                  quarterTurns:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 1
                          : 0,
                  child: Row(children: [
                    // TODO: sections here, each with box deco
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: serverInfo(state, context),
                    )),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: calibrationInfo(state, context),
                    )),
                  ])),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _aboutOverlayEntry?.remove();
                  _aboutOverlayEntry = null;
                  _timer?.cancel();
                  state.doRefreshes = true; // TODO: punt this?
                },
              ),
            ],
          )));

  Overlay.of(context).insert(_aboutOverlayEntry!);
}

Widget serverInfo(MyHomePageState state, BuildContext context) {
  final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
  Color color = Theme.of(context).colorScheme.primary;
  return RotatedBox(
      quarterTurns: portrait ? 3 : 0,
      child: Column(children: <Widget>[
        const SizedBox(height: 5),
        Text(
          style: const TextStyle(fontSize: 18),
          "Cedar server",
          textScaler: textScaler(context),
        ),
        const SizedBox(height: 20),
        Expanded(
            child: ListView(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("a"), Text("a")]),
        ]))
      ]));
}

Widget calibrationInfo(MyHomePageState state, BuildContext context) {
  return Container();
}
