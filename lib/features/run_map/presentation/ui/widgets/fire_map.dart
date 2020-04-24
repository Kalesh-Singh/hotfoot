import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:location/location.dart' as DeviceLocation;

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  DeviceLocation.Location deviceLocation = DeviceLocation.Location();

  Firestore firestore = Firestore.instance;
  Geoflutterfire geoflutterfire = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(24.142, -110.321),
            zoom: 15,
          ),
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _listenForLocationUpdates();
  }

  void _animateToLocation({@required LatLng latLng}) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng)),
    );
  }

  void _listenForLocationUpdates() {
    final runId =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel.id;
    final locationStream = deviceLocation.onLocationChanged;
    locationStream.listen((DeviceLocation.LocationData locationData) {
      print('DEVICE LOCATION UPDATED');
      _insertOrUpdateRunnerLocation(runId: runId, locationData: locationData);
    });
  }

  Future<void> _insertOrUpdateRunnerLocation({
    @required String runId,
    @required DeviceLocation.LocationData locationData,
  }) async {
    final location = LocationModel(
      lat: locationData.latitude,
      lng: locationData.longitude,
    );
    return firestore
        .collection('runs')
        .document(runId)
        .collection('run')
        .document(runId)
        .collection('runnerLocation')
        .document('location')
        .setData(location.toJson());
  }
}
