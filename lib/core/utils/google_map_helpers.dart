import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:trudd_track_your_buddy/core/constants/map.dart';

class MapHelper {
  static Future<Uint8List> getBytesFromCanvas(Color color, String text) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = color;
    const int height = 80;
    const int width = 80;

    canvas.drawCircle(const Offset(width / 2, height / 2), width / 2, paint);

    TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 50.0, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas,
        Offset((width - painter.width) / 2, (height - painter.height) / 2));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  static Future<LatLng?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // final currentPos = Marker(
      //     markerId: const MarkerId('currentPos'),
      //     icon: BitmapDescriptor.defaultMarker,
      //     position: LatLng(position.latitude, position.longitude));
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  static Future<List<LatLng>> fetchRoute(LatLng start, LatLng dest) async {
    const apiKey = 'AIzaSyAWktkmf1xJM-2dQriSVBNm15Ai8XHweCo';
    List<LatLng> polylineCoordinates = [];
    final polylinePoints = PolylinePoints();
    final origin = PointLatLng(start.latitude, start.longitude);
    final destination = PointLatLng(dest.latitude, dest.longitude);

    final result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      origin,
      destination,
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    return polylineCoordinates;
  }

  static getSearchResults(String query) async {
    final String endpoint =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json';

    final response =
        await http.get(Uri.parse('$endpoint?access_token=$mapBoxApiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];

      if (features.isNotEmpty) {
        final results = features.map((feature) {
          final placeName = feature['place_name'];
          final coordinates = feature['geometry']['coordinates'];
          final latitude = coordinates[1];
          final longitude = coordinates[0];

          return {
            'placeName': placeName,
            'latitude': latitude,
            'longitude': longitude,
          };
        }).toList();
        print(results);
        print(results.runtimeType);
        return results;
      }
    }

    return [];
  }
}
