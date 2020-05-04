import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/get_route_between_points.dart';
import 'package:hotfoot/features/run_map/domain/use_cases/insert_or_update_runner_location.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_state.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_event.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

class RunnerLocationBloc
    extends Bloc<RunnerLocationEvent, RunnerLocationState> {
  final InsertOrUpdateRunnerLocation insertOrUpdateRunnerLocation;
  final UpdateOrInsertRun updateOrInsertRun;
  final GetPlaceById getPlaceById;
  final GetRouteBetweenPoints getRouteBetweenPoints;
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  LatLng cameraLocation;
  BitmapDescriptor runnerIcon;
  BitmapDescriptor pickupIcon;
  BitmapDescriptor destinationIcon;

  RunnerLocationBloc({
    @required this.insertOrUpdateRunnerLocation,
    @required this.updateOrInsertRun,
    @required this.getPlaceById,
    @required this.getRouteBetweenPoints,
  });

  @override
  RunnerLocationState get initialState => RunnerLocationUninitialized();

  @override
  Stream<RunnerLocationState> mapEventToState(
      RunnerLocationEvent event) async* {
    if (event is RunnerLocationUpdated) {
      await _loadCustomMarkers();
      // Important locations for maps provided below.
      final LocationModel runnerLocation = event.runnerLocation;
      final LocationModel pickupLocation = await _getPickupLocation(event);
      final LocationModel destinationLocation = _getDestinationLocation(event);
      print("RunnerLocation = $runnerLocation");
      print("PickupLocation = $pickupLocation");
      print("DestinationLocation = $destinationLocation");
      final String runId = event.runModel.id;
      final UserType userType = event.userType;

      if (userType == UserType.RUNNER) {
        // Update the runner's location in firestore.
        final updateLocationEither =
            await insertOrUpdateRunnerLocation(RunnerLocationParams(
          runId: runId,
          runnerLocation: runnerLocation,
        ));

        updateLocationEither.fold(
          (failure) => print('Failed to update runner location in firestore'),
          (success) => print('Updated runner location in firestore'),
        );

        // TODO: use the updateOrInsertRun use case to update run status
        // based on runner's proximity to pickup location, destination etc.
        // For instance when the runner is X miles away from pick location,
        // change status to "Picking up your order".
        // When the runner is X miles away from destination location,
        // change status to "Arriving soon"

        await _allMarkersAndRoutes(
            runnerLocation, pickupLocation, destinationLocation);
      } else if (userType == UserType.CUSTOMER) {
        if (runnerLocation == null) {
          print("Runner location not available");
          markers.add(_makeMarker("pickup", pickupLocation, pickupIcon));
          markers.add(
              _makeMarker("destination", destinationLocation, destinationIcon));
          cameraLocation = LatLng(pickupLocation.lat, pickupLocation.lng);
        } else {
          await _allMarkersAndRoutes(
              runnerLocation, pickupLocation, destinationLocation);
        }
      }

      yield RunnerLocationUpdateSuccess(
        runModel: event.runModel,
        runnerLocation: event.runnerLocation,
        polylines: polylines,
        markers: markers,
        cameraLocation: cameraLocation,
      );
    }
  }

  Future<LocationModel> _getPickupLocation(RunnerLocationUpdated event) async {
    LocationModel pickupLocation;
    await event.runModel.pickupPlaceIdOrCustomPlace.fold(
      (pickupPlaceId) async {
        final placeDetailEither = await getPlaceById(pickupPlaceId);
        placeDetailEither.fold(
          (failure) {
            print('Failed to get Pickup Place Details');
          },
          (placeEntity) {
            pickupLocation = placeEntity.locationEntity;
          },
        );
      },
      (customPickupPlace) {
        pickupLocation = customPickupPlace.locationEntity;
      },
    );
    return pickupLocation;
  }

  LocationModel _getDestinationLocation(RunnerLocationUpdated event) {
    return event.runModel.destinationPlace.locationEntity;
  }

  Polyline _makePolyline(String id, List<LatLng> points) {
    return Polyline(
        polylineId: PolylineId(id),
        width: 5,
        points: points,
        color: Colors.black);
  }

  // TODO: Different marker description and icons
  Marker _makeMarker(
      String id, LocationEntity position, BitmapDescriptor icon) {
    return Marker(
        markerId: MarkerId(id),
        position: LatLng(position.lat, position.lng),
        icon: icon);
  }

  Future<void> _allMarkersAndRoutes(
    LocationModel runnerLocation,
    LocationModel pickupLocation,
    LocationModel destinationLocation,
  ) async {
    final routeEither1 = await getRouteBetweenPoints(
        PolylineParams(l1: runnerLocation, l2: pickupLocation));
    await routeEither1.fold(
      (failure) {
        print("Failed");
        RunnerLocationUpdateFailure();
      },
      (route1) async {
        print("Found route between Runner and Pickup");
        final routeEither2 = await getRouteBetweenPoints(
            PolylineParams(l1: pickupLocation, l2: destinationLocation));
        routeEither2.fold((failure) => RunnerLocationUpdateFailure(), (route2) {
          print("Found route between Pickup and Destination");
          polylines.add(_makePolyline("poly1", route1));
          polylines.add(_makePolyline("poly2", route2));
          markers.add(_makeMarker("runner", runnerLocation, runnerIcon));
          markers.add(_makeMarker("pickup", pickupLocation, pickupIcon));
          markers.add(
              _makeMarker("destination", destinationLocation, destinationIcon));
          cameraLocation = LatLng(runnerLocation.lat, runnerLocation.lng);
        });
      },
    );
  }

  Future<void> _loadCustomMarkers() async {
    final runnerIconBytes =
        await getBytesFromAsset('assets/runner_marker.png', 150);
    final pickupIconBytes =
        await getBytesFromAsset('assets/pickup_marker.png', 60);
    final destinationIconBytes =
        await getBytesFromAsset('assets/destination_marker.png', 100);
    runnerIcon = BitmapDescriptor.fromBytes(runnerIconBytes);
    pickupIcon = BitmapDescriptor.fromBytes(pickupIconBytes);
    destinationIcon = BitmapDescriptor.fromBytes(destinationIconBytes);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
