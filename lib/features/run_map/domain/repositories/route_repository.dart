import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

abstract class IRouteRepository {
  Future<Either<Failure, List<LatLng>>> getRouteBetweenPoints(
      {@required LocationEntity l1, @required LocationEntity l2});
}
