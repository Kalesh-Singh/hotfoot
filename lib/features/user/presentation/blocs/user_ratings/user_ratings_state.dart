import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
import 'package:meta/meta.dart';

abstract class UserRatingsState extends Equatable {
  const UserRatingsState();

  @override
  List<Object> get props => [];
}

class UserRatingsUninitialized extends UserRatingsState {}

class UserRatingsLoaded extends UserRatingsState {
  final RatingsEntity ratings;

  const UserRatingsLoaded({@required this.ratings});

  @override
  List<Object> get props => [ratings];
}

class UserRatingsFailure extends UserRatingsState {
  final String message;

  const UserRatingsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
