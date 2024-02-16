import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/repositories/google_repositories.dart';

class GoogleMapUseCase {
  final GoogleRepository googleRepo;

  GoogleMapUseCase({required this.googleRepo});

  FailureOrPlaces getSearchResults(String query) =>
      googleRepo.getSearchResults(query);
}
