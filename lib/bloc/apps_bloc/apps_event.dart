part of 'apps_bloc.dart';

abstract class AppsEvent extends Equatable {
  const AppsEvent();

  @override
  List<Object> get props => [];
}

class AppsLoadRequest extends AppsEvent {}

class AppsStarted extends AppsEvent{}

class AppCheckboxToggled extends AppsEvent {
  final Application toggledApp;

  AppCheckboxToggled(this.toggledApp);
  
  @override
  List<Object> get props => [toggledApp];
}

