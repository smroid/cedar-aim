// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'dart:io';

import 'package:cedar_flutter/client_main.dart';
import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Note that this file supports displaying and emailing both the server log and
// the app log, despite the file name.

/// Callbacks supplying app log content for display and sending.
class AppLogCallbacks {
  final String Function() getForDisplay;
  final String Function() getForSending;

  const AppLogCallbacks({
    required this.getForDisplay,
    required this.getForSending,
  });
}

Future<void> _sendLogToSupport(String logContent, String subject) async {
  final dir = await getTemporaryDirectory();
  final filename = '${subject.replaceAll(' ', '_')}.txt';
  final file = File('${dir.path}/$filename');
  await file.writeAsString(logContent);
  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'text/plain')],
    subject: subject,
    text: 'Please send this log (attached) to support@cs-astro.com.',
  );
}

class ServerLogPopUp extends StatelessWidget {
  final MyHomePageState _state;
  final String _content;
  final String _productName;
  final bool _isDIY;
  final ScrollController _scrollController = ScrollController();
  ServerLogPopUp(this._state, this._content, this._productName, this._isDIY, {super.key});

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
                '$_productName log',
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
                fontSize: 10,
                color: Theme.of(context).colorScheme.primary,
              ),
              textScaler: textScaler(context),
            ),
          ],
        ),
      ),
      actions: [
        if (!_isDIY)
          TextButton.icon(
            icon: const Icon(Icons.email_outlined),
            label: const Text('Send to support'),
            onPressed: () => _sendLogToSupport(_content, '$_productName log'),
          ),
      ],
    );
  }
}

class AppLogPopUp extends StatelessWidget {
  final MyHomePageState _state;
  final AppLogCallbacks _callbacks;
  final bool _isDIY;
  final ScrollController _scrollController = ScrollController();
  AppLogPopUp(this._state, this._callbacks, this._isDIY, {super.key});

  @override
  Widget build(BuildContext context) {
    final displayContent = _callbacks.getForDisplay();
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
                'Cedar Aim log',
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
              displayContent,
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.primary,
              ),
              textScaler: textScaler(context),
            ),
          ],
        ),
      ),
      actions: [
        if (!_isDIY)
          TextButton.icon(
            icon: const Icon(Icons.email_outlined),
            label: const Text('Send to support'),
            onPressed: () =>
                _sendLogToSupport(_callbacks.getForSending(), 'Cedar Aim log'),
          ),
      ],
    );
  }
}
