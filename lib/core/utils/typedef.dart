import 'package:dartz/dartz.dart';
import 'package:trudd_track_your_buddy/core/errors/errors.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/entities/place_entities.dart';

import '../../feature/room/domain/entities/creator_entity.dart';
import '../../feature/room/domain/entities/joniner_entity.dart';

typedef FailureOrCreator = Future<Either<AppException, CreatorEntity>>;
typedef FailureOrJoiner = Future<Either<AppException, JoinerEntity>>;
typedef EitherResponse<T> = Future<Either<AppException, T>>;
typedef FailureOrPlaces = Future<Either<AppException, List<PlaceEntity>>>;
// 