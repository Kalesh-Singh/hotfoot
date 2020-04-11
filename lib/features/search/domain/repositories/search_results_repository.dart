import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/search/domain/entities/search_result_entity.dart';
import 'package:meta/meta.dart';

abstract class ISearchResultsRepository {
  Future<Either<Failure, List<SearchResultEntity>>>
      getResultsWithMatchingAddress({@required String address});
}
