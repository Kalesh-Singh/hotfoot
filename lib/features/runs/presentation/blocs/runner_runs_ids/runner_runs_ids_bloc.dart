import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_runner_runs_ids.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/runner_runs_ids/runner_runs_ids_state.dart';
import 'package:meta/meta.dart';

class RunnerRunsIdsBloc
    extends Bloc<RunnerRunsIdsEvent, RunnerRunsIdsState> {
  static const String _ERROR_MSG = 'Failed to retrieve runner runs ids';
  final GetRunnerRunsIds getRunnerRunsIds;

  RunnerRunsIdsBloc({@required this.getRunnerRunsIds});

  @override
  RunnerRunsIdsState get initialState => RunnerRunsIdsUninitialized();

  @override
  Stream<RunnerRunsIdsState> mapEventToState(
      RunnerRunsIdsEvent event) async* {
    if (event is RunnerRunsRequested) {
      print('CUSTOMER RUNS REQUESTED');
      final failureOrRunnerRunsIds = await getRunnerRunsIds(NoParams());
      yield* _eitherLoadedOrFailureState(failureOrRunnerRunsIds);
    }
  }

  Stream<RunnerRunsIdsState> _eitherLoadedOrFailureState(
    Either<Failure, List<String>> failureOrRunnerRunsIds,
  ) async* {
    yield failureOrRunnerRunsIds.fold(
      (failure) => RunnerRunsIdsLoadFailure(message: _ERROR_MSG),
      (runnerRunsIds) =>
          RunnerRunsIdsLoadSuccess(runnerRunsIds: runnerRunsIds),
    );
  }
}
