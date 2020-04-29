import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/run_map/domain/repositories/route_repository.dart';
import 'package:meta/meta.dart';

class GetRouteBetweenPoints implements UseCase<List<LatLng>, PolylineParams> {
  final IRouteRepository routeRepository;

  const GetRouteBetweenPoints({@required this.routeRepository});

  @override
  Future<Either<Failure, List<LatLng>>> call(PolylineParams params) async {
    return await routeRepository.getRouteBetweenPoints(
        l1: params.l1, l2: params.l2);
  }
}

class PolylineParams {
  final LocationEntity l1;
  final LocationEntity l2;

  const PolylineParams({
    @required this.l1,
    @required this.l2,
  });
}
