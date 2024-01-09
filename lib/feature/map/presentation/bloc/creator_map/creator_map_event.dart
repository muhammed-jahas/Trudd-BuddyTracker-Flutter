part of 'creator_map_bloc.dart';

abstract class CreatorMapEvent {}

class LoadMapEvent extends CreatorMapEvent {
  final CreatorEntity creator;

  LoadMapEvent({required this.creator});
}
