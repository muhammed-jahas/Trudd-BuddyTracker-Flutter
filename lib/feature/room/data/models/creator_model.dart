import 'package:trudd_track_your_buddy/feature/room/domain/entities/creator_entity.dart';

class CreatorModel extends CreatorEntity {
  CreatorModel(
      {required super.id,
      required super.spotId,
      required super.userName,
      required super.userMobile,
      required super.spotCode,
      required super.latitude,
      required super.longitude,
      required super.isLeader});

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    double lat=double.parse(json['user']['latitude']);
    double long=double.parse(json['user']['longitude']);
    return CreatorModel(
      id: json['user']['_id'],
      spotId: json['id'] ?? '',
      userName: json['user']['userName'],
      userMobile: json['user']['userMobile'],
      spotCode: json['spotId'],
      latitude: lat,
      longitude:long,
      isLeader: json['user']['isLeader'],
    );
  }
}

// {
//     "status": "success",
//     "message": "Spot Registered Successfully",
//     "spotId": "23B6-68ED-5F3D",
//     "id": "658d606f1cce4522aaa30a92",
//     "user": {
//         "userName": "Dilshad",
//         "userMobile": "+918569475680",
//         "longitude": "56.23456",
//         "latitude": "12.456",
//         "isLeader": true,
//         "_id": "658d606f1cce4522aaa30a93"
//     }
// }