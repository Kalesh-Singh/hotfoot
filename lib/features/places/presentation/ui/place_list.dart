import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_state.dart';
import 'package:hotfoot/features/places/presentation/ui/place_list_tile.dart';

class PlacesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final placesBloc = BlocProvider.of<PlacesIdsBloc>(context);
    return Center(
      child: BlocBuilder<PlacesIdsBloc, PlacesIdsState>(
        builder: (BuildContext context, state) {
          if (state is PlacesIdsUninitialized) {
            print('requested places');
            placesBloc.add(PlacesRequested());
            return CircularProgressIndicator();
          } else if (state is PlacesIdsLoadFailure) {
            print('places load failure');
            return Text(state.message);
          } else if (state is PlacesIdsLoadSuccess) {
            print('places load success');
            return _buildPlacesList(state.placesIds);
          } else {
            print('unknown bloc state');
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildPlacesList(List<String> placesIds) {
    return ListView.builder(
      itemCount: placesIds.length,
      itemBuilder: (context, index) {
        return PlaceListTile();
      },
    );
  }
}
