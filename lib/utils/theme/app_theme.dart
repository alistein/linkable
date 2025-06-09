import 'package:flutter/material.dart';
import 'package:linkable/utils/theme/app_colors.dart';
import 'package:linkable/utils/app_constants.dart';
import 'package:linkable/utils/app_decorations.dart';

class AppTheme {
  
static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: LightColors.primary,
        foregroundColor: LightColors.muted,
        fixedSize: Size(double.maxFinite, buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.button),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LightColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LightColors.primaryText),

    scaffoldBackgroundColor: LightColors.background
  );
}
