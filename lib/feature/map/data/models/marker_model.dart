import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/marker_entities.dart';

class MarkerModel extends MarkerEntity {
  MarkerModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.position,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    final latitude = json["latitude"];
    final longitude = json["longitude"];
    final latlng = LatLng(latitude, longitude);
    return MarkerModel(
      id: json["_id"],
      userId: json["userId"],
      name: json["name"],
      position: latlng,
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'userId': userId,
        'latitude': position.latitude.toString(),
        'longtitude': position.longitude.toString()
      };
}
