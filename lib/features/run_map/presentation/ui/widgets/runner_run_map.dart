import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_event.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:location/location.dart' as DeviceLocation;

class RunnerRunMap extends StatefulWidget {
  @override
  _RunnerRunMapState createState() => _RunnerRunMapState();
}

class _RunnerRunMapState extends State<RunnerRunMap> {
  GoogleMapController mapController;
  DeviceLocation.Location deviceLocation = DeviceLocation.Location();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RunnerLocationBloc>(
      create: (context) => sl<RunnerLocationBloc>(),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom: 15,
        ),
        onMapCreated: _onMapCreated,
      ),
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
      // Forward events to our custom bloc
      BlocProvider.of<RunnerLocationBloc>(context).add(RunnerLocationUpdated(
        runModel: runModel,
        runnerLocation: runnerLocation,
        mapController: mapController,
      ));
    });
  }
}
