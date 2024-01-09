import 'package:trudd_track_your_buddy/feature/room/data/models/spot_model.dart';

class JoinerEntity {
  final String id;
  final String userName;
  final String userMobile;
  final double latitude;
  final double longitude;
  final SpotModel spot;
  final bool isLeader;

  JoinerEntity({
    required this.id,
    required this.userName,
    required this.userMobile,
    required this.latitude,
    required this.longitude,
    required this.spot,
    required this.isLeader,
  });
}
