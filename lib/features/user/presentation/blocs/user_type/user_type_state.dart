import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserTypeState extends Equatable {
  const UserTypeState();

  @override
  List<Object> get props => [];
}

class CustomerUserType extends UserTypeState {}

class RunnerUserType extends UserTypeState {}

class UserTypeToggleFailure extends UserTypeState {
  final String message;

  const UserTypeToggleFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class UserTypeLoadFailure extends UserTypeState {
  final String message;

  const UserTypeLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class UserTypeLoading extends UserTypeState {}
