import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isLightTheme;

  ThemeState._(this.themeData, this.isLightTheme);

  factory ThemeState.light() {
    const colorPurple = Color.fromARGB(255, 183, 34, 221);
    return ThemeState._(ThemeData.light().copyWith(
      primaryColor: colorPurple,
      appBarTheme: const AppBarTheme(
        color: colorPurple,
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
