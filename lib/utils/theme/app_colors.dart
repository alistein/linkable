import 'package:flutter/material.dart';

class LightColors {
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFfafafa),
      100: Color(0xFFf4f4f5),
      200: Color(0xFFe4e4e7),
      300: Color(0xFFd4d4d8),
      400: Color(0xFFa1a1aa),
      500: Color(_primaryValue),
      600: Color(0xFF52525b),
      700: Color(0xFF3f3f46),
      800: Color(0xFF27272a),
      900: Color(0xFF18181b),
    },
  );

  static const int _primaryValue = 0xFF18181b;

  static const Color primaryText = Color(0xFF09090b);
  static const Color secondaryColor = Color(0xFFfafafa);
  static const Color mainTextColor = Color(0xFF09090b);
  static const Color secondaryText = Color(0xFF71717a);
  static const Color mutedText = Color(0xFFa1a1aa);

  static const Color background = Color(0xFFffffff);
  static const Color surface = Color(0xFFffffff);
  static const Color border = Color(0xFFe4e4e7);
  static const Color input = Color(0xFFffffff);
  static const Color card = Color(0xFFffffff);
  static const Color popover = Color(0xFFffffff);
  static const Color accent = Color(0xFFf4f4f5);
  static const Color muted = Color(0xFFf4f4f5);
  
  // Navigation specific colors
  static const Color navBackground = Color(0xFF18181b);
  static const Color navSelected = Color(0xFFfafafa);
  static const Color navUnselected = Color(0xFF71717a);
  static const Color navSelectedBg = Color(0xFF27272a);
}
