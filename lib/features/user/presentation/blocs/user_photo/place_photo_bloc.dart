import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_photo.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_state.dart';
import 'package:meta/meta.dart';

class PlacePhotoBloc extends Bloc<PlacePhotoEvent, PlacePhotoState> {
  static const String _PLACE_PHOTO_ERR_MSG = 'Failed to retrieve place photo';
  final GetPlacePhoto getPlacePhoto;

  PlacePhotoBloc({
    @required this.getPlacePhoto,
  });

  @override
  PlacePhotoState get initialState => PlacePhotoUninitialized();

  @override
  Stream<PlacePhotoState> mapEventToState(PlacePhotoEvent event) async* {
    if (event is PlacePhotoRequested) {
      final failureOrPlacePhoto = await getPlacePhoto(
        GetPlacePhotoParams(
          id: event.placeEntity.id,
          url: event.placeEntity.photoUrl,
        ),
      );
      yield* _eitherPlacePhotoLoadedOrFailureState(failureOrPlacePhoto);
    }
  }

  Stream<PlacePhotoState> _eitherPlacePhotoLoadedOrFailureState(
      Either<Failure, File> failureOrPlacePhoto) async* {
    yield failureOrPlacePhoto.fold(
      (failure) => PlacePhotoLoadFailure(message: _PLACE_PHOTO_ERR_MSG),
      (placePhoto) => PlacePhotoLoadSuccess(placePhoto: placePhoto),
    );
  }
}
