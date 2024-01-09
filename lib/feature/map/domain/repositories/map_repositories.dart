import 'package:trudd_track_your_buddy/core/utils/typedef.dart';

abstract class MapRepository {
  FailureOrPlaces getSearchResults(String query);
}
