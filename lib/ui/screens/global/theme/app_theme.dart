import 'package:flutter/material.dart';

enum AppTheme { Light, Dark, Preferences }

final appThemeData = {
  
  // DEFAULT THEMES
  AppTheme.Light: ThemeData(
    // brightness: Brightness.light,
    backgroundColor: Colors.white,
    primaryColorLight: Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.black,
  ),

  AppTheme.Dark: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      // backgroundColor: Colors.black,
      primaryColorDark: Colors.black,
      primaryColor: Colors.black,
      accentColor: Colors.white,
      textTheme: TextTheme(
        body1: TextStyle(color: Colors.white),
      )),
};


