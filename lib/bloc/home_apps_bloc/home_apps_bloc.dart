import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_apps_event.dart';
part 'home_apps_state.dart';

class HomeAppsBloc extends Bloc<HomeAppsEvent, HomeAppsState> {
  @override
  HomeAppsState get initialState => HomeAppsInitial();

  @override
  Stream<HomeAppsState> mapEventToState(HomeAppsEvent event) async* {
    if (event is HomeAppsAdd) yield* _mapHomeAppsAddToState(event.app);
    else if (event is HomeAppsRemove) yield* _mapHomeAppsRemoveToState(event.app);
    else if (event is HomeAppsLoad) yield* _mapHomeAppsLoadToState();
    else if (event is HomeAppsToggle)yield* _mapHomeAppsToggleToState(event.app);
    // else if (event is HomeAppsRename) yield* mapHomeAppsRenameToState(event.app, event.newName);
  }

  Stream<HomeAppsState> _mapHomeAppsAddToState(Application app) async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> homeApps = prefs.getStringList("HomeApps") ?? [];
    List<String> aux = homeApps..add(app.packageName);
    prefs.setStringList("HomeApps", aux);

    final allApps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeSystemApps: true);

    List<Application> res = allApps.where((e) => aux.contains(e.packageName));
    yield HomeAppsLoaded(res);
  }

  Stream<HomeAppsState> _mapHomeAppsRemoveToState(Application app) async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> homeApps = prefs.getStringList("HomeApps") ?? [];

    List<String> aux = homeApps..remove(app.packageName);
    prefs.setStringList("HomeApps", aux);

    final allApps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeSystemApps: true);

    List<Application> res = allApps.where((e) => aux.contains(e.packageName));
    yield HomeAppsLoaded(res);
  }

  Stream<HomeAppsState> _mapHomeAppsToggleToState(Application app) async* {
    yield HomeAppsLoading();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> homeApps = prefs.getStringList("HomeApps") ?? [];

    List<String> aux;
    if (homeApps.contains(app.packageName)) {
      aux = List.from(homeApps)..remove(app.packageName);
    } else {
      aux = List.from(homeApps)..add(app.packageName);
    }

    prefs.setStringList("HomeApps", aux);

    final allApps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeSystemApps: true);

    List<Application> res = [];

    // TODO: implementar sin usar for
    for (String packageName in aux) {
      res.add(
        allApps.firstWhere((e) => e.packageName == packageName)
      );
    }
    yield HomeAppsLoaded(res);
  }

  // TODO: implementar
  // Stream<HomeAppsState> mapHomeAppsRenameToState(Application app, String newName) async* {}

  Stream<HomeAppsState> _mapHomeAppsLoadToState() async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> homeApps = prefs.getStringList("HomeApps") ?? [];

    final allApps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true, includeSystemApps: true);

    List<Application> res =
        allApps.where((e) => homeApps.contains(e.packageName)).toList();
    yield HomeAppsLoaded(res);
  }
}