part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchItemChange extends SearchEvent {
  final String filter;
  final List<Application> allApps;
  const SearchItemChange (this.filter, this.allApps);

    @override
  List<Object> get props => [filter, allApps];
}

class SearchMock extends SearchEvent {}