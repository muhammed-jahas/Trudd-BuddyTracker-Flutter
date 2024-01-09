import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/creator_entity.dart';

part 'creator_map_event.dart';
part 'creator_map_state.dart';

class CreatorMapBloc extends Bloc<CreatorMapEvent, CreatorMapState> {
  CreatorMapBloc() : super(CreatorMapInitial()) {
    on<LoadMapEvent>(_setDestination);
  }
  CreatorEntity? creator;

  final Set<Marker> markers = {};
  _setDestination(LoadMapEvent event, Emitter<CreatorMapState> emit) {
    final destination = LatLng(event.creator.latitude, event.creator.longitude);
    creator = event.creator;
    final Marker marker = Marker(
        markerId: const MarkerId('destination'),
        icon: BitmapDescriptor.defaultMarker,
        position: destination);
    markers.add(marker);
    emit(MapDataFetchedState(markers: markers, destination: destination));
  }
}
