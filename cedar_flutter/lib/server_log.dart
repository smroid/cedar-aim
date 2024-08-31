// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

class ServerLogPopUp extends StatelessWidget {
  final String _content;
  final ScrollController _scrollController = ScrollController();
  ServerLogPopUp(this._content, {super.key});

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
                style: const TextStyle(fontSize: 16),
                textScaler: textScaler(context),
              )),
          SizedBox(
              height: 25,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context))),
        ],
      ),
      content: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _content,
              style: const TextStyle(fontSize: 12),
              textScaler: textScaler(context),
            ),
          ],
        ),
      ),
    );
  }
}
