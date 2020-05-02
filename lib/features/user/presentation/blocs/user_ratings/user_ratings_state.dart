import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserRatingsState extends Equatable {
  const UserRatingsState();

  @override
  List<Object> get props => [];
}

class UserRatingsUninitialized extends UserRatingsState {}

class UserRatingsLoaded extends UserRatingsState {
  final double customerRating;
  final double runnerRating;

  const UserRatingsLoaded(
      {@required this.customerRating, @required this.runnerRating});

  @override
  List<Object> get props => [customerRating, runnerRating];
}

class UserRatingsFailure extends UserRatingsState {
  final String message;

  const UserRatingsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
