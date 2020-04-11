import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'datetime_event.dart';
part 'datetime_state.dart';

class DatetimeBloc extends Bloc<DatetimeEvent, DatetimeState> {
  @override
  DatetimeState get initialState => DatetimeInitial();

  @override
  Stream<DatetimeState> mapEventToState(
    DatetimeEvent event,
  ) async* {
    yield* _mapDateTimeUpdateToState();
  }

  Stream<DatetimeState> _mapDateTimeUpdateToState() async* {
    DateTime now = DateTime.now();
    yield DateTimeChanged(_datePrettify(now), _timePrettify(now));
  }

  String _datePrettify(DateTime date) {
    return DateFormat().addPattern("EEEE, MMMM d").format(date);
  }

  String _timePrettify(DateTime time) {
    return DateFormat().add_jm().format(time);
  }
}
