import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:simplelauncher/ui/screens/global/theme/app_theme.dart';
import 'package:simplelauncher/ui/screens/global/theme/user_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeState(
      themeData: appThemeData[UserTheme(
          backgroundColor: Color(0x000000),
          textColor: Color(0xffffff))]); // Dark theme by default

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    UserTheme prefTheme = await _loadTheme();
    if (event is ThemeStarted) {
      yield ThemeState(themeData: prefTheme.getTheme());
    } else if (event is ThemeChanged) {
      _persistTheme(event.theme);
      yield ThemeState(themeData: event.theme.getTheme());
    }
  }

  void _persistTheme(UserTheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("TextColor", theme.getTheme().accentColor.value);
    prefs.setInt("BackgroundColor", theme.getTheme().backgroundColor.value);
  }

  Future<UserTheme> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Color textColor =
        Color(prefs.getInt("TextColor") ?? 0xffffff).withOpacity(1);
    Color backgroundColor =
        Color(prefs.getInt("BackgroundColor") ?? 0x000000).withOpacity(1);
    return UserTheme(backgroundColor: backgroundColor, textColor: textColor);
  }
}
