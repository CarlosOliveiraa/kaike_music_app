import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff121212),
    primaryColor: const Color(0xff1DB954),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff1DB954),
      secondary: Color(0xff1DB954),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
