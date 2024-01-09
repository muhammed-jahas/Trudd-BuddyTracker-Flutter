part of 'creator_map_bloc.dart';

abstract class CreatorMapState {}

final class MapDataFetchedState extends CreatorMapState {
  final Set<Marker> markers;
  final LatLng destination;

  MapDataFetchedState({required this.markers, required this.destination});
}

class CreatorMapInitial extends CreatorMapState {}
