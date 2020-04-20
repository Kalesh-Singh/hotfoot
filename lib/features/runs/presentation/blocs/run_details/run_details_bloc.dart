import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_by_id.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/run_details/run_details_state.dart';
import 'package:meta/meta.dart';

class RunDetailsBloc extends Bloc<RunDetailsEvent, RunDetailsState> {
  static const String _RUN_DETAILS_ERR_MSG =
      'Failed to retrieve run details';
  final GetRunById getRunById;

  RunDetailsBloc({
    @required this.getRunById,
  });

  @override
  RunDetailsState get initialState => RunDetailsUninitialized();

  @override
  Stream<RunDetailsState> mapEventToState(RunDetailsEvent event) async* {
    if (event is RunDetailsRequested) {
      final failureOrRunDetails = await getRunById(event.runId);
      yield* _eitherRunDetailsLoadedOrFailureState(failureOrRunDetails);
    }
  }

  Stream<RunDetailsState> _eitherRunDetailsLoadedOrFailureState(
    Either<Failure, RunEntity> failureOrRunDetails,
  ) async* {
    yield failureOrRunDetails.fold(
      (failure) => RunDetailsLoadFailure(message: _RUN_DETAILS_ERR_MSG),
      (runEntity) => RunDetailsLoadSuccess(runEntity: runEntity),
    );
  }
}
