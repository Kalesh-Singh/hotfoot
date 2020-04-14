import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_state.dart';

class SearchMap extends StatefulWidget {
  @override
  _SearchMap createState() => _SearchMap();
}

class _SearchMap extends State<SearchMap> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final MarkerId singletonMarker = MarkerId('marker');

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(GoogleMapController controller) {
      if (!_controller.isCompleted) {
        _controller.complete(controller);
      }
    }

    void _updateMarker(lat, lng) {
      setState(() {
        _markers[singletonMarker] = Marker(
          markerId: singletonMarker,
          position: LatLng(lat, lng),
        );
      });
    }

    Future<void> _moveToLocation(lat, lng) async {
      GoogleMapController controller = await _controller.future;
      CameraPosition location =
          CameraPosition(target: LatLng(lat, lng), zoom: 14);
      _updateMarker(lat, lng);
      controller.animateCamera(CameraUpdate.newCameraPosition(location));
    }

    return BlocListener<SearchMapBloc, SearchMapState>(
      listener: (context, state) {
        if (state is SearchMapStateLoaded) {
          print(
              "SearchMapStateLoaded with latlng ${state.locationEntity.lat}, ${state.locationEntity.lng}");
          _moveToLocation(state.locationEntity.lat, state.locationEntity.lng);
        } else if (state is SearchMapStateFailure) {
          // TODO: finish.
        }
      },
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}
