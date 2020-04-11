part of 'home_apps_bloc.dart';

abstract class HomeAppsEvent extends Equatable {
  const HomeAppsEvent();
  @override
  List<Object> get props => [];
}


class HomeAppsAdd extends HomeAppsEvent {
  final Application app;

  const HomeAppsAdd(this.app);
  
  @override
  List<Object> get props => [app];
}

class HomeAppsRemove extends HomeAppsEvent {
  final Application app;

  const HomeAppsRemove(this.app);
  
  @override
  List<Object> get props => [app];
}

class HomeAppsToggle extends HomeAppsEvent {
  final Application app;

  const HomeAppsToggle(this.app);
  
  @override
  List<Object> get props => [app];
}

class HomeAppsRename extends HomeAppsEvent {
  final Application app;
  final String newName;

  const HomeAppsRename(this.app, this.newName);
  
  @override
  List<Object> get props => [app, newName];
}

class HomeAppsLoad extends HomeAppsEvent {}