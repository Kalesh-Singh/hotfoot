import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_event.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_state.dart';

class RunUpdateBloc extends Bloc<RunUpdateEvent, RunUpdateState> {
  @override
  RunUpdateState get initialState => RunUpdateUninitialized();

  @override
  Stream<RunUpdateState> mapEventToState(RunUpdateEvent event) async* {
    if (event is RunUpdated) {
      yield RunUpdateLoadSuccess(runModel: event.runModel);
    }
  }
}
