import '../../../../core/network/network_service.dart';
import '../../../../core/network/network_url.dart';
import '../../../../core/utils/typedef.dart';

class MapViewRemoteDataSource {
  EitherResponse joinSpot(rawData) async =>
      NetworkService.postApi(rawData, addMarker);
  EitherResponse updateMarker(rawData, String id) async =>
      NetworkService.putApi(rawData, updateMarkerUrl + id);
}
