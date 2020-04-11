import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/domain/entities/search_result_entity.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_addresses_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_addresses_state.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ResultsWithMatchingAddressBloc,
          ResultsWithMatchingAddressState>(
        builder: (BuildContext context, state) {
          if (state is ResultsWithMatchingAddressEmpty) {
            return _buildSearchResultsList(List<SearchResultEntity>());
          } else if (state is ResultsWithMatchingAddressSearching) {
            return CircularProgressIndicator();
          } else if (state is ResultsWithMatchingAddressSearched) {
            print('search success');
            return _buildSearchResultsList(state.resultsWithMatchingAddress);
          } else if (state is ResultsWithMatchingAddressFailure) {
            return Text(state.message);
          } else {
            print('unknown bloc state');
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildSearchResultsList(List<SearchResultEntity> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return SearchResultsListEntry(
          searchResult: searchResults[index],
        );
      },
    );
  }
}

class SearchResultsListEntry extends StatelessWidget {
  final SearchResultEntity searchResult;

  const SearchResultsListEntry({Key key, this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: Text('${searchResult.address}'),
      ),
      onTap: () {
        print("Selected search result with id (${searchResult.id})");
      },
    );
  }
}
