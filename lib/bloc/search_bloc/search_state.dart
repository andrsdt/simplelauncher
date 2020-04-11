part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchResults extends SearchState {
  final List<Application> filteredApps;
  const SearchResults(this.filteredApps);
  
  @override
  List<Object> get props => [filteredApps];
}
