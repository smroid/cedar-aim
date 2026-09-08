// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

// Shared helpers for popups implemented as raw OverlayEntry objects (rather
// than showDialog/Navigator routes). Several dialogs in this app are
// themselves raw OverlayEntry popups (e.g. the WiFi access point dialog, the
// Bluetooth dialog), and a nested confirmation/error popup shown while one of
// those is open must also be a raw OverlayEntry inserted with `above:` the
// caller's entry — showDialog's Navigator-based overlay insertion does not
// reliably render above a manually-inserted OverlayEntry.

import 'dart:async';

import 'package:flutter/material.dart';

import 'settings.dart';

/// A button shown in an overlay popup.
class OverlayPopupButton {
  final String label;
  final VoidCallback onPressed;
  const OverlayPopupButton({required this.label, required this.onPressed});
}

/// Shows a popup with the given message and buttons. If [above] is provided,
/// the popup is inserted directly above that OverlayEntry in the same
/// Overlay, so it renders correctly on top of a caller that is itself a raw
/// OverlayEntry popup; otherwise it is inserted at the top of the Overlay.
/// Tapping outside the popup dismisses it (calling [onDismiss] first, if
/// given) unless [dismissible] is false. Returns the OverlayEntry so the
/// caller can remove it (e.g. for a non-dismissible spinner).
OverlayEntry showOverlayPopup(
  BuildContext context, {
  OverlayEntry? above,
  required String message,
  List<OverlayPopupButton> buttons = const [],
  Widget? extra,
  bool dismissible = true,
  VoidCallback? onDismiss,
  double? width,
  Color scrimColor = Colors.black87,
}) {
  OverlayEntry? popupEntry;
  final color = Theme.of(context).colorScheme.primary;

  Text scaledText(String str) {
    return Text(
      str,
      textScaler: textScaler(context),
      style: TextStyle(color: color, fontWeight: FontWeight.normal),
    );
  }

  void dismiss() {
    if (!dismissible) {
      return;
    }
    onDismiss?.call();
    popupEntry?.remove();
  }

  popupEntry = OverlayEntry(
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: dismiss,
        child: Material(
          color: scrimColor,
          child: Center(
            child: GestureDetector(
              onTap: () {
                // Stop tap propagation to prevent popup dismissal.
              },
              child: Container(
                width: width ?? 260.0 * textScaleFactor(context),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: color),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    scaledText(message),
                    if (extra != null) ...[
                      const SizedBox(height: 15),
                      extra,
                    ],
                    if (buttons.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: buttons
                            .map((b) => ElevatedButton(
                                  onPressed: b.onPressed,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white10),
                                  child: scaledText(b.label),
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(popupEntry, above: above);
  return popupEntry;
}

/// Shows a confirmation popup with the given message and Cancel/Proceed
/// buttons. Returns true if the user chose to proceed, false if they chose
/// Cancel or dismissed the popup by tapping outside it. If [above] is
/// provided, renders directly above that OverlayEntry (see
/// [showOverlayPopup]).
Future<bool> confirmOverlay(BuildContext context, String message,
    {OverlayEntry? above}) async {
  final completer = Completer<bool>();
  OverlayEntry? popupEntry;

  void complete(bool value) {
    popupEntry?.remove();
    if (!completer.isCompleted) {
      completer.complete(value);
    }
  }

  popupEntry = showOverlayPopup(
    context,
    above: above,
    message: message,
    onDismiss: () => complete(false),
    buttons: [
      OverlayPopupButton(label: "Cancel", onPressed: () => complete(false)),
      OverlayPopupButton(label: "Proceed", onPressed: () => complete(true)),
    ],
  );

  return completer.future;
}

/// Shows an error popup with the given message and an OK button. If [above]
/// is provided, renders directly above that OverlayEntry (see
/// [showOverlayPopup]).
void showErrorOverlay(BuildContext context, String message,
    {OverlayEntry? above}) {
  OverlayEntry? popupEntry;
  popupEntry = showOverlayPopup(
    context,
    above: above,
    message: message,
    buttons: [
      OverlayPopupButton(label: "OK", onPressed: () => popupEntry?.remove()),
    ],
  );
}

/// Shows a non-dismissible spinner popup with the given message, returning
/// the entry so the caller can remove it when the work completes. If [above]
/// is provided, renders directly above that OverlayEntry (see
/// [showOverlayPopup]).
OverlayEntry showSpinnerOverlay(BuildContext context, String message,
    {OverlayEntry? above}) {
  final color = Theme.of(context).colorScheme.primary;
  return showOverlayPopup(
    context,
    above: above,
    message: message,
    dismissible: false,
    extra: CircularProgressIndicator(color: color),
  );
}
