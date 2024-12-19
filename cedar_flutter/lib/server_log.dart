// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

class ServerLogPopUp extends StatelessWidget {
  final MyHomePageState _state;
  final String _content;
  final ScrollController _scrollController = ScrollController();
  ServerLogPopUp(this._state, this._content, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: 30,
              child: Text(
                'Cedar server log',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textScaler: textScaler(context),
              )),
          SizedBox(
              height: 25,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                    _state.closeDrawer();
                  })),
        ],
      ),
      content: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _content,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
              textScaler: textScaler(context),
            ),
          ],
        ),
      ),
    );
  }
}
