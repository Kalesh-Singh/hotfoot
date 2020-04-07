import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_credentials.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_google.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_event.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_state.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/repositories/runs_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'current_run_event.dart';
import 'current_run_state.dart';

class CurrentRunBloc extends Bloc<CurrentRunEvent, CurrentRunState> {
  final IRunsRepository runRepository;

  CurrentRunBloc({@required this.runRepository});

  @override
  CurrentRunState get initialState =>
      CurrentRunState(runModel: RunModel.empty());

  @override
  Stream<CurrentRunState> mapEventToState(CurrentRunEvent event) async* {
    if (event is OrderChanged) {
      yield* _mapOrderChangedToState(event.order);
    } else if (event is PickupPlaceIdChanged) {
      yield* _mapPickupPlaceIdChangedToState(event.pickupPlaceId);
    } else if (event is DestinationChanged) {
      yield* _mapDestinationChangedToState(event.destinationPlace);
    }
  }

  Stream<CurrentRunState> _mapOrderChangedToState(String order) async* {
    final currRun = state.runModel;
    yield CurrentRunState(
      runModel: currRun.copyWith(
        order: order,
      ),
    );
  }

  Stream<CurrentRunState> _mapPickupPlaceIdChangedToState(
      String pickupPlaceId) async* {
    final currRun = state.runModel;
    yield CurrentRunState(
      runModel: currRun.copyWith(
        pickupPlaceIdOrCustomPlace: Left(pickupPlaceId),
      ),
    );
  }

  Stream<CurrentRunState> _mapDestinationChangedToState(
      PlaceEntity destinationPlace) async* {
    final currRun = state.runModel;
    yield CurrentRunState(
      runModel: currRun.copyWith(
        destinationPlace: destinationPlace,
      ),
    );
  }
}
