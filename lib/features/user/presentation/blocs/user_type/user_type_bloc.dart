import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/use_cases/toggle_user_type.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:meta/meta.dart';

class UserTypeBloc extends Bloc<UserTypeEvent, UserTypeState> {
  static const String _USER_TYPE_ERR_MSG = 'Failed to get user type';

  final ToggleUserType toggleUserType;

  UserTypeBloc({
    @required this.toggleUserType,
  });

  @override
  UserTypeState get initialState => CustomerUserType();

  @override
  Stream<UserTypeState> mapEventToState(UserTypeEvent event) async* {
    if (event is UserTypeToggled) {
      final failureOrUserType = await toggleUserType(NoParams());
      yield* _eitherUserTypeToggledOrFailureState(failureOrUserType);
    }
  }

  Stream<UserTypeState> _eitherUserTypeToggledOrFailureState(
    Either<Failure, UserType> failureOrUserType,
  ) async* {
    yield failureOrUserType.fold(
      (failure) => UserTypeToggleFailure(message: _USER_TYPE_ERR_MSG),
      (userType) =>
          userType == UserType.CUSTOMER ? CustomerUserType() : RunnerUserType(),
    );
  }
}
