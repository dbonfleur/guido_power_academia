import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isLightTheme;

  ThemeState._(this.themeData, this.isLightTheme);

  factory ThemeState.light() {
    return ThemeState._(ThemeData.light().copyWith(
      primaryColor: Colors.purple,
      appBarTheme: const AppBarTheme(
        color: Colors.purple,
      ),
    ), true);
  }

  factory ThemeState.dark() {
    return ThemeState._(ThemeData.dark().copyWith(
      primaryColor: Colors.deepPurple,
      appBarTheme: const AppBarTheme(
        color: Colors.deepPurple,
      ),
    ), false);
  }
}
