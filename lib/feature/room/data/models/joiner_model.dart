import 'package:trudd_track_your_buddy/feature/room/data/models/spot_model.dart';

import '../../domain/entities/joniner_entity.dart';

class JoinerModel extends JoinerEntity {
  JoinerModel({
    required super.id,
    required super.userName,
    required super.userMobile,
    required super.latitude,
    required super.longitude,
    required super.spot,
    required super.isLeader,
  });
  factory JoinerModel.fromJson(Map<String, dynamic> json) {
    double lat = double.parse(json['user']["latitude"]);
    double long = double.parse(json['user']["longitude"]);
    return JoinerModel(
      id: json['user']['_id'],
      userName: json['user']['userName'],
      userMobile: json['user']['userMobile'],
      latitude: lat,
      longitude: long,
      spot: SpotModel.fromJson(json['spotDetails']),
      isLeader: json['user']['isLeader'],
    );
  }
}
