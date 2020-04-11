part of 'home_apps_bloc.dart';

abstract class HomeAppsState extends Equatable {
  const HomeAppsState();
  @override
  List<Object> get props => [];
}

class HomeAppsInitial extends HomeAppsState {}

class HomeAppsLoaded extends HomeAppsState {
  final List<Application> apps;

  HomeAppsLoaded(this.apps);
  
  @override
  List<Object> get props => [apps];
}

class HomeAppsLoading extends HomeAppsState {}