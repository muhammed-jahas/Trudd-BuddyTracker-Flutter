import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerEntity {
  final String id;
  final String userId;
  final String name;
  final LatLng position;

  MarkerEntity({
    required this.id,
    required this.name,
    required this.position,
    required this.userId,
  });
}
