import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplelauncher/bloc/apps_bloc/apps_bloc.dart';
import 'package:simplelauncher/bloc/home_apps_bloc/home_apps_bloc.dart';
import 'package:simplelauncher/bloc/theme_bloc/theme_bloc.dart';
import 'package:simplelauncher/ui/screens/global/scroll/no_glow_behavior.dart';
import 'package:simplelauncher/ui/screens/home_screen/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]); // Full screen
    // ScreenUtil.init(context, width: 412, height: 846, allowFontScaling: false);
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeBloc()..add(ThemeStarted())),
          BlocProvider(create: (context) => AppsBloc()..add(AppsStarted())),
          BlocProvider(
              create: (context) => HomeAppsBloc()..add(HomeAppsLoad())),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            AppsBloc _appsBloc = BlocProvider.of<AppsBloc>(context);
            _appsBloc.add(AppsLoadRequest());
            return MaterialApp(
                theme: state.themeData,
                home: SafeArea(
                  top: true,
                  bottom: true,
                  child: ScrollConfiguration(
                    behavior: NoGlowBehavior(),
                    child: DefaultTabController(length: 2, child: MainScreen()),
                  ),
                ));
          },
        ));
  }
}
