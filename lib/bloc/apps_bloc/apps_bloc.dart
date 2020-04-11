import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'apps_event.dart';
part 'apps_state.dart';

class AppsBloc extends Bloc<AppsEvent, AppsState> {
  @override
  AppsState get initialState => AppsInitial();

  @override
  Stream<AppsState> mapEventToState(AppsEvent event) async* {
    if (event is AppsLoadRequest) {
      yield* _mapAppsLoadSuccessToState();
    }
    if (event is AppCheckboxToggled) {
      yield* _mapAppCheckboxToggledToState(event.toggledApp);
    }
  }

  Stream<AppsState> _mapAppsLoadSuccessToState() async* {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> hiddenApps;

      hiddenApps = prefs.getStringList("HiddenApps") ?? [];

      final allApps = await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true, includeSystemApps: true);

      final listaApps = allApps
        ..sort((a, b) =>
            a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

      final Map<Application, bool> res = {
        for (Application v in listaApps)
          v: hiddenApps.contains(v.packageName) ? true : false
      };

      yield AppsLoadSuccess(res);
    } catch (_) {
      yield AppsLoadFailure();
    }
  }

  Stream<AppsState> _mapAppCheckboxToggledToState(
      Application toggleApp) async* {
    if (state is AppsLoadSuccess) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> hiddenApps = prefs.getStringList("HiddenApps") ?? [];
      if (hiddenApps.contains(toggleApp.packageName)) {
        prefs.setStringList(
            "HiddenApps", hiddenApps..remove(toggleApp.packageName));
      } else if (!hiddenApps.contains(toggleApp.packageName)) {
        prefs.setStringList(
            "HiddenApps", hiddenApps..add(toggleApp.packageName));
      }

      var res = (state as AppsLoadSuccess).allApps;
      int i = 0;
      // TODO implementar sin usar for
      for (Application app in res.keys) {
        if (app.packageName == toggleApp.packageName) break;
        i++;
      }
      res.update(res.keys.elementAt(i), (e) => !e);

      yield AppsLoadInProgress();
      yield AppsLoadSuccess(res);
    }
  }
}
