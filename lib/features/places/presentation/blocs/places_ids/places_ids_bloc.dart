import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_places_ids.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_state.dart';
import 'package:meta/meta.dart';

class PlacesIdsBloc extends Bloc<PlacesIdsEvent, PlacesIdsState> {
  static const String _ERROR_MSG = 'Failed to retrieve places ids';
  final GetPlacesIds getPlacesIds;

  PlacesIdsBloc({@required this.getPlacesIds});

  @override
  PlacesIdsState get initialState => PlacesIdsUninitialized();

  @override
  Stream<PlacesIdsState> mapEventToState(PlacesIdsEvent event) async* {
    if (event is PlacesRequested) {
      final failureOrPlacesIds = await getPlacesIds(NoParams());
      yield* _eitherLoadedOrFailureState(failureOrPlacesIds);
    }
  }

  Stream<PlacesIdsState> _eitherLoadedOrFailureState(
    Either<Failure, List<String>> failureOrPlacesIds,
  ) async* {
    yield failureOrPlacesIds.fold(
      (failure) => PlacesIdsLoadFailure(message: _ERROR_MSG),
      (placesIds) => PlacesIdsLoadSuccess(placesIds: placesIds),
    );
  }
}
