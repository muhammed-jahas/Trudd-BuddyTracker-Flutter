part of 'spot_bloc.dart';

abstract class SpotState {}

abstract class ErrorState extends SpotState {}

final class SpotInitial extends SpotState {}

final class SpotLoadingState extends SpotState {
  final bool isCreator;

  SpotLoadingState({required this.isCreator});
}

final class SpotCreatedState extends SpotState {
  final CreatorEntity creator;
  final bool isCreator;

  SpotCreatedState({this.isCreator = true, required this.creator});
}

final class SpotJoinedState extends SpotState {
  final JoinerEntity joiner;
  final bool isCreator;

  SpotJoinedState({required this.joiner, this.isCreator = false});
}

final class SpotFailedState extends ErrorState {
  final String error;
  final bool isCreator;

  SpotFailedState({required this.isCreator, required this.error});
}

final class LocationFetchedState extends SpotState {}

