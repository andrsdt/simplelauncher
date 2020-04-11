import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:simplelauncher/bloc/apps_bloc/apps_bloc.dart';
import 'package:simplelauncher/bloc/home_apps_bloc/home_apps_bloc.dart';
import 'package:simplelauncher/bloc/search_bloc/search_bloc.dart';
import 'package:simplelauncher/bloc/theme_bloc/theme_bloc.dart';
import 'package:simplelauncher/ui/screens/global/widgets/poppins_text.dart';
import 'package:simplelauncher/ui/screens/settings_screen/settings_screen.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          margin: EdgeInsets.fromLTRB(30, 5, 10, 0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                PoppinsText(
                  "Apps",
                  letterSpacing: -0.8,
                  size: 35,
                  weight: FontWeight.w500,
                ),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    },
                    onLongPress: () {
                      DeviceApps.openApp("com.android.settings");
                    },
                    child: Container(
                      width: 60,
                      height: 50,
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).accentColor,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(children: <Widget>[
              Container(
                // TODO: intentar que estos valores no estén hardcoded
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height - 100,
                child: BlocBuilder<AppsBloc, AppsState>(
                  builder: (BuildContext context, AppsState state) {
                    if (state is AppsLoadSuccess) {
                      // TODO: implementar que el usuario pueda elegir si al buscar aplicaciones le salen las escondidas o no

                      Map<Application, bool> filteredMap =
                          Map.from(state.allApps)
                            ..removeWhere((k, v) => v == true);

                      List<Application> listaTodosLosTextos = state
                          .allApps.entries
                          .map((entry) => entry.key)
                          .toList();
                      // FINAL TODAS LAS APPS

                      List<Application> listaTextos = filteredMap.entries
                          .map((entry) => entry.key)
                          .toList();
                      // FINAL SOLO LAS FILTRADAS

                      return ListaAppsSearch(
                        listaTextos: listaTextos,
                        listaTodosLosTextos: listaTodosLosTextos,
                      );
                    } else if (state is AppsInitial)
                      return Text("-");
                    else if (state is AppsLoadInProgress)
                      return LinearProgressIndicator();
                    else if (state is AppsLoadFailure)
                      return Text("Apps couldn't be loaded");
                  },
                ),
              ),
            ])
          ])),
    );
  }
}

class ListaAppsSearch extends StatelessWidget {
  const ListaAppsSearch({Key key, this.listaTextos, this.listaTodosLosTextos})
      : super(key: key);
  final List<Application> listaTextos;
  final List<Application> listaTodosLosTextos;

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => AppsBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        )
      ],
      child: Column(children: <Widget>[
        SingleChildScrollView(
          child: FilterBar(
              textController: _textController, listaTextos: listaTextos),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial)
              return Expanded(child: FilteredList(filteredApps: listaTextos));
            else if (state is SearchResults)
              return Expanded(
                  child: FilteredList(filteredApps: state.filteredApps));
          },
        )
      ]),
    ));
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    Key key,
    @required TextEditingController textController,
    @required this.listaTextos,
  })  : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final List<Application> listaTextos;

  @override
  Widget build(BuildContext context) {
    SearchBloc _searchBloc = BlocProvider.of<SearchBloc>(context);
    return TextField(
        style: TextStyle(color: Theme.of(context).accentColor),
        controller: _textController,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Theme.of(context).accentColor),
          hintText: 'Search',
        ),
        onTap: () => _searchBloc.add(SearchMock()),
        onChanged: (text) =>
            _searchBloc.add(SearchItemChange(text, this.listaTextos)));
  }
}

class FilteredList extends StatelessWidget {
  const FilteredList({Key key, this.filteredApps}) : super(key: key);

  final List<Application> filteredApps;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: filteredApps.length ?? 0,
        itemBuilder: (context, index) {
          return PositionedTapDetector(
              child: PoppinsText(
                filteredApps[index].appName,
                size: 25,
                weight: FontWeight.w400,
                height: 2,
              ),
              onTap: (e) => DeviceApps.openApp(filteredApps[index].packageName),
              onLongPress: (TapPosition pos) {
                _showPopupMenu(pos, context, index);
              });
        });
  }

  _showPopupMenu(TapPosition pos, BuildContext context, int index) async {
    HomeAppsBloc _homeAppsBloc = BlocProvider.of<HomeAppsBloc>(context);
    double left = pos.global.dx;
    double top = pos.global.dy;
    bool selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, top, left, 0),
      items: [
        PopupMenuItem<bool>(
          child: new Text("Add to homepage"),
          value: true,
        )
      ],
      elevation: 8.0,
    );
    if (selected) {
      _homeAppsBloc.add(HomeAppsToggle(filteredApps[index]));
    }
  }
}
