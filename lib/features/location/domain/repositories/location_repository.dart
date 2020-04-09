import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class ILocationRepository {
  Future<Either<Failure, PlaceModel>> getCurrentPlace();

  Future<Either<Failure, PlaceModel>> getPlaceFromQuery(
      {@required String query});
}
