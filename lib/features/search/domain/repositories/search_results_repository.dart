import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:meta/meta.dart';

abstract class ISearchResultsRepository {
  Future<Either<Failure, List<String>>> getMatchingAddresses(
      {@required String address});
}
