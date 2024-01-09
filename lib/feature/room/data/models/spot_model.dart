import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpotModel {
  final LatLng destination;
  final String instructions;
  final String creatorName;
  final String creatorMobile;

  SpotModel(
      {required this.destination,
      required this.instructions,
      required this.creatorName,
      required this.creatorMobile});
  factory SpotModel.fromJson(Map<String, dynamic> json) {
    final latitude = double.parse(json["latitude"]);
    final longitude = double.parse(json["longitude"]);
    final location = LatLng(latitude, longitude);
    return SpotModel(
      destination: location,
      instructions: json['spotInstructions'],
      creatorMobile: json['leaderMobile'],
      creatorName: json['leaderName'],
    );
  }
}
