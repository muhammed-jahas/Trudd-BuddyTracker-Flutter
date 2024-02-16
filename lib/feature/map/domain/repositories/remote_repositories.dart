import 'package:trudd_track_your_buddy/core/utils/typedef.dart';

abstract class RemoteRepository {
  FailureOrMarker joinSpot(var body);
  FailureOrMarker updateMarker(var body, String id);
}
