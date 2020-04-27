import 'package:flutter/material.dart';
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
      // Important locations for maps provided below.
      final LocationModel runnerLocation = event.runnerLocation;
      final LocationModel pickupLocation = await _getPickupLocation(event);
      final LocationModel destinationLocation = _getDestinationLocation(event);
      final String runId = event.runModel.id;
      final UserType userType = event.userType;
      Set<Polyline> polylines;
      Set<Marker> markers;

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

        // TODO: (zaykha) use the updateOrInsertRun use case to update run status
        // based on runner's proximity to pickup location, destination etc.
        // For instance when the runner is X miles away from pick location,
        // change status to "Picking up your order".
        // When the runner is X miles away from destination location,
        // change status to "Arriving soon"

        final routeEither1 = await getRouteBetweenPoints(
            PolylineParams(l1: runnerLocation, l2: pickupLocation));
        routeEither1.fold(
              (failure) => RunnerLocationUpdateFailure(),
              (route1) async {
            final routeEither2 = await getRouteBetweenPoints(
                PolylineParams(l1: pickupLocation, l2: destinationLocation));
            routeEither2.fold((failure) => RunnerLocationUpdateFailure(),
                    (route2) {
                  polylines.add(_makePolyline("poly1", route1));
                  polylines.add(_makePolyline("poly2", route2));
                  markers.add(_makeMarker("runner", runnerLocation));
                  markers.add(_makeMarker("pickup", pickupLocation));
                  markers.add(_makeMarker("destination", destinationLocation));
                });
          },
        );
      } else if (userType == UserType.CUSTOMER) {
        // TODO: (zaykha) Handle updates to the customer's map here.

      }

      yield RunnerLocationUpdateSuccess(
        runModel: event.runModel,
        runnerLocation: event.runnerLocation,
        polylines: polylines,
        markers: markers,
      );
    }
  }

  Future<LocationModel> _getPickupLocation(RunnerLocationUpdated event) async {
    LocationModel pickupLocation;
    event.runModel.pickupPlaceIdOrCustomPlace.fold(
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
        width: 10,
        points: points,
        color: Colors.black);
  }

  Marker _makeMarker(String id, LocationEntity position) {
    return Marker(
        markerId: MarkerId(id),
        position: LatLng(position.lat, position.lng),
        icon: BitmapDescriptor.defaultMarker);
  }
}
