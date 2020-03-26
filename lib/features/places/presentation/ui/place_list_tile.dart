import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:hotfoot/features/places/presentation/ui/place_card.dart';
import 'package:hotfoot/injection_container.dart';

class PlaceListTile extends StatelessWidget {
  final String placeId;

  const PlaceListTile({Key key, this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlaceDetailsBloc>(
      create: (context) => sl<PlaceDetailsBloc>(),
      child: Container(
        child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
          builder: (BuildContext context, PlaceDetailsState state) {
            if (state is PlaceDetailsUninitialized) {
              BlocProvider.of<PlaceDetailsBloc>(context)
                  .add(PlaceDetailsRequested(placeId: placeId));
              return Container(
                height: 50,
                child: Center(
                  child: Text('Loading'),
                ),
              );
            } else if (state is PlaceDetailsLoadSuccess) {
              BlocProvider.of<PlaceDetailsBloc>(context)
                  .add(PlacePhotoRequested(placeEntity: state.placeEntity));
              return PlaceCard(placeEntity: state.placeEntity);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
