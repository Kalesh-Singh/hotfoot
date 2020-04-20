import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_pending_runs_ids.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/pending_runs_ids/pending_runs_ids_state.dart';
import 'package:meta/meta.dart';

class PendingRunsIdsBloc
    extends Bloc<PendingRunsIdsEvent, PendingRunsIdsState> {
  static const String _ERROR_MSG = 'Failed to retrieve pending runs ids';
  final GetPendingRunsIds getPendingRunsIds;

  PendingRunsIdsBloc({@required this.getPendingRunsIds});

  @override
  PendingRunsIdsState get initialState => PendingRunsIdsUninitialized();

  @override
  Stream<PendingRunsIdsState> mapEventToState(
      PendingRunsIdsEvent event) async* {
    if (event is PendingRunsRequested) {
      print('CUSTOMER RUNS REQUESTED');
      final failureOrPendingRunsIds = await getPendingRunsIds(NoParams());
      yield* _eitherLoadedOrFailureState(failureOrPendingRunsIds);
    }
  }

  Stream<PendingRunsIdsState> _eitherLoadedOrFailureState(
    Either<Failure, List<String>> failureOrPendingRunsIds,
  ) async* {
    yield failureOrPendingRunsIds.fold(
      (failure) => PendingRunsIdsLoadFailure(message: _ERROR_MSG),
      (pendingRunsIds) =>
          PendingRunsIdsLoadSuccess(pendingRunsIds: pendingRunsIds),
    );
  }
}
