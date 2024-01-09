part of 'spot_bloc.dart';

abstract class SpotEvent {}

class CreateSpotEvent extends SpotEvent {
  final String name;
  final String mobileNumber;
  final String instruction;

  CreateSpotEvent(
      {required this.name,
      required this.mobileNumber,
      required this.instruction});
}

class JoinSpotEvent extends SpotEvent {
  final String userName;
  final String userMobile;
  final String spotId;

  JoinSpotEvent({
    required this.userName,
    required this.userMobile,
    required this.spotId,
  });
}


class SetDestinationEvent extends SpotEvent {
  final LatLng? destination;

  SetDestinationEvent({this.destination});
}
