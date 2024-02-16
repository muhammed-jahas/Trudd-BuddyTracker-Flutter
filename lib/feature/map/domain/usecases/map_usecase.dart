import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/map/data/repositories/remote_repository_impl.dart';

class MapUseCase {
  final remoteRepo = RemoteRepositoryImpl();
  FailureOrMarker joinSpot(var body) => remoteRepo.joinSpot(body);
  FailureOrMarker updateMarker(var body, String id) =>
      remoteRepo.updateMarker(body, id);
}
