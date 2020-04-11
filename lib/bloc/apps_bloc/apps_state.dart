part of 'apps_bloc.dart';

abstract class AppsState extends Equatable {
  const AppsState();

  @override
  List<Object> get props => [];
}

class AppsInitial extends AppsState {
  @override
  String toString() => "State: AppInitial";
}

class AppsLoadInProgress extends AppsState {
  @override
  String toString() => "State: AppLoadInProgress";
}

class AppsLoadSuccess extends AppsState {
  final Map<Application, bool> allApps;

  const AppsLoadSuccess(this.allApps);

  @override
  List<Object> get props => [allApps];

  @override
  String toString() => "State: AppLoadSuccess, ${allApps.length} entries";
}

class AppsLoadFailure extends AppsState {
  @override
  String toString() => "State: AppLoadFailure";
}
