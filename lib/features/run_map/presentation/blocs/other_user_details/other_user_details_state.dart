import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class OtherUserDetailsState extends Equatable {
  const OtherUserDetailsState();

  @override
  List<Object> get props => [];
}

class OtherUserDetailsUninitialized extends OtherUserDetailsState {}

class OtherUserDetailsLoaded extends OtherUserDetailsState {
  final UserModel otherUserModel;

  const OtherUserDetailsLoaded({
    @required this.otherUserModel,
  });

  @override
  List<Object> get props => [
        otherUserModel,
      ];
}

class OtherUserDetailsFailure extends OtherUserDetailsState {
  final String message;

  const OtherUserDetailsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
