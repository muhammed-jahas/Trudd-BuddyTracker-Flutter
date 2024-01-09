import '../../../../core/utils/typedef.dart';

abstract class SpotRepository {
  FailureOrCreator createSpot(Map<String, dynamic> body);
  FailureOrJoiner joinSpot(Map<String, dynamic> body);
}
