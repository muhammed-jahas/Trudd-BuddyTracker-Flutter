import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/core/utils/google_map_helpers.dart';
import 'package:trudd_track_your_buddy/feature/room/data/repositories/spot_repository_impl.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/creator_entity.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/joniner_entity.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/usecases/spot_usecases.dart';

part 'spot_event.dart';
part 'spot_state.dart';

class SpotBloc extends Bloc<SpotEvent, SpotState> {
  SpotBloc() : super(SpotInitial()) {
    on<CreateSpotEvent>(createSpotEvent);
    on<JoinSpotEvent>(joinSpotEvent);
    on<SetDestinationEvent>(setDestinationEvent);
  }

  final spotUsecase = SpotUsecase(SpotRepositoryImpl());
  LatLng? destination;

  void createSpotEvent(CreateSpotEvent event, Emitter<SpotState> emit) async {
    if (destination == null) {
      emit(SpotFailedState(isCreator: true, error: 'Please choose a Location'));
      return;
    }

    final rawData = {
      'leaderName': event.name,
      'leaderMobile': event.mobileNumber,
      'spotInstructions': event.instruction,
      'latitude': destination!.latitude,
      'longitude': destination!.longitude
    };
    emit(SpotLoadingState(isCreator: true));
    final failureOrCreator = await spotUsecase.createSpot(rawData: rawData);
    failureOrCreator.fold(
      (error) => emit(SpotFailedState(error: error.message, isCreator: true)),
      (data) {
        emit(SpotCreatedState(creator: data));
        destination = null;
      },
    );
  }

  void joinSpotEvent(JoinSpotEvent event, Emitter<SpotState> emit) async {
    emit(SpotLoadingState(isCreator: false));
    final location = await MapHelper.getCurrentLocation();
    if (location == null) {
      emit(SpotFailedState(
          isCreator: false, error: 'Failed to get your cordinates'));
      return;
    }

    final rawData = {
      'spotId': event.spotId,
      'userName': event.userName,
      'userMobile': event.userMobile,
      'latitude': location.latitude,
      'longitude': location.longitude
    };

    final failureOrJoiner = await spotUsecase.joinSpot(rawData: rawData);
    failureOrJoiner.fold(
      (error) => emit(SpotFailedState(isCreator: false, error: error.message)),
      (data) => emit(SpotJoinedState(joiner: data)),
    );
  }

  FutureOr<void> setDestinationEvent(
      SetDestinationEvent event, Emitter<SpotState> emit) async {
    if (event.destination == null) {
      final location = await MapHelper.getCurrentLocation();
      if (location == null) {
        emit(SpotFailedState(
            isCreator: true, error: 'Unable to get current location'));
        return;
      }
      destination = location;
      emit(LocationFetchedState());
    } else {
      destination = event.destination;
      emit(LocationFetchedState());
    }
  }
}
