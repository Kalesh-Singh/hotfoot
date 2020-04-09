import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_state.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/init_run.dart';
import 'package:meta/meta.dart';

class NavigationScreenBloc
    extends Bloc<NavigationScreenEvent, NavigationScreenState> {
  final InitRun initRun;

  NavigationScreenBloc({@required this.initRun});

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
      yield RunPlaced();
    }
  }

  Stream<NavigationScreenState> _mapEnteredPurchaseFlowToState(
      RunModel currentRun) async* {
    final initRunEither = await initRun(NoParams());
    initRunEither.fold(
      (failure) {},
      (run) {
        currentRun = run;
      },
    );
    yield RunDetails(runModel: currentRun);
  }
}
