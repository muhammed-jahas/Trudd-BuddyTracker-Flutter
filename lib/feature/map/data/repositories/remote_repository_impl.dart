import 'package:dartz/dartz.dart';
import 'package:trudd_track_your_buddy/core/errors/errors.dart';
import 'package:trudd_track_your_buddy/core/utils/typedef.dart';
import 'package:trudd_track_your_buddy/feature/map/data/data_sources/remote_data_sources.dart';
import 'package:trudd_track_your_buddy/feature/map/domain/repositories/remote_repositories.dart';

import '../../domain/entities/marker_entities.dart';
import '../models/marker_model.dart';

class RemoteRepositoryImpl extends RemoteRepository {
  MapViewRemoteDataSource dataSource = MapViewRemoteDataSource();
  @override
  FailureOrMarker joinSpot(body) async {
    final response = await dataSource.joinSpot(body);
    final data = response.fold((l) => l, (r) => MarkerModel.fromJson(r));
    return response.isLeft()
        ? Left(data as AppException)
        : Right(data as MarkerEntity);
  }

  @override
  FailureOrMarker updateMarker(body, id) async {
    final response = await dataSource.updateMarker(body, id);
    final data = response.fold((l) => l, (r) => MarkerModel.fromJson(r));
    return response.isLeft()
        ? Left(data as AppException)
        : Right(data as MarkerEntity);
  }
}
