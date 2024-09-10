import 'package:blog_app_clean_architecture/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPalette.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(AppPalette.gradient2),
      errorBorder: _border(AppPalette.errorColor),
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPalette.backgroundColor,
      ),
      side: BorderSide.none,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.backgroundColor,
    ),
  );
}
