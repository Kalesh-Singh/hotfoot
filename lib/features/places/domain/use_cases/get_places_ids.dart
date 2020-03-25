import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/places/domain/repositories/places_repository.dart';
import 'package:meta/meta.dart';

class GetPlacesIds implements UseCase<List<String>, NoParams> {
  final IPlacesRepository placesRepository;

  const GetPlacesIds({@required this.placesRepository});

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await placesRepository.getPlacesIds();
  }
}
