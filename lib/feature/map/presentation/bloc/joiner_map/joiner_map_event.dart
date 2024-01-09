part of 'joiner_map_bloc.dart';

abstract class JoinerMapEvent {}

class SetJoinerEvent extends JoinerMapEvent {
  final JoinerEntity joiner;

  SetJoinerEvent({required this.joiner});
}

class UpdateJoinerLocationEvent extends JoinerMapEvent {
  final LatLng currentPosition;

  UpdateJoinerLocationEvent({required this.currentPosition});
}
