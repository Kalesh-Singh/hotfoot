import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_state.dart';

class SearchBar extends StatefulWidget {
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchBarController = TextEditingController();

  MatchingAddressesBloc _matchingAddressesBloc;

  @override
  void initState() {
    super.initState();
    _matchingAddressesBloc = BlocProvider.of<MatchingAddressesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchingAddressesBloc, MatchingAddressesState>(
      listener: (context, state) {
        // TODO: Finish handling the error.
        if (state is MatchingAddressesFailure) {
          String errMsg = state.message;
        }
      },
      child: BlocBuilder<MatchingAddressesBloc, MatchingAddressesState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: TextFormField(
                onFieldSubmitted: (_) {
                  _onFieldSubmitted();
                },
                decoration: InputDecoration(
                  hintText: "Enter the location address",
                  prefixIcon: Icon(Icons.search),
                ),
                controller: _searchBarController,
                keyboardType: TextInputType.emailAddress,
                autovalidate: true,
                autocorrect: false,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  void _onFieldSubmitted() {
    _matchingAddressesBloc
        .add(AddressEntered(placeAddress: _searchBarController.text));
  }
}
