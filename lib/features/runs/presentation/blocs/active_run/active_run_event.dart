import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class ActiveRunEvent extends Equatable {
  final UserType userType;

  const ActiveRunEvent({@required this.userType});

  @override
  List<Object> get props => [];
}

class ActiveRunRequested extends ActiveRunEvent {
  const ActiveRunRequested({@required UserType userType})
      : super(userType: userType);
}
