// Copyright (c) 2024 Steven Rosenthal smr@dt3.org
// See LICENSE file in root directory for license terms.

import 'package:flutter/material.dart';

ThemeData _normalTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    // colorScheme: const ColorScheme.dark(),
    useMaterial3: true,
  );
}

ThemeData _nightVisionTheme() {
  const Color pureRed = Color.fromARGB(255, 255, 0, 0);
  return ThemeData(
      primaryColor: pureRed,
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: pureRed),
        bodyMedium: TextStyle(color: pureRed),
        bodyLarge: TextStyle(color: pureRed),
      ),
      colorScheme: const ColorScheme.dark(
        background: Color(0xff202020),
        onBackground: pureRed,
        surface: Color(0xff200000),
        onSurface: pureRed,
        primary: pureRed,
        // primary: Colors.red,
        onPrimary: Color(0xff404040),
        secondary: pureRed,
        onSecondary: Color(0xff404040),
        tertiary: Color(0xff808080),
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
