import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_state.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_photo.dart';

class SearchBottomDrawerBloc
    extends Bloc<SearchBottomDrawerEvent, SearchBottomDrawerState> {
  static const String _PHOTO_ERROR_MSG = 'Failed to retrieve place entity';
  static const String _PLACE_DETAILS_ERROR_MSG =
      'Failed to retrieve place entity';
  final GetPlaceById getPlaceById;
  final GetPlacePhoto getPlacePhoto;

  SearchBottomDrawerBloc({@required this.getPlaceById, this.getPlacePhoto});

  @override
  SearchBottomDrawerState get initialState => SearchBottomDrawerUninitialized();

  @override
  Stream<SearchBottomDrawerState> mapEventToState(
      SearchBottomDrawerEvent event) async* {
    if (event is SearchItemSelectedForDrawer) {
      final failureOrPlaceEntity = await getPlaceById(event.placeId);
      if (failureOrPlaceEntity.isRight()) {
        final PlaceEntity placeEntity = failureOrPlaceEntity.getOrElse(null);
        GetPlacePhotoParams photoParams =
            GetPlacePhotoParams(id: placeEntity.id, url: placeEntity.photoUrl);
        final failureOrPlacePhoto = await getPlacePhoto(photoParams);
        if (failureOrPlacePhoto.isRight()) {
          print("Drawer details fully loaded");
          yield SearchBottomDrawerLoaded(
              photo: failureOrPlacePhoto.getOrElse(null),
              placeEntity: placeEntity);
        } else {
          yield SearchBottomDrawerFailure(message: _PHOTO_ERROR_MSG);
        }
      } else {
        yield SearchBottomDrawerFailure(message: _PLACE_DETAILS_ERROR_MSG);
      }
    } else {
      yield SearchBottomDrawerUninitialized();
    }
  }
}
