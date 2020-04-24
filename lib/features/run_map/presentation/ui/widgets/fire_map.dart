import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
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
  }

  void _animateToLocation({@required LatLng latLng}) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng)),
    );
  }

  Future<void> _insertOrUpdateRunnerLocation({@required String runId}) async {
    final coordinates = await deviceLocation.getLocation();
    final location = LocationModel(
      lat: coordinates.latitude,
      lng: coordinates.longitude,
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
