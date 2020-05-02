import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserPhotoState extends Equatable {
  const UserPhotoState();

  @override
  List<Object> get props => [];
}

class UserPhotoUninitialized extends UserPhotoState {}

class UserPhotoLoadFailure extends UserPhotoState {
  final String message;

  const UserPhotoLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class UserPhotoLoadSuccess extends UserPhotoState {
  final File userPhoto;

  const UserPhotoLoadSuccess({@required this.userPhoto});

  @override
  List<Object> get props => [userPhoto];
}
