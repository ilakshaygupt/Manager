

import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Colors.deepPurple;
  
  static const _defaultAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 2,
  );

  static final _defaultCardTheme = CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  static final _defaultInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
  );

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    appBarTheme: _defaultAppBarTheme,
    cardTheme: _defaultCardTheme,
    inputDecorationTheme: _defaultInputDecorationTheme,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    appBarTheme: _defaultAppBarTheme,
    cardTheme: _defaultCardTheme,
    inputDecorationTheme: _defaultInputDecorationTheme,
  );
}