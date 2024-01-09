import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:trudd_track_your_buddy/core/utils/google_map_helpers.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/joniner_entity.dart';

part 'joiner_map_event.dart';
part 'joiner_map_state.dart';

class JoinerMapBloc extends Bloc<JoinerMapEvent, JoinerMapState> {
  JoinerMapBloc() : super(JoinerMapInitial()) {
    on<SetJoinerEvent>(setJoinerEvent);
    on<UpdateJoinerLocationEvent>(updateJoinerLocationEvent);
  }
  late LatLng currentPosition;
  late JoinerEntity joiner;
  Set<Marker> markers = {};
  Future<void> setJoinerEvent(
      SetJoinerEvent event, Emitter<JoinerMapState> emit) async {
    joiner = event.joiner;
    currentPosition = LatLng(joiner.latitude, joiner.longitude);
    final currentLocationMarker = await getMarker(
        currentPosition, joiner.id, joiner.userName, AppColor.primaryColor);
    final destinationMarker =
        await getMarker(joiner.spot.destination, 'destination', 'dest');
    markers.add(currentLocationMarker);
    markers.add(destinationMarker);

    emit(PositionSetState(currentPosition: currentPosition, markers: markers));
  }

  void updateJoinerLocationEvent(
      UpdateJoinerLocationEvent event, Emitter<JoinerMapState> emit) async {
    currentPosition = event.currentPosition;
    final isMarkerExist =
        markers.any((element) => element.markerId == MarkerId(joiner.id));
    if (isMarkerExist) {
      markers.removeWhere((element) => element.markerId == MarkerId(joiner.id));
    }

    final marker = await getMarker(
      event.currentPosition,
      joiner.id,
      joiner.userName,
      AppColor.primaryColor,
    );

    markers.add(marker);
    emit(PositionSetState(currentPosition: currentPosition, markers: markers));
  }

  Future<Marker> getMarker(LatLng latLng, String id, String name,
      [Color? color]) async {
    final markerIcon = await MapHelper.getBytesFromCanvas(
        AppColor.primaryColor, joiner.userName[0]);
    return Marker(
      markerId: MarkerId(joiner.id),
      icon: color == null
          ? BitmapDescriptor.defaultMarker
          : BitmapDescriptor.fromBytes(markerIcon),
      position: latLng,
    );
  }
}
