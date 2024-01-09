import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/feature/map/data/repositories/map_repository_impl.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/entities/place_entities.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/usecases/map_usecases.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchBlocEvent, SearchState> {
  SearchBloc() : super(SearchBlocInitial()) {
    on<SearchLocationEvent>(_searchLocation);
    on<ClearSearchEvent>(_clearSearchEvent);
    on<SetLocationEvent>(_setLocation);
  }
  LatLng? destination;

  final mapUseCase = MapUsecase(mapRepository: MapRepositoryImpl());

  Future<void> _searchLocation(
      SearchLocationEvent event, Emitter<SearchState> emit) async {
    final results = await mapUseCase.getSearchResults(event.query);
    results.fold((error) {
      emit(SearchErrorState(error: error.message));
    }, (data) {
      emit(SearchSuccessState(results: data));
    });
  }

  void _clearSearchEvent(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchBlocInitial());
  }

  void _setLocation(SetLocationEvent event, Emitter<SearchState> emit) {
    destination = event.position;
    final marker = Marker(
      markerId: const MarkerId('destination'),
      icon: BitmapDescriptor.defaultMarker,
      position: event.position,
    );
    emit(MapLocationSetState(marker: marker));
  }
}
