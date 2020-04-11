import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplelauncher/bloc/apps_bloc/apps_bloc.dart';
import 'package:simplelauncher/ui/screens/global/scroll/no_glow_behavior.dart';
import 'package:simplelauncher/ui/screens/global/widgets/poppins_text.dart';

class HideAppsScreen extends StatefulWidget {
  HideAppsScreen({Key key}) : super(key: key);

  @override
  _HideAppsScreenState createState() => _HideAppsScreenState();
}

class _HideAppsScreenState extends State<HideAppsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PoppinsText(
                    "Hide apps",
                    size: 35,
                    letterSpacing: -0.8,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: MediaQuery.of(context).size.height - 150,
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: BlocBuilder<AppsBloc, AppsState>(
                        builder: (context, state) {
                          if (state is AppsLoadSuccess) {
                            return listaAppsCheckbox(state);
                          } else if (state is AppsInitial) {
                            return Text("Apps not loaded");
                          } else if (state is AppsLoadInProgress) {
                            return Text("Loading...");
                          } else if (state is AppsLoadFailure)
                            return Text("Error $state");
                        },
                      ),
                    ),
                  )
                ])));
  }

  ListView listaAppsCheckbox(AppsLoadSuccess state) {
    return ListView.builder(
        itemCount: state.allApps != null ? state.allApps.length : 0,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  PoppinsText(
                    state.allApps.keys.elementAt(index).appName,
                    size: 25,
                    weight: FontWeight.w400,
                    height: 2,
                  ),
                  Checkbox(
                    value: state.allApps.values.elementAt(index),
                    checkColor: Theme.of(context).backgroundColor,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (bool value) {
                      AppsBloc _appsBloc = BlocProvider.of<AppsBloc>(context);
                      _appsBloc.add(AppCheckboxToggled(
                          state.allApps.keys.elementAt(index)));
                          if (this.mounted) {
                      setState(() {
                        value = !value;
                      });
                          }
                    },
                  ),
                ],
              ),
            ));
  }
}
