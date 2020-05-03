import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_ratings.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_state.dart';
import 'package:meta/meta.dart';

class UserRatingsBloc extends Bloc<UserRatingsEvent, UserRatingsState> {
  static const String _ERR_MSG = 'Failed to get user ratings';

  final GetUserRatings getUserRatings;

  UserRatingsBloc({
    @required this.getUserRatings,
  });

  @override
  UserRatingsState get initialState => UserRatingsUninitialized();

  @override
  Stream<UserRatingsState> mapEventToState(UserRatingsEvent event) async* {
    if (event is UserRatingsRequested) {
      final failureOrUserRatings = await getUserRatings(NoParams());
      yield failureOrUserRatings.fold(
        (failure) => UserRatingsFailure(message: _ERR_MSG),
        (ratings) => UserRatingsLoaded(ratings: ratings),
      );
    }
  }
}
