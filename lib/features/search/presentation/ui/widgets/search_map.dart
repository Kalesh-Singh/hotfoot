import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_state.dart';

class SearchMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchMapBloc, SearchMapState>(
      builder: (context, state) {
        if (state is SearchMapLoaded) {
          final lat = state.locationEntity.lat;
          final lng = state.locationEntity.lng;
          print("SearchMapLoaded with latlng $lat, $lng");
          CameraPosition location =
              CameraPosition(target: LatLng(lat, lng), zoom: 14);
          Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
          final MarkerId singletonMarker = MarkerId('marker');
          _markers[singletonMarker] = Marker(
            markerId: singletonMarker,
            position: LatLng(lat, lng),
          );

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: location,
            markers: Set<Marker>.of(_markers.values),
          );
        } else {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
            ),
          );
        }
      },
    );
  }
}
