import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class GetCurrentPlace implements UseCase<PlaceEntity, NoParams> {
  final ILocationRepository locationRepository;

  const GetCurrentPlace({@required this.locationRepository});

  @override
  Future<Either<Failure, PlaceEntity>> call(NoParams params) async {
    return await locationRepository.getCurrentPlace();
  }
}
