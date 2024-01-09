import 'package:trudd_track_your_buddy/core/constants/map.dart';
import 'package:trudd_track_your_buddy/core/network/network_service.dart';
import 'package:trudd_track_your_buddy/core/utils/typedef.dart';

const String searchUrl =
    'https://api.mapbox.com/geocoding/v5/mapbox.places/query.json?country=IN&access_token=$mapBoxApiKey';
    //'$endpoint?access_token=$apiKey'

class GMapDataSource {
  EitherResponse getSearchResults(String query) async {
    final url = searchUrl.replaceFirst('query', query);
    return await NetworkService.getApi(url);
  }
}
