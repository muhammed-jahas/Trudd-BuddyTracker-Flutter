import 'package:trudd_track_your_buddy/core/utils/typedef.dart';

import '../repositories/spot_repository.dart';

class SpotUsecase {
  final SpotRepository spotRepsitory;

  SpotUsecase(this.spotRepsitory);

  FailureOrCreator createSpot({required Map<String, dynamic> rawData}) =>
      spotRepsitory.createSpot(rawData);
  FailureOrJoiner joinSpot({required Map<String, dynamic> rawData}) =>
      spotRepsitory.joinSpot(rawData);
}
