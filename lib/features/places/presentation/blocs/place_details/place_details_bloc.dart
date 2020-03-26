import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_by_id.dart';
import 'package:hotfoot/features/places/domain/use_cases/get_place_photo.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:meta/meta.dart';

class PlaceDetailsBloc extends Bloc<PlaceDetailsEvent, PlaceDetailsState> {
  static const String _PLACE_DETAILS_ERR_MSG =
      'Failed to retrieve place details';
  static const String _PLACE_PHOTO_ERR_MSG = 'Failed to retrieve place photo';
  final GetPlaceById getPlaceById;
  final GetPlacePhoto getPlacePhoto;

  PlaceDetailsBloc({
    @required this.getPlaceById,
    @required this.getPlacePhoto,
  });

  @override
  PlaceDetailsState get initialState => PlaceDetailsUninitialized();

  @override
  Stream<PlaceDetailsState> mapEventToState(PlaceDetailsEvent event) async* {
    if (event is PlaceDetailsRequested) {
      final failureOrPlaceDetails = await getPlaceById(event.placeId);
      yield* _eitherPlaceDetailsLoadedOrFailureState(failureOrPlaceDetails);
    } else if (event is PlacePhotoRequested) {
      final failureOrPlacePhoto = await getPlacePhoto(
        GetPlacePhotoParams(
          id: event.placeEntity.id,
          url: event.placeEntity.photoUrl,
        ),
      );
      yield* _eitherPlacePhotoLoadedOrFailureState(failureOrPlacePhoto);
    }
  }

  Stream<PlaceDetailsState> _eitherPlaceDetailsLoadedOrFailureState(
    Either<Failure, PlaceEntity> failureOrPlaceDetails,
  ) async* {
    yield failureOrPlaceDetails.fold(
      (failure) => PlaceDetailsLoadFailure(message: _PLACE_DETAILS_ERR_MSG),
      (placeEntity) => PlaceDetailsLoadSuccess(placeEntity: placeEntity),
    );
  }

  Stream<PlaceDetailsState> _eitherPlacePhotoLoadedOrFailureState(
      Either<Failure, File> failureOrPlacePhoto) async* {
    yield failureOrPlacePhoto.fold(
      (failure) => PlacePhotoLoadFailure(message: _PLACE_PHOTO_ERR_MSG),
      (placePhoto) => PlacePhotoLoadSuccess(placePhoto: placePhoto),
    );
  }
}
