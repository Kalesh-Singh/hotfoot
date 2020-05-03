import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_finalizer/run_finalizer_event.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_finalizer/run_finalizer_state.dart';
import 'package:hotfoot/features/runs/presentation/ui/screens/accept_run_screen.dart';
import 'package:hotfoot/features/user/domain/use_cases/add_user_funds.dart';
import 'package:hotfoot/features/user/domain/use_cases/subtract_user_funds.dart';
import 'package:meta/meta.dart';

class RunFinalizerBloc extends Bloc<RunFinalizerEvent, RunFinalizerState> {
  static const String _ERR_MSG = 'Runner ID is null';
  final AddUserFunds addUserFunds;
  final SubtractUserFunds subtractUserFunds;

  RunFinalizerBloc({
    @required this.addUserFunds,
    @required this.subtractUserFunds,
  });

  @override
  RunFinalizerState get initialState => RunFinalizerUninitialized();

  @override
  Stream<RunFinalizerState> mapEventToState(RunFinalizerEvent event) async* {
    if (event is DeliveryConfirmed) {
      if (event.isRunner) {
        await addUserFunds(calculateRunnerFee(event.cost));
      } else {
        await subtractUserFunds(event.cost);
      }
      yield RunFinalizerFundsUpdated();
    }
  }
}
