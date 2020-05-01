import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_event.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_state.dart';
import 'package:hotfoot/features/user/domain/use_cases/get_user_info_by_id.dart';
import 'package:meta/meta.dart';

class OtherUserDetailsBloc
    extends Bloc<OtherUserDetailsEvent, OtherUserDetailsState> {
  static const String _ERR_MSG = 'Failed to retrieve other user details';
  final GetUserInfoById getUserInfoById;

  OtherUserDetailsBloc({
    @required this.getUserInfoById,
  });

  @override
  OtherUserDetailsState get initialState => OtherUserDetailsUninitialized();

  @override
  Stream<OtherUserDetailsState> mapEventToState(
      OtherUserDetailsEvent event) async* {
    if (event is OtherUserDetailsRequested) {
      if (event.userId == null) {
        yield OtherUserDetailsFailure(message: _ERR_MSG);
      } else {
        final failureOrOtherUserDetails = await getUserInfoById(event.userId);
        yield failureOrOtherUserDetails.fold(
          (failure) => OtherUserDetailsFailure(message: _ERR_MSG),
          (otherUserModel) =>
              OtherUserDetailsLoaded(otherUserModel: otherUserModel),
        );
      }
    }
  }
}
