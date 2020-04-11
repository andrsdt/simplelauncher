part of 'datetime_bloc.dart';

abstract class DatetimeEvent extends Equatable {
  const DatetimeEvent();

  @override
  List<Object> get props => [];
}


class Update extends DatetimeEvent {}