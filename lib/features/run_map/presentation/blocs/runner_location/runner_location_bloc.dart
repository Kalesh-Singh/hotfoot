import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runenr_location_state.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/runner_location/runner_location_event.dart';

class RunnerLocationBloc
    extends Bloc<RunnerLocationEvent, RunnerLocationState> {
  @override
  RunnerLocationState get initialState => RunnerLocationUninitialized();

  @override
  Stream<RunnerLocationState> mapEventToState(
      RunnerLocationEvent event) async* {
    if (event is RunnerLocationUpdated) {
      yield RunnerLocationUpdateSuccess(
        runModel: event.runModel,
        runnerLocation: event.runnerLocation,
      );
    }
  }
}
