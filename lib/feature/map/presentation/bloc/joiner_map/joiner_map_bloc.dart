import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/core/constants/keys.dart';
import 'package:trudd_track_your_buddy/core/utils/google_map_helpers.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/entities/marker_entities.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/usecases/map_usecase.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/joniner_entity.dart';

import '../../../../../core/utils/colors.dart';

part 'joiner_map_event.dart';
part 'joiner_map_state.dart';

class JoinerMapBloc extends Bloc<JoinerMapEvent, JoinerMapState> {
  JoinerMapBloc() : super(JoinerMapInitial()) {
    on<SetJoinerEvent>(setJoinerEvent);
    on<UpdateLocationEvent>(updateLocation);
    on<UpdateMarkerEvent>(updateMarker);
    on<ResetJoinerEvent>(resetJoiner);
  }

  late LatLng currentPosition;
  JoinerEntity? joiner;
  String? joinerMarkerId;
  final mapUseCase = MapUseCase();
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  // List<LatLng> polyline = [];
  final polyPoints = PolylinePoints();

  setJoinerEvent(SetJoinerEvent event, Emitter<JoinerMapState> emit) async {
    emit(JoinerLoadingState());
    markers.clear();
    polylines.clear();
    joiner = event.joiner;
    late MarkerEntity marker;
    currentPosition = LatLng(joiner!.latitude, joiner!.longitude);

    final failureOrMarker = await mapUseCase.joinSpot({
      'name': joiner!.userName,
      'latitude': joiner!.latitude.toString(),
      'longitude': joiner!.longitude.toString(),
      'userId': joiner!.id,
    });

    failureOrMarker.fold((error) {
      emit(JoinerErrorState(error: error.message));
      return;
    }, (markerEntity) {
      marker = markerEntity;
      joinerMarkerId = markerEntity.id;
    });
    if (joinerMarkerId == null) return;
    final currentLocationMarker = await MapHelper.getMarkerIcon(
      currentPosition,
      joiner!.id,
      marker.name,
      isJoiner: true,
    );
    final destinationMarker = await MapHelper.getMarkerIcon(
      joiner!.spot.destination,
      'destination',
      'dest',
      isDestination: true,
    );

    final polyline = await _drawPolyLine(
        currentPos: currentPosition, dest: joiner!.spot.destination);
    polylines.add(polyline);
    markers.add(currentLocationMarker);
    markers.add(destinationMarker);
    emit(
      PositionSetState(
        currentPosition: currentPosition,
        markers: markers,
        polylines: polylines,
      ),
    );
  }

  void updateLocation(
      UpdateLocationEvent event, Emitter<JoinerMapState> emit) async {
    currentPosition = event.currentPosition;
    if (joinerMarkerId == null) return;
    final location = {
      'id': joinerMarkerId,
      'latitude': event.currentPosition.latitude,
      'longitude': event.currentPosition.longitude
    };

    await mapUseCase.updateMarker(location, joinerMarkerId!);
  }

  Future<void> updateMarker(
      UpdateMarkerEvent event, Emitter<JoinerMapState> emit) async {
    final isMarkerExist = markers
        .any((element) => element.markerId.value == event.joiner['userId']);
    if (isMarkerExist) {
      markers.removeWhere(
          (element) => element.markerId.value == event.joiner['userId']);
    }
    final markerIcon = await MapHelper.getMarkerIcon(
      event.position,
      event.joiner['userId'],
      event.joiner['name'],
    );
    if (event.joiner['userId'] == joiner!.id) {
      polylines.clear();
      final currentpos =
          LatLng(event.joiner['latitude'], event.joiner['longitude']);
      final polyline = await _drawPolyLine(
        currentPos: currentpos,
        dest: joiner!.spot.destination,
      );
      polylines.add(polyline);
    }
    markers.add(markerIcon);
    emit(
      PositionSetState(
        currentPosition: currentPosition,
        markers: markers,
        polylines: polylines,
      ),
    );
  }

  resetJoiner(ResetJoinerEvent event, Emitter<JoinerMapState> emit) {
    joiner = null;
    joinerMarkerId = null;
  }

  Future<Polyline> _drawPolyLine(
      {required LatLng currentPos, required LatLng dest}) async {
    List<LatLng> newRoutes = [];
    try {
      final result = await polyPoints.getRouteBetweenCoordinates(
        googleMapApiKey,
        PointLatLng(currentPos.latitude, currentPos.longitude),
        PointLatLng(dest.latitude, dest.longitude),
      );
      newRoutes =
          result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
    } catch (e) {
      newRoutes = [];
    }

    return Polyline(
      polylineId: PolylineId(joiner!.id),
      points: newRoutes,
      color: AppColor.primaryColor,
      width: 3,
    );
  }
}
