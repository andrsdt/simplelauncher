import 'package:flutter/material.dart';

class UserTheme {
  // CUSTOM THEME
  Color backgroundColor;
  Color textColor;

  UserTheme({this.backgroundColor, this.textColor});

  ThemeData getTheme() {
    if (this.textColor.alpha < 25)
      this.textColor = Color.fromARGB(
          25, this.textColor.red, this.textColor.green, this.textColor.blue);
    // prevents setting an invisible textColor

    return ThemeData(
      accentColor: this.textColor,
      canvasColor: this.backgroundColor,
      backgroundColor: this.backgroundColor,
      scaffoldBackgroundColor: this.backgroundColor,
      unselectedWidgetColor: this.textColor,
      toggleableActiveColor: this.backgroundColor,
      textTheme: TextTheme(
        title: TextStyle(color: this.textColor),
        body1: TextStyle(
          color: this.textColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: this.textColor,
      ),
      hintColor: this.textColor,
      primaryColor: this.textColor.withAlpha(255),
    );
  }

  bool checkWhiteish(Color color) {
    return (color.red > 225 && color.green > 225 && color.blue > 225);
  }

  bool checkBlackish(Color color) {
    return (color.red < 30 && color.green < 30 && color.blue < 30);
  }
}
