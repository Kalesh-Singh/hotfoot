import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:meta/meta.dart';

class GetPlaceById implements UseCase<PlaceEntity, String> {
  final IPlacesRepository placesRepository;

  const GetPlaceById({@required this.placesRepository});

  @override
  Future<Either<Failure, PlaceEntity>> call(String params) async {
    return await placesRepository.getPlaceById(id: params);
  }
}
