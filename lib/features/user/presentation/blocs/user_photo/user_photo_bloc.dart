import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_photo.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_photo/user_photo_state.dart';
import 'package:meta/meta.dart';

class UserPhotoBloc extends Bloc<UserPhotoEvent, UserPhotoState> {
  static const String _USER_PHOTO_ERR_MSG = 'Failed to retrieve user photo';
  final GetUserPhoto getUserPhoto;

  UserPhotoBloc({
    @required this.getUserPhoto,
  });

  @override
  UserPhotoState get initialState => UserPhotoUninitialized();

  @override
  Stream<UserPhotoState> mapEventToState(UserPhotoEvent event) async* {
    if (event is UserPhotoRequested) {
      final failureOrUserPhoto = await getUserPhoto(NoParams());
      yield* _eitherUserPhotoLoadedOrFailureState(failureOrUserPhoto);
    }
  }

  Stream<UserPhotoState> _eitherUserPhotoLoadedOrFailureState(
      Either<Failure, File> failureOrUserPhoto) async* {
    yield failureOrUserPhoto.fold(
      (failure) => UserPhotoLoadFailure(message: _USER_PHOTO_ERR_MSG),
      (userPhoto) => UserPhotoLoadSuccess(userPhoto: userPhoto),
    );
  }
}
