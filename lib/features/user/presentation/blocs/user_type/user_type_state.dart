import 'package:equatable/equatable.dart';

abstract class UserTypeState extends Equatable {
  const UserTypeState();

  @override
  List<Object> get props => [];
}

class CustomerUserType extends UserTypeState {}

class RunnerUserType extends UserTypeState {}
