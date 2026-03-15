// Copyright (c) 2026 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';

ThemeData _normalTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}

ThemeData _nightVisionTheme() {
  const Color pureRed = Color.fromARGB(255, 255, 0, 0);
  const Color darkRed = Color.fromARGB(255, 160, 0, 0);
  const Color darkGray = Color.fromARGB(255, 64, 64, 64);
  const Color mediumGray = Color.fromARGB(255, 128, 128, 128);
  const Color veryDarkRed = Color.fromARGB(255, 24, 0, 0);
  return ThemeData(
      primaryColor: pureRed,
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: pureRed),
        bodyMedium: TextStyle(color: pureRed),
        bodyLarge: TextStyle(color: pureRed),
      ),
      colorScheme: const ColorScheme.dark(
        surface: veryDarkRed,
        onSurface: pureRed,
        primary: pureRed,
        onPrimary: darkGray,
        secondary: pureRed,
        onSecondary: darkGray,
        tertiary: mediumGray,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black,
        contentTextStyle: const TextStyle(color: pureRed),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: darkRed, width: 4),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: pureRed),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: pureRed),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: pureRed),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: pureRed, width: 2),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return pureRed;
          }
          return darkRed;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkRed;
          }
          return darkGray;
        }),
        trackOutlineColor: WidgetStateProperty.all(darkRed),
      ),
      dividerTheme: DividerThemeData(
        color: pureRed,
      ),
      useMaterial3: true);
}

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = _normalTheme();
  bool _isNightVisionTheme = false;

  void setNormalTheme() {
    if (_isNightVisionTheme) {
      currentTheme = _normalTheme();
      _isNightVisionTheme = false;
      notifyListeners();
    }
  }

  void setNightVisionTheme() {
    if (!_isNightVisionTheme) {
      currentTheme = _nightVisionTheme();
      _isNightVisionTheme = true;
      notifyListeners();
    }
  }
}
