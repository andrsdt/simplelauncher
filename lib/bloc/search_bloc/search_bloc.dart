import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchState get initialState => SearchInitial();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchItemChange) {
      yield* _mapSearchItemChangeToState(event.filter, event.allApps);
    }
  }

  Stream<SearchState> _mapSearchItemChangeToState(
      String app, List<Application> allApps) async* {
    if (app == "") yield SearchResults(allApps);
    var res = allApps
        .where((e) => e.appName.toLowerCase().contains(app.toLowerCase()));
    yield SearchResults(res.toList());
  }
}
