part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
    @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final UserTheme theme;

  ThemeChanged(this.theme);

  @override
  List<Object> get props => [theme];
}

class ThemeStarted extends ThemeEvent{}