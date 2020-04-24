import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_event.dart';
import 'package:location/location.dart' as DeviceLocation;

class CustomerRunMap extends StatefulWidget {
  @override
  _CustomerRunMapState createState() => _CustomerRunMapState();
}

class _CustomerRunMapState extends State<CustomerRunMap> {
  GoogleMapController mapController;
  DeviceLocation.Location deviceLocation = DeviceLocation.Location();

  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(24.142, -110.321),
        zoom: 15,
      ),
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      compassEnabled: true,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _listenForLocationUpdates();
  }

  void _listenForLocationUpdates() {
    final locationStream = deviceLocation.onLocationChanged;
    locationStream.listen((DeviceLocation.LocationData locationData) {
      final runModel =
          BlocProvider.of<NavigationScreenBloc>(context).state.runModel;
      final runnerLocation = LocationModel(
          lat: locationData.latitude, lng: locationData.longitude);
      print('DEVICE LOCATION UPDATED');
      BlocProvider.of<RunnerLocationBloc>(context).add(RunnerLocationUpdated(
        runModel: runModel,
        runnerLocation: runnerLocation,
        mapController: mapController,
      ));
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
