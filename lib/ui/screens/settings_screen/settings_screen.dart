import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:simplelauncher/bloc/theme_bloc/theme_bloc.dart';
import 'package:simplelauncher/ui/screens/global/theme/user_theme.dart';
import 'package:simplelauncher/ui/screens/global/widgets/poppins_text.dart';

import 'hide_apps_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color pickerColor = Color(0xffffff);
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color textColor = Theme.of(context).accentColor;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PoppinsText(
              "Settings",
              letterSpacing: -0.8,
              size: 35,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PoppinsText(
                    "Background color",
                    size: 20,
                    height: 2,
                  ),
                  GestureDetector(
                    child: Container(
                        width: 40,
                        height: 40,
                        child: Text("   "),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: (backgroundColor == Colors.black)
                                    ? Colors.white10
                                    : Colors.black26,
                                width: 4),
                            color: Theme.of(context).scaffoldBackgroundColor)),
                    onTap: () {
                      // BACKGROUND COLOR PICKER
                      if (this.mounted) {
                      setState(() {
                        pickerColor = Theme.of(context).backgroundColor;
                      });
                      }
                      chooseBackgroundColor(
                          backgroundColor, context, textColor);
                    },
                  ),
                ]),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PoppinsText(
                  "Text color",
                  size: 20,
                  height: 2,
                ),
                GestureDetector(
                  child: Container(
                      width: 40,
                      height: 40,
                      child: Text("   "),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: (textColor == Colors.black)
                                  ? Colors.white38
                                  : Colors.black38,
                              width: 4),
                          color: textColor)),
                  onTap: () {
                    // TEXT COLOR PICKER
                    if (this.mounted) {
                    setState(() {
                      pickerColor = Theme.of(context).accentColor;
                    });
                    }
                    chooseTextColor(textColor, context, backgroundColor);
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HideAppsScreen())),
                  child: PoppinsText(
                    "Hide apps",
                    size: 20,
                    height: 2,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future chooseBackgroundColor(
      Color backgroundColor, BuildContext context, Color textColor) {
    return showDialog(
      child: AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              labelTextStyle: TextStyle(color: Colors.black),
              enableAlpha: false,
              pickerColor: backgroundColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(UserTheme(
                    backgroundColor: pickerColor, textColor: textColor)));
                Navigator.of(context).pop();
              },
            )
          ]),
      context: context,
    );
  }

  Future chooseTextColor(
      Color textColor, BuildContext context, Color backgroundColor) {
    return showDialog(
      child: AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              labelTextStyle: TextStyle(color: Colors.black),
              enableAlpha: true,
              pickerColor: textColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(UserTheme(
                    backgroundColor: backgroundColor, textColor: pickerColor)));
                Navigator.of(context).pop();
              },
            )
          ]),
      context: context,
    );
  }

  void changeColor(Color color) {
    if (this.mounted) {
    setState(() => pickerColor = color);
    }
  }

  bool checkWhiteish(Color color) {
    return (color.red > 225 && color.green > 225 && color.blue > 225);
  }

  bool checkBlackish(Color color) {
    return (color.red < 30 && color.green < 30 && color.blue < 30);
  }
}
