import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
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

  RunnerLocationBloc({
    @required this.insertOrUpdateRunnerLocation,
    @required this.updateOrInsertRun,
    @required this.getPlaceById,
  });

  @override
  RunnerLocationState get initialState => RunnerLocationUninitialized();

  @override
  Stream<RunnerLocationState> mapEventToState(
      RunnerLocationEvent event) async* {
    if (event is RunnerLocationUpdated) {
      final LocationModel runnerLocation = event.runnerLocation;
      final LocationModel pickupLocation = await _getPickupLocation(event);
      final LocationModel destinationLocation = _getDestinationLocation(event);
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

        // TODO: (zaykha) use insert or update run use case to update run status
        // based on runner's proximity to pickup location, destination etc.
        // For instance when the runner is X miles away from pick location,
        // change status to "Picking up your order".
        // When the runner is X miles away from destination location,
        // change status to "Arriving soon"

        // TODO: (zaykha) Handle all map manipulation here
        // you can get the controller from either the event or the state.
        // doesn't really matter, its the same reference.
      } else if (userType == UserType.CUSTOMER) {
        // TODO: Handle updates to the customer map here.
      }

      yield RunnerLocationUpdateSuccess(
        runModel: event.runModel,
        runnerLocation: event.runnerLocation,
        mapController: event.mapController,
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
}
