import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_state.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_id.dart';
import 'package:meta/meta.dart';

class AcceptRunBloc extends Bloc<AcceptRunEvent, AcceptRunState> {
  static const String _USER_ID_ERR_MSG = 'Failed to get runner id';
  static const String _UPDATE_ERR_MSG = 'Failed to update the run status';
  final GetUserId getUserId;
  final UpdateOrInsertRun updateOrInsertRun;

  AcceptRunBloc({
    @required this.getUserId,
    @required this.updateOrInsertRun,
  });

  @override
  AcceptRunState get initialState => AcceptRunUninitialized();

  @override
  Stream<AcceptRunState> mapEventToState(AcceptRunEvent event) async* {
    if (event is AcceptRunButtonPressed) {
      final failureOrUid = await getUserId(NoParams());
      yield* failureOrUid.fold(
        (failure) async* {
          yield AcceptRunFailure(message: _USER_ID_ERR_MSG);
        },
        (runnerId) async* {
          print("Runner id = $runnerId");
          print("Accepted Run id = ${event.runModel.id}");
          final failureOrAcceptRunSuccess = await updateOrInsertRun(
              event.runModel.copyWith(runnerId: runnerId, status: "Accepted"));
            if (failureOrAcceptRunSuccess.isRight()) {
              yield AcceptRunSuccess();
            } else {
              yield AcceptRunFailure(message: _UPDATE_ERR_MSG);
            }
        },
      );
    }
  }
}
