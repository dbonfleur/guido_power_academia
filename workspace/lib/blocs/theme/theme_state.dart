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
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 224, 224, 224),
      ),
      primaryIconTheme: const IconThemeData(
        color: Color.fromARGB(228, 0, 0, 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorPurple),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        ),
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
