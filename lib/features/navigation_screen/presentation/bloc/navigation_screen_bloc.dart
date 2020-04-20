import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/init_run.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:meta/meta.dart';

class NavigationScreenBloc
    extends Bloc<NavigationScreenEvent, NavigationScreenState> {
  final InitRun initRun;
  final UpdateOrInsertRun updateOrInsertRun;

  NavigationScreenBloc({
    @required this.initRun,
    @required this.updateOrInsertRun,
  });

  @override
  NavigationScreenState get initialState => Home(runModel: RunModel.empty());

  @override
  Stream<NavigationScreenState> mapEventToState(
    NavigationScreenEvent event,
  ) async* {
    if (event is EnteredLogin) {
      yield Login();
    } else if (event is EnteredHome) {
      yield Home(runModel: RunModel.empty());
    } else if (event is EnteredPurchaseFlow) {
      // TODO: run details is available in EnteredPurchaseFlow event
      // as a PlaceEntity.
      // The pin location screen should also pass place info as a
      // PlaceEntity even though all the fields may not be necessary.
      yield* _mapEnteredPurchaseFlowToState(event.runModel);
    } else if (event is EnteredSettings) {
      yield Settings();
    } else if (event is EnteredRunPlaced) {
      yield* _mapEnteredRunPlacedToState(event.runModel);
    } else if (event is EnteredAcceptRun) {
      yield AcceptRun(runModel: event.runModel);
    } else {
      print(event.runtimeType);
    }
  }

  Stream<NavigationScreenState> _mapEnteredPurchaseFlowToState(
      RunModel currentRun) async* {
    final initRunEither = await initRun(NoParams());
    yield* initRunEither.fold(
      (failure) async* {
        yield Home(runModel: RunModel.empty());
      },
      (run) async* {
        print('Init run');
        yield RunDetails(
          runModel: currentRun.copyWith(
            customerId: run.customerId,
            status: run.status,
          ),
        );
      },
    );
  }

  Stream<NavigationScreenState> _mapEnteredRunPlacedToState(
      RunModel currentRun) async* {
    final updateOrInsertRunEither = await updateOrInsertRun(currentRun);
    yield* updateOrInsertRunEither.fold(
      (failure) async* {
        yield RunDetails(runModel: currentRun);
      },
      (run) async* {
        print('Insert or update run');
        yield RunPlaced(
          runModel: currentRun.copyWith(id: run.id),
        );
      },
    );
  }
}
