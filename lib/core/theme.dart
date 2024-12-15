import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
  );
}
