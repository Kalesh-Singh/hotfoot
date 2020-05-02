import 'package:equatable/equatable.dart';

abstract class UserRatingsEvent extends Equatable {
  const UserRatingsEvent();

  @override
  List<Object> get props => [];
}

class UserRatingsRequested extends UserRatingsEvent {}
