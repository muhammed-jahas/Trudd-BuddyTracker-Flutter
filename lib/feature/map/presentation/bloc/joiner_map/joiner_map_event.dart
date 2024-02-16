part of 'joiner_map_bloc.dart';

abstract class JoinerMapEvent {}

class SetJoinerEvent extends JoinerMapEvent {
  final JoinerEntity joiner;

  SetJoinerEvent({required this.joiner});
}

class UpdateLocationEvent extends JoinerMapEvent {
  final LatLng currentPosition;

  UpdateLocationEvent({required this.currentPosition});
}

class UpdateMarkerEvent extends JoinerMapEvent {
  final LatLng position;
  final Map<String, dynamic> joiner;

  UpdateMarkerEvent({required this.position, required this.joiner});
}

class ResetJoinerEvent extends JoinerMapEvent {}
