import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class UserPhotoEvent extends Equatable {
  const UserPhotoEvent();

  @override
  List<Object> get props => [];
}

class UserPhotoRequested extends UserPhotoEvent {
  final UserEntity userEntity;

  const UserPhotoRequested({@required this.userEntity});
}
