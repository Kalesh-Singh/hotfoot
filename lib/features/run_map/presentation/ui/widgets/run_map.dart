import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/get_runner_location_stream.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_event.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_state.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:location/location.dart' as DeviceLocation;

class RunMap extends StatefulWidget {
  final UserType userType;

  const RunMap({Key key, this.userType}) : super(key: key);

  @override
  _RunMapState createState() => _RunMapState();
}

class _RunMapState extends State<RunMap> {
  GoogleMapController mapController;
  DeviceLocation.Location deviceLocation = DeviceLocation.Location();
  Set<Polyline> polylines;
  Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RunnerLocationBloc, RunnerLocationState>(
      listener: (context, state) {
        if (state is RunnerLocationUpdateSuccess) {
          setState(() {
            polylines = state.polylines;
            markers = state.markers;
            // TODO: animate camera
          });
        }
      },
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom: 15,
        ),
        onMapCreated: _onMapCreated,
        polylines: polylines,
        markers: markers,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _listenForLocationUpdates();
  }

  void _listenForLocationUpdates() async {
    final UserType userType = this.widget.userType;
    if (userType == UserType.RUNNER) {
      final deviceLocationStream = deviceLocation.onLocationChanged;
      deviceLocationStream.listen(_handleRunnerRunnerLocationUpdate);
    } else if (userType == UserType.CUSTOMER) {
      final runId =
          BlocProvider.of<NavigationScreenBloc>(context).state.runModel.id;
      final runnerLocationStream = await _getRunnerLocationStream(
        getRunnerLocationStream: sl<GetRunnerLocationStream>(),
        runId: runId,
      );
      runnerLocationStream.listen(_handleCustomerRunnerLocationUpdate);
    }
  }

  Future<Stream<QuerySnapshot>> _getRunnerLocationStream({
    @required GetRunnerLocationStream getRunnerLocationStream,
    @required String runId,
  }) async {
    final runnerLocationStreamEither = await getRunnerLocationStream(runId);
    return runnerLocationStreamEither.fold(
          (_) => null,
          (runStream) => runStream,
    );
  }

  void _handleCustomerRunnerLocationUpdate(QuerySnapshot querySnapshot) {
    print('RUNNER LOCATION DOCUMENT CHANGED');
    final runModel =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel;
    LocationModel runnerLocation;
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data.forEach((k, v) {
        print("$k: $v");
      });
      runnerLocation = LocationModel.fromJson(documentSnapshot.data);
    });
    BlocProvider.of<RunnerLocationBloc>(context).add(
      RunnerLocationUpdated(
        runModel: runModel,
        runnerLocation: runnerLocation,
        userType: UserType.CUSTOMER,
      ),
    );
  }

  void _handleRunnerRunnerLocationUpdate(
      DeviceLocation.LocationData locationData) {
    final runModel =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel;
    final runnerLocation =
    LocationModel(lat: locationData.latitude, lng: locationData.longitude);
    print('DEVICE LOCATION UPDATED - RUNNER MAP');
    // Forward events to our custom bloc
    BlocProvider.of<RunnerLocationBloc>(context).add(
      RunnerLocationUpdated(
        runModel: runModel,
        runnerLocation: runnerLocation,
        userType: UserType.RUNNER,
      ),
    );
  }
}
