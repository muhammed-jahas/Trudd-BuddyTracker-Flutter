import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/repositories/map_repositories.dart';

class MapUsecase {
  final MapRepository mapRepository;

  MapUsecase({required this.mapRepository});

  FailureOrPlaces getSearchResults(String query) =>
      mapRepository.getSearchResults(query);
}
