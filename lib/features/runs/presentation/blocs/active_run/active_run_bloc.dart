import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_active_run.dart';
import 'package:hotfoot/features/runs/presentation/blocs/active_run/active_run_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/active_run/active_run_state.dart';
import 'package:meta/meta.dart';

class ActiveRunBloc extends Bloc<ActiveRunEvent, ActiveRunState> {
  static const String _ERROR_MSG = 'Failed to get active run';

  final GetActiveRun getActiveRun;

  ActiveRunBloc({@required this.getActiveRun});

  @override
  ActiveRunState get initialState => ActiveRunUninitialized();

  @override
  Stream<ActiveRunState> mapEventToState(ActiveRunEvent event) async* {
    if (event is ActiveRunRequested) {
      print('ACTIVE RUN REQUESTED');
      final failureOrActiveRun = await getActiveRun(event.userType);
      yield* _eitherFailureOrActiveRun(failureOrActiveRun);
    }
  }

  Stream<ActiveRunState> _eitherFailureOrActiveRun(
    Either<Failure, RunModel> failureOrCustomerRunsIds,
  ) async* {
    yield failureOrCustomerRunsIds.fold(
        (failure) => ActiveRunLoadFailure(message: _ERROR_MSG), (activeRun) {
      if (activeRun == null) {
        return NoActiveRuns();
      } else {
        return RunActive(activeRun: activeRun);
      }
    });
  }
}
