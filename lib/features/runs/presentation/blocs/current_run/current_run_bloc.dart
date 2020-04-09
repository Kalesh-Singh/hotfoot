import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/init_run.dart';
import 'package:meta/meta.dart';

import 'current_run_event.dart';
import 'current_run_state.dart';

class CurrentRunBloc extends Bloc<CurrentRunEvent, CurrentRunState> {
  final InitRun initRun;

  CurrentRunBloc({@required this.initRun}) : assert(initRun != null);

  @override
  CurrentRunState get initialState =>
      CurrentRunState(runModel: RunModel.empty());

  @override
  Stream<CurrentRunState> mapEventToState(CurrentRunEvent event) async* {
    if (event is CustomerChanged) {
      yield* _mapCustomerChangedToState();
    } else if (event is OrderChanged) {
      yield* _mapOrderChangedToState(event.order);
    } else if (event is PickupPlaceIdChanged) {
      yield* _mapPickupPlaceIdChangedToState(event.pickupPlaceId);
    } else if (event is DestinationChanged) {
      yield* _mapDestinationChangedToState(event.destinationPlace);
    }
  }

  Stream<CurrentRunState> _mapOrderChangedToState(String order) async* {
    print('ORDER CHANGED');
    final currRun = state.runModel.copyWith(order: order);
    print(json.encode((currRun as RunModel).toJson()));
    yield CurrentRunState(
      runModel: currRun,
    );
  }

  Stream<CurrentRunState> _mapPickupPlaceIdChangedToState(
      String pickupPlaceId) async* {
    final currRun = state.runModel;
    print('PICKUPID CHANGED');
    yield CurrentRunState(
      runModel: currRun.copyWith(
        pickupPlaceIdOrCustomPlace: Left(pickupPlaceId),
      ),
    );
  }

  Stream<CurrentRunState> _mapDestinationChangedToState(
      PlaceEntity destinationPlace) async* {
    final currRun = state.runModel;
    print('DESTINATION CHANGED');
    yield CurrentRunState(
      runModel: currRun.copyWith(
        destinationPlace: destinationPlace,
      ),
    );
  }

  Stream<CurrentRunState> _mapCustomerChangedToState() async* {
    print('CUSTOMER CHANGED');
    final initRunEither = await initRun(NoParams());
    RunModel currRun = state.runModel;
    initRunEither.fold(
      (failure) {},
      (run) {
        currRun = run;
      },
    );
    yield CurrentRunState(runModel: currRun);
  }
}
