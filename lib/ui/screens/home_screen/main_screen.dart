import 'package:flutter/material.dart';
import 'package:simplelauncher/ui/screens/apps/apps_screen.dart';

import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        HomeScreen(),
        AppsScreen(),
      ],
    );
  }
}
