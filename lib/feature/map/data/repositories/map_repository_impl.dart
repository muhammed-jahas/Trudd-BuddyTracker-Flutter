import 'package:dartz/dartz.dart';
import 'package:trudd_track_your_buddy/core/errors/errors.dart';
import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/map/data/data_sources/google_map_data_sources.dart';
import 'package:trudd_track_your_buddy/feature/map/data/models/place_model.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/entities/place_entities.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/repositories/map_repositories.dart';

class MapRepositoryImpl extends MapRepository {
  @override
  FailureOrPlaces getSearchResults(String query) async {
    final googlDataSource = GMapDataSource();
    List<PlaceEntity> places = [];
    final response = await googlDataSource.getSearchResults(query);
    final result = response.fold((error) {
      print('-----------error $error');
      return error;
    }, (data) {
      // print('---------------------------- $data ');
      final features = data['features'];
      if (features.isNotEmpty) {
        final List locations = features.map((feature) {
          final placeName = feature['place_name'];
          final coordinates = feature['geometry']['coordinates'];
          final latitude = coordinates[1];
          final longitude = coordinates[0];

          return {
            'placeName': placeName,
            'latitude': latitude,
            'longitude': longitude,
          };
        }).toList();
        places = locations.map((e) => PlaceModel.fromJson(e)).toList();
      }
      return places;
    });
    return response.isLeft()
        ? Left(result as AppException)
        : Right(result as List<PlaceEntity>);
  }
}
