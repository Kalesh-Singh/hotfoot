import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class ILocationRepository {
  Future<Either<Failure, PlaceEntity>> getCurrentPlace(
      {@required LocationEntity latLng});

  Future<Either<Failure, PlaceEntity>> getPlaceFromAddress(
      {@required String address});
}
