import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_state.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<MatchingAddressesBloc, MatchingAddressesState>(
        builder: (BuildContext context, state) {
          if (state is MatchingAddressesEmpty) {
            return _buildSearchResultsList(List<String>());
          } else if (state is MatchingAddressesSearching) {
            return CircularProgressIndicator();
          } else if (state is MatchingAddressesSearched) {
            print('search success');
            return _buildSearchResultsList(state.matchingAddresses);
          } else if (state is MatchingAddressesFailure) {
            return Text(state.message);
          } else {
            print('unknown bloc state');
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildSearchResultsList(List<String> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return SearchResultsListEntry(
          placeAddress: searchResults[index],
        );
      },
    );
  }
}

class SearchResultsListEntry extends StatelessWidget {
  final String placeAddress;

  const SearchResultsListEntry({Key key, this.placeAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$placeAddress'),
    );
  }
}
