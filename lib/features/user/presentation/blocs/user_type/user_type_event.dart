import 'package:equatable/equatable.dart';

abstract class UserTypeEvent extends Equatable {
  const UserTypeEvent();

  @override
  List<Object> get props => [];
}

class UserTypeToggled extends UserTypeEvent {}

class UserTypeRequested extends UserTypeEvent {}

