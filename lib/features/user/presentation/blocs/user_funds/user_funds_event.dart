import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserFundsEvent extends Equatable {
  const UserFundsEvent();

  @override
  List<Object> get props => [];
}

class UserFundsRequested extends UserFundsEvent {}

class UserFundsAdded extends UserFundsEvent {
  final double addedFunds;

  const UserFundsAdded({@required this.addedFunds});
}
