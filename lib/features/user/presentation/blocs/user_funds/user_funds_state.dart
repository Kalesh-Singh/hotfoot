import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserFundsState extends Equatable {
  const UserFundsState();

  @override
  List<Object> get props => [];
}

class UserFundsUninitialized extends UserFundsState {}

class UserFundsLoaded extends UserFundsState {
  final double funds;

  const UserFundsLoaded({@required this.funds});

  @override
  List<Object> get props => [funds];
}

class UserFundsFailure extends UserFundsState {
  final String message;

  const UserFundsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
