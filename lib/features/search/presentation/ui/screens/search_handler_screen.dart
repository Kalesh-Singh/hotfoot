import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_state.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_event.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_results_list.dart';

class SearchHandlerScreen extends StatelessWidget {
  // Debounce timer is used with onChange so that unnecessary firestore API
  // calls are not made.
  Timer _debounce;
  static const int _DEBOUNCE_DURATION_MS = 500;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResultsWithMatchingAddressBloc,
        ResultsWithMatchingAddressState>(
      listener: (context, state) {
        if (state is ResultsWithMatchingAddressSelected) {
          BlocProvider.of<SearchHandlerScreenBloc>(context)
              .add(SearchResultSelectedFromList(placeId: state.placeId));
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
                          BlocProvider.of<SearchHandlerScreenBloc>(context)
                              .add(BackButtonPressed());
                        },
                      ),
                      Expanded(
                        child: TextField(
                          style: style.copyWith(fontSize: 14),
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
                              BlocProvider.of<ResultsWithMatchingAddressBloc>(
                                      context)
                                  .add(AddressEntered(placeAddress: value));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ButtonTheme(
                  minWidth: 140.0,
                  height: 40.0,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    icon: FaIcon(FontAwesomeIcons.mapMarkerAlt,
                        color: Colors.white),
                    onPressed: () {
                      BlocProvider.of<SearchHandlerScreenBloc>(context)
                          .add(ManuallyLocateButtonPressed());
                    },
                    label: Text('Manually locate place',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: SearchResultsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
