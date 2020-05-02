import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_photo.dart';
import 'package:hotfoot/features/user/domain/use_cases/insert_or_update_user_photo.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_state.dart';
import 'package:meta/meta.dart';

class UserPhotoBloc extends Bloc<UserPhotoEvent, UserPhotoState> {
  static const String _USER_PHOTO_LOAD_ERR_MSG =
      'Failed to retrieve user photo';
  static const String _USER_PHOTO_UPDATE_ERR_MSG =
      'Failed to update user photo';

  final GetUserPhoto getUserPhoto;
  final InsertOrUpdateUserPhoto insertOrUpdateUserPhoto;

  UserPhotoBloc({
    @required this.getUserPhoto,
    @required this.insertOrUpdateUserPhoto,
  })  : assert(getUserPhoto != null),
        assert(insertOrUpdateUserPhoto != null);

  @override
  UserPhotoState get initialState => UserPhotoUninitialized();

  @override
  Stream<UserPhotoState> mapEventToState(UserPhotoEvent event) async* {
    if (event is UserPhotoRequested) {
      final failureOrUserPhoto = await getUserPhoto(event.userId);
      yield* _eitherUserPhotoLoadedOrFailureState(failureOrUserPhoto);
    } else if (event is UserPhotoUpdated) {
      final failureOrPhotoUpdated =
          await insertOrUpdateUserPhoto(event.userPhoto);
      yield* _eitherUserPhotoUpdatedOrFailureState(failureOrPhotoUpdated);
    }
  }

  Stream<UserPhotoState> _eitherUserPhotoLoadedOrFailureState(
      Either<Failure, File> failureOrUserPhoto) async* {
    yield failureOrUserPhoto.fold(
      (failure) => UserPhotoLoadFailure(message: _USER_PHOTO_LOAD_ERR_MSG),
      (userPhoto) => UserPhotoLoadSuccess(userPhoto: userPhoto),
    );
  }

  Stream<UserPhotoState> _eitherUserPhotoUpdatedOrFailureState(
      Either<Failure, File> failureOrPhotoUpdated) async* {
    yield failureOrPhotoUpdated.fold(
      (failure) => UserPhotoUpdateFailure(message: _USER_PHOTO_UPDATE_ERR_MSG),
      (userPhoto) => UserPhotoUpdateSuccess(userPhoto: userPhoto),
    );
  }
}
