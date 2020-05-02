import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OtherUserDetailsEvent extends Equatable {
  final String userId;

  const OtherUserDetailsEvent({
    @required this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class OtherUserDetailsRequested extends OtherUserDetailsEvent {
  const OtherUserDetailsRequested({
    @required String userId,
  }) : super(
          userId: userId,
        );
}
