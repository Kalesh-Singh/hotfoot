import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/search/domain/repositories/search_results_repository.dart';
import 'package:meta/meta.dart';

class GetMatchingAddresses implements UseCase<List<String>, String> {
  final ISearchResultsRepository searchResultsRepository;

  const GetMatchingAddresses({@required this.searchResultsRepository});

  @override
  Future<Either<Failure, List<String>>> call(String params) async {
    return await searchResultsRepository.getMatchingAddresses(address: params);
  }
}
