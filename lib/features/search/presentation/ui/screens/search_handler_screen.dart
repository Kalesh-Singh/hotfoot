import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_state.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_results_list.dart';

class SearchHandlerScreen extends StatelessWidget {
  // Debounce timer is used with onChange so that unnecessary firestore API
  // calls are not made.
  Timer _debounce;
  static const int _DEBOUNCE_DURATION_MS = 500;

  @override
  Widget build(BuildContext context) {
    // According to https://github.com/felangel/bloc/issues/587, this is a false
    // positive.
    // ignore: close_sinks
    ResultsWithMatchingAddressBloc _resultsWithMatchingAddressBloc =
        BlocProvider.of<ResultsWithMatchingAddressBloc>(context);

    return BlocListener<ResultsWithMatchingAddressBloc,
        ResultsWithMatchingAddressState>(
      listener: (context, state) {
        if (state is ResultsWithMatchingAddressSelected) {
          Navigator.pop(context, state.placeId);
        }
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        splashColor: Colors.grey,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              hintText: "Enter the location address..."),
                          onChanged: (String value) {
                            if (_debounce?.isActive ?? false)
                              _debounce.cancel();
                            _debounce = Timer(
                                const Duration(
                                    milliseconds: _DEBOUNCE_DURATION_MS), () {
                              _resultsWithMatchingAddressBloc
                                  .add(AddressEntered(placeAddress: value));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: BlocProvider.value(
                    value: _resultsWithMatchingAddressBloc,
                    child: SearchResultsList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
