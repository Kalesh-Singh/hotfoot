import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_info.dart';
import 'package:hotfoot/features/user/domain/use_cases/insert_or_update_user.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_state.dart';
import 'package:meta/meta.dart';

class UserFundsBloc extends Bloc<UserFundsEvent, UserFundsState> {
  static const String _FUNDS_ERR_MSG = 'Failed to fetch User funds';
  static const String _UPDATE_ERR_MSG = 'Failed to update User funds';
  final GetUserInfo getUserInfo;
  final InsertOrUpdateUser insertOrUpdateUser;

  UserFundsBloc({
    @required this.getUserInfo,
    @required this.insertOrUpdateUser,
  });

  @override
  UserFundsState get initialState => UserFundsUninitialized();

  @override
  Stream<UserFundsState> mapEventToState(UserFundsEvent event) async* {
    if (event is UserFundsRequested || event is UserFundsAdded) {
      final failureOrUserInfo = await getUserInfo(NoParams());
      yield await failureOrUserInfo.fold(
        (failure) => UserFundsFailure(message: _FUNDS_ERR_MSG),
        (userEntity) async {
          double funds = (userEntity.funds) ?? 0.0;
          if (event is UserFundsAdded) {
            funds += event.addedFunds;
            UserModel newUserModel =
                (userEntity as UserModel).copyWith(funds: funds);
            final failureOrUpdatedFunds =
                await insertOrUpdateUser(newUserModel);
            failureOrUpdatedFunds.fold(
              (failure) => UserFundsFailure(message: _UPDATE_ERR_MSG),
              (_) {},
            );
          }
          return UserFundsLoaded(funds: funds);
        },
      );
    }
  }
}
