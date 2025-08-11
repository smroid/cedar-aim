// Copyright (c) 2025 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// A simple dialog box message with optional "don't show this again" functionality

import 'package:cedar_flutter/settings.dart';
import 'package:flutter/material.dart';

Future<bool?> showInterstitial(String message, BuildContext context,
    {bool showDontShowAgain = true}) async {
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return interstitialDialog(message, context,
            popContext: true, showDontShowAgain: showDontShowAgain);
      });
}

AlertDialog interstitialDialog(String message, BuildContext context,
    {VoidCallback? onConfirm,
    bool popContext = false,
    bool showDontShowAgain = true,
    ValueChanged<bool>? onDontShowAgainChanged}) {
  return AlertDialog(
    content: _InterstitialDialogContent(
      key: ValueKey(message), // Unique key per dialog message
      message: message,
      showDontShowAgain: showDontShowAgain,
      onDontShowAgainChanged: onDontShowAgainChanged,
      onConfirm: onConfirm,
      popContext: popContext,
    ),
  );
}

class _InterstitialDialogContent extends StatefulWidget {
  final String message;
  final bool showDontShowAgain;
  final ValueChanged<bool>? onDontShowAgainChanged;
  final VoidCallback? onConfirm;
  final bool popContext;

  const _InterstitialDialogContent({
    super.key,
    required this.message,
    this.showDontShowAgain = false,
    this.onDontShowAgainChanged,
    this.onConfirm,
    this.popContext = false,
  });

  @override
  State<_InterstitialDialogContent> createState() =>
      _InterstitialDialogContentState();
}

class _InterstitialDialogContentState
    extends State<_InterstitialDialogContent> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.message
              .split('\n')
              .map((paragraph) => Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0), // Space between paragraphs
                    child: Text(
                      paragraph,
                      textScaler: textScaler(context),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).colorScheme.primary,
                        height: 1.2, // Tight line spacing within paragraph
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.showDontShowAgain)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _dontShowAgain,
                      onChanged: (bool? value) {
                        setState(() {
                          _dontShowAgain = value ?? false;
                        });
                        if (widget.onDontShowAgainChanged != null) {
                          widget.onDontShowAgainChanged!(_dontShowAgain);
                        }
                      },
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _dontShowAgain = !_dontShowAgain;
                          });
                          if (widget.onDontShowAgainChanged != null) {
                            widget.onDontShowAgainChanged!(_dontShowAgain);
                          }
                        },
                        child: Text(
                          "Don't show again",
                          textScaler: textScaler(context),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (widget.popContext) {
                  Navigator.of(context).pop(_dontShowAgain);
                }
                if (widget.onConfirm != null) {
                  widget.onConfirm!();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: Text("OK", textScaler: textScaler(context)),
            ),
          ],
        ),
      ],
    );
  }
}
