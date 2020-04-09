import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/location/domain/use_cases/get_current_place.dart';
import 'package:hotfoot/features/location/domain/use_cases/get_place_from_query.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_state.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static const String _CURRENT_PLACE_ERR_MSG =
      'Failed to retrieve current address';
  static const String _QUERIED_PLACE_ERR_MSG =
      'Failed to retrieve queried address';
  final GetCurrentPlace getCurrentPlace;
  final GetPlaceFromQuery getPlaceFromQuery;

  LocationBloc({
    @required this.getCurrentPlace,
    @required this.getPlaceFromQuery,
  });

  @override
  LocationState get initialState => LocationUninitialized();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is CurrentPlaceRequested) {
      final failureOrCurrentPlace = await getCurrentPlace(NoParams());
      yield* _eitherCurrentPlaceOrFailureState(failureOrCurrentPlace);
    } else if (event is PlaceQueried) {
      final failureOrQueriedPlace = await getPlaceFromQuery(event.query);
      yield* _eitherQueriedPlaceOrFailureState(failureOrQueriedPlace);
    }
  }

  Stream<LocationState> _eitherCurrentPlaceOrFailureState(
    Either<Failure, PlaceEntity> failureOrCurrentPlace,
  ) async* {
    yield failureOrCurrentPlace.fold(
      (failure) => CurrentPlaceLoadFailure(message: _CURRENT_PLACE_ERR_MSG),
      (placeEntity) => CurrentPlaceLoadSuccess(placeEntity: placeEntity),
    );
  }

  Stream<LocationState> _eitherQueriedPlaceOrFailureState(
    Either<Failure, PlaceEntity> failureOrQueriedPlace,
  ) async* {
    yield failureOrQueriedPlace.fold(
      (failure) => QueriedPlaceLoadFailure(message: _QUERIED_PLACE_ERR_MSG),
      (placeEntity) => QueriedPlaceLoadSuccess(placeEntity: placeEntity),
    );
  }
}
