import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/use_cases/add_user_funds.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_funds.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_state.dart';
import 'package:meta/meta.dart';

class UserFundsBloc extends Bloc<UserFundsEvent, UserFundsState> {
  static const String _FUNDS_ERR_MSG = 'Failed to fetch User funds';
  static const String _UPDATE_ERR_MSG = 'Failed to update User funds';
  final GetUserFunds getUserFunds;
  final AddUserFunds addUserFunds;

  UserFundsBloc({
    @required this.getUserFunds,
    @required this.addUserFunds,
  });

  @override
  UserFundsState get initialState => UserFundsUninitialized();

  @override
  Stream<UserFundsState> mapEventToState(UserFundsEvent event) async* {
    if (event is UserFundsRequested) {
      final failureOrUserFunds = await getUserFunds(NoParams());
      yield failureOrUserFunds.fold(
        (failure) => UserFundsFailure(message: _FUNDS_ERR_MSG),
        (funds) => UserFundsLoaded(funds: funds),
      );
    } else if (event is UserFundsAdded) {
      final failureOrFundsUpdated = await addUserFunds(event.addedFunds);
      yield failureOrFundsUpdated.fold(
        (failure) => UserFundsFailure(message: _UPDATE_ERR_MSG),
        (funds) => UserFundsLoaded(funds: funds),
      );
    }
  }
}
