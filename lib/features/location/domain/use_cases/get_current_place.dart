import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

class GetCurrentPlace implements UseCase<PlaceModel, NoParams> {
  final ILocationRepository locationRepository;

  const GetCurrentPlace({@required this.locationRepository});

  @override
  Future<Either<Failure, PlaceModel>> call(NoParams params) async {
    return await locationRepository.getCurrentPlace();
  }
}
