part of 'search_bloc.dart';

abstract class SearchBlocEvent {}

class SearchLocationEvent extends SearchBlocEvent {
  final String query;

  SearchLocationEvent({required this.query});
}

class ClearSearchEvent extends SearchBlocEvent {}

class SetLocationEvent extends SearchBlocEvent {
  final LatLng position;

  SetLocationEvent({required this.position});
}

