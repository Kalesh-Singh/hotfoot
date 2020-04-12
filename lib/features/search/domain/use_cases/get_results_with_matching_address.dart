import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/search/domain/repositories/search_results_repository.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class GetResultsWithMatchingAddress
    implements UseCase<List<PlaceEntity>, String> {
  final ISearchResultsRepository searchResultsRepository;

  const GetResultsWithMatchingAddress({@required this.searchResultsRepository});

  @override
  Future<Either<Failure, List<PlaceEntity>>> call(String params) async {
    return await searchResultsRepository.getResultsWithMatchingAddress(
        address: params);
  }
}
