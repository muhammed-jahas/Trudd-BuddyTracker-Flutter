import 'package:trudd_track_your_buddy/core/network/network_service.dart';
import 'package:trudd_track_your_buddy/core/utils/typedef.dart';

import '../../../../core/network/network_url.dart';


class SpotRemoteDataSource {
  EitherResponse createSpot(rawData) async =>
      NetworkService.postApi(rawData, createSpotUrl);
  EitherResponse joinSpot(rawData) async =>
      NetworkService.postApi(rawData, joinSpotUrl);
}
