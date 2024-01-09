import 'package:dartz/dartz.dart';
import 'package:trudd_track_your_buddy/core/errors/errors.dart';
import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/room/data/data_sources/spot_remote_data_sources.dart';
import 'package:trudd_track_your_buddy/feature/room/data/models/creator_model.dart';
import 'package:trudd_track_your_buddy/feature/room/data/models/joiner_model.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/creator_entity.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/joniner_entity.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/repositories/spot_repository.dart';

class SpotRepositoryImpl extends SpotRepository {
  final spotRemoteDataSource = SpotRemoteDataSource();
  @override
  FailureOrCreator createSpot(Map<String, dynamic> body) async {
    final response = await spotRemoteDataSource.createSpot(body);
    final result = response.fold(
      (error) => error,
      (data) {
        if (data['status'] == 'success') {
          return CreatorModel.fromJson(data);
        } else {
          return CustomException(message: 'Failed to create a Spot');
        }
      },
    );
    return response.isLeft()
        ? Left(result as AppException)
        : Right(result as CreatorEntity);
  }

  @override
  FailureOrJoiner joinSpot(Map<String, dynamic> body) async {
    final response = await spotRemoteDataSource.joinSpot(body);
    final result = response.fold((error) => error, (data) {
      if (data['status'] == 'success') {
        return JoinerModel.fromJson(data);
      } else {
        return CustomException(message: data['message']);
      }
    });

    return result is AppException
        ? Left(result)
        : Right(result as JoinerEntity);
  }
}
