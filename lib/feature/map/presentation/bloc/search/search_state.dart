part of 'search_bloc.dart';

abstract class SearchState {}

abstract class SearchActionState extends SearchState {}

final class SearchBlocInitial extends SearchActionState {}

final class SearchSuccessState extends SearchActionState {
  final List<PlaceEntity> results;

  SearchSuccessState({required this.results});
}

final class SearchErrorState extends SearchActionState {
  final String error;

  SearchErrorState({required this.error});
}

final class MapLocationSetState extends SearchState {
  final Marker marker;

  MapLocationSetState({required this.marker});
}
