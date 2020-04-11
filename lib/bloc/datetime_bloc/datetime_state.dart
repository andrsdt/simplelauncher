part of 'datetime_bloc.dart';

abstract class DatetimeState extends Equatable {
  const DatetimeState();
  @override
  List<Object> get props => [];
}

class DatetimeInitial extends DatetimeState {}

class DateTimeChanged extends DatetimeState {
  final String date;
  final String time;

  const DateTimeChanged(this.date, this.time);

  @override
  List<Object> get props => [date,time];

  @override
  String toString() {
    return "DateTimeBloc state: Date and time updated";
  }
}