import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_state.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';

class SearchMapBloc extends Bloc<SearchMapEvent, SearchMapState> {
  static const String _ERROR_MSG = 'Failed to retrieve place entity';
  final GetPlaceById getPlaceById;

  SearchMapBloc({@required this.getPlaceById});

  @override
  SearchMapState get initialState => SearchMapStateUninitialized();

  @override
  Stream<SearchMapState> mapEventToState(SearchMapEvent event) async* {
    if (event is SearchItemSelected) {
      final failureOrPlaceEntity = await getPlaceById(event.placeId);
      yield* _eitherFailureOrPlaceEntity(failureOrPlaceEntity);
    } else {
      yield SearchMapStateUninitialized();
    }
  }

  Stream<SearchMapState> _eitherFailureOrPlaceEntity(
    Either<Failure, PlaceEntity> eitherFailureOrPlaceEntity,
  ) async* {
    yield eitherFailureOrPlaceEntity.fold(
      (failure) => SearchMapStateFailure(message: _ERROR_MSG),
      (placeEntity) =>
          SearchMapStateLoaded(locationEntity: placeEntity.locationEntity),
    );
  }
}
