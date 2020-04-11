import 'dart:async';

import 'package:battery/battery.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplelauncher/bloc/datetime_bloc/datetime_bloc.dart';
import 'package:simplelauncher/bloc/home_apps_bloc/home_apps_bloc.dart';
import 'package:simplelauncher/ui/screens/global/widgets/poppins_text.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Battery _battery = Battery();

  StreamSubscription<BatteryState> _batteryStateSubscription;

  int batteryLevel;
  bool charging = false;
  @override
  void initState() {
    if (this.mounted) {
    super.initState();
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        charging = (state == BatteryState.charging);
      });
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    // Para cerrar el teclado en la pantalla principal
    getBattery();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BlocProvider(
                create: (context) => DatetimeBloc()..add(Update()),
                child: Container(
                  // Barra superior (hora, fecha, bateria)
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BlocBuilder<DatetimeBloc, DatetimeState>(
                        builder: (context, state) {
                          DatetimeBloc _datetimeBloc =
                              BlocProvider.of<DatetimeBloc>(context);
                          if (state is DatetimeInitial) {
                            _triggerDatetimeUpdate(_datetimeBloc);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildTime(""),
                                buildDate(""),
                              ],
                            );
                          } else if (state is DateTimeChanged) {
                            _triggerDatetimeUpdate(_datetimeBloc);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildTime(state.time),
                                buildDate(state.date),
                              ],
                            );
                          }
                        },
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          PoppinsText(
                            "${this.charging ? "⚡" : ""} ${this.batteryLevel}%",
                            size: 16,
                            weight: FontWeight.w500,
                            height: 2,
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              BlocBuilder<HomeAppsBloc, HomeAppsState>(
                builder: (context, state) {
                  if (state is HomeAppsLoaded) {
                    return Expanded(
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for (Application app in state.apps)
                                GestureDetector(
                                  onTap: () =>
                                      DeviceApps.openApp(app.packageName),
                                  child: PoppinsText(app.appName,
                                      size: 30,
                                      weight: FontWeight.w500,
                                      height: 1.4),
                                )
                            ],
                          )
                        ],
                      ),
                    );
                  } else if (state is HomeAppsLoading) {
                    return Container();
                  } else if (state is HomeAppsInitial) {
                    return Container();
                  }
                },
              )
            ],
          )),
    );
  }

  PoppinsText buildDate(String date) {
    return PoppinsText(
      date,
      size: 18,
      weight: FontWeight.w500,
      height: 0.5,
    );
  }

  PoppinsText buildTime(String time) {
    return PoppinsText(
      time,
      size: 35,
      weight: FontWeight.w500,
      letterSpacing: -1.5,
    );
  }

  _triggerDatetimeUpdate(DatetimeBloc _datetimeBloc) {
    Timer.periodic(Duration(seconds: 1), (e) => _datetimeBloc.add(Update()));
  }

  getBattery() async {
    if (this.mounted){
    int temp = await _battery.batteryLevel;
    setState(() {
      this.batteryLevel = temp;
    });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
  }
}
