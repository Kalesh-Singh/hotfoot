import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserPhotoEvent extends Equatable {
  const UserPhotoEvent();

  @override
  List<Object> get props => [];
}

class UserPhotoRequested extends UserPhotoEvent {
  final String userId;

  /// Passing null for [userId] gives the current user photo.
  const UserPhotoRequested({@required this.userId});
}
