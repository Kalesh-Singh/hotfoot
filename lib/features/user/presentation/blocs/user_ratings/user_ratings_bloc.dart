import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_customer_rating.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_state.dart';
import 'package:meta/meta.dart';

class UserRatingsBloc extends Bloc<UserRatingsEvent, UserRatingsState> {
  static const String _CUSTOMER_ERR_MSG = 'Failed to get customer rating';
  static const String _RUNNER_ERR_MSG = 'Failed to get runner rating';

  final GetCustomerRating getCustomerRating;

  UserRatingsBloc({
    @required this.getCustomerRating,
  });

  @override
  UserRatingsState get initialState => UserRatingsUninitialized();

  @override
  Stream<UserRatingsState> mapEventToState(UserRatingsEvent event) async* {
    if (event is UserRatingsRequested) {
      final failureOrCustomerRating = await getCustomerRating(NoParams());
      yield failureOrCustomerRating.fold(
        (failure) => UserRatingsFailure(message: _CUSTOMER_ERR_MSG),
        (customerRating) => UserRatingsLoaded(customerRating: customerRating),
      );
    }
  }
}
