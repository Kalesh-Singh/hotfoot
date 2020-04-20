import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_state.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_photo.dart';

class DrawerContentsBloc
    extends Bloc<DrawerContentsEvent, DrawerContentsState> {
  static const String _PHOTO_ERROR_MSG = 'Failed to retrieve place entity';
  static const String _PLACE_DETAILS_ERROR_MSG =
      'Failed to retrieve place entity';
  final GetPlaceById getPlaceById;
  final GetPlacePhoto getPlacePhoto;

  DrawerContentsBloc({@required this.getPlaceById, this.getPlacePhoto});

  @override
  DrawerContentsState get initialState => DrawerContentsUninitialized();

  @override
  Stream<DrawerContentsState> mapEventToState(
      DrawerContentsEvent event) async* {
    if (event is SearchItemSelectedForDrawer) {
      final failureOrPlaceEntity = await getPlaceById(event.placeId);
      if (failureOrPlaceEntity.isRight()) {
        final PlaceEntity placeEntity = failureOrPlaceEntity.getOrElse(null);
        GetPlacePhotoParams photoParams =
        GetPlacePhotoParams(id: placeEntity.id, url: placeEntity.photoUrl);
        final failureOrPlacePhoto = await getPlacePhoto(photoParams);
        if (failureOrPlacePhoto.isRight()) {
          print("Drawer details fully loaded");
          yield DrawerContentsLoaded(
              photo: failureOrPlacePhoto.getOrElse(null),
              placeEntity: placeEntity);
        } else {
          yield DrawerContentsFailure(message: _PHOTO_ERROR_MSG);
        }
      } else {
        yield DrawerContentsFailure(message: _PLACE_DETAILS_ERROR_MSG);
      }
    } else {
      yield DrawerContentsUninitialized();
    }
  }
}
