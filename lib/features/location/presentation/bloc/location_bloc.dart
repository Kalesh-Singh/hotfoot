import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/use_cases/get_current_place.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_state.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static const String _CURRENT_PLACE_ERR_MSG =
      'Failed to retrieve place details';
  final GetCurrentPlace getCurrentPlace;

  LocationBloc({
    @required this.getCurrentPlace,
  });

  @override
  LocationState get initialState => CurrentPlaceUninitialized();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is CurrentPlaceRequested) {
      final failureOrPlaceDetails = await getCurrentPlace();
      yield* _eitherPlaceDetailsLoadedOrFailureState(failureOrPlaceDetails);
    }
  }

  Stream<LocationState> _eitherPlaceDetailsLoadedOrFailureState(
      Either<Failure, PlaceEntity> failureOrPlaceDetails,
      ) async* {
    yield failureOrPlaceDetails.fold(
          (failure) => CurrentPlaceLoadFailure(message: _CURRENT_PLACE_ERR_MSG),
          (placeEntity) => CurrentPlaceLoadSuccess(placeEntity: placeEntity),
    );
  }
}
