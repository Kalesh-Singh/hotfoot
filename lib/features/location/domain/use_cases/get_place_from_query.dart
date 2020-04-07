import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class GetPlaceFromQuery implements UseCase<PlaceEntity, String> {
  final ILocationRepository locationRepository;

  const GetPlaceFromQuery({@required this.locationRepository});

  @override
  Future<Either<Failure, PlaceEntity>> call(String params) async {
    return await locationRepository.getPlaceFromQuery(query: params);
  }
}
