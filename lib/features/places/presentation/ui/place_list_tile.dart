import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:hotfoot/injection_container.dart';

class PlaceListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceDetailsBloc>(
      create: (context) => sl<PlaceDetailsBloc>(),
      child: Container(
        child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
          builder: (BuildContext context, PlaceDetailsState state) {
            if (state is PlaceDetailsUninitialized) {
              return Container(
                height: 50,
                child: Center(
                  child: Text('Loading'),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
