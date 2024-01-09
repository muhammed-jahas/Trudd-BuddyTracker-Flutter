class CreatorEntity {
  final String id;
  final String spotId;
  final String userName;
  final String userMobile;
  final String spotCode;
  final double latitude;
  final double longitude;
  final bool isLeader;

  CreatorEntity({
    required this.id,
    required this.spotId,
    required this.userName,
    required this.userMobile,
    required this.spotCode,
    required this.latitude,
    required this.longitude,
    required this.isLeader,
  });
}
