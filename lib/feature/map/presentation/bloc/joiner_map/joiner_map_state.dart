part of 'joiner_map_bloc.dart';

abstract class JoinerMapState {}

abstract class JoinerMapActionState extends JoinerMapState {}

final class JoinerMapInitial extends JoinerMapState {}

final class JoinerLoadingState extends JoinerMapInitial {}

final class PositionSetState extends JoinerMapState {
  final LatLng currentPosition;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  PositionSetState({
    required this.currentPosition,
    required this.markers,
    required this.polylines,
  });
}

class JoinerErrorState extends JoinerMapActionState {
  final String error;

  JoinerErrorState({required this.error});
}
