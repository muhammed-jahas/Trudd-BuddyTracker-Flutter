import 'package:trudd_track_your_buddy/feature/map/domain/entities/place_entities.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel(
      {required super.placeName,
      required super.latitude,
      required super.longitude});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      placeName: json['placeName'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
    );
  }
}
