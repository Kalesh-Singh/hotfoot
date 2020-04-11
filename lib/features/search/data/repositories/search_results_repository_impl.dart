import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/network/network_info.dart';
import 'package:hotfoot/features/search/data/data_sources/search_results_data_source.dart';
import 'package:hotfoot/features/search/domain/repositories/search_results_repository.dart';
import 'package:meta/meta.dart';

class SearchResultsRepository implements ISearchResultsRepository {
  final ISearchResultsDataSource searchResultsDataSource;
  final INetworkInfo networkInfo;

  SearchResultsRepository({
    @required this.searchResultsDataSource,
    @required this.networkInfo,
  })  : assert(searchResultsDataSource != null),
        assert(networkInfo != null);

  @override
  Future<Either<Failure, List<String>>> getMatchingAddresses(
      {@required String address}) async {
    if (!(await networkInfo.isConnected)) {
      return Left(DatabaseFailure());
    }
    try {
      print('Getting matching addresses from remote data source');
      final searchResults =
          await searchResultsDataSource.getMatchingAddresses(address: address);
      print('Got search results from remote data source');
      print('Number of search results ${searchResults.length}');
      return Right(searchResults);
    } catch (e) {
      print('Exception $e');
      return Left(FirestoreFailure());
    }
  }
}
