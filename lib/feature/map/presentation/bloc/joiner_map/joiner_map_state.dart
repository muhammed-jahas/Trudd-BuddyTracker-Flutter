part of 'joiner_map_bloc.dart';

class JoinerMapState {}

final class JoinerMapInitial extends JoinerMapState {}

final class PositionSetState extends JoinerMapState {
  final LatLng currentPosition;
  final Set<Marker> markers;

  PositionSetState({required this.currentPosition, required this.markers});
}
