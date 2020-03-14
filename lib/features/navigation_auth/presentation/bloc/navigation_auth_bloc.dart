import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/get_user.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/is_signed_in.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/sign_out.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:meta/meta.dart';

class NavigationAuthBloc
    extends Bloc<NavigationAuthEvent, NavigationAuthState> {
  final IsSignedIn isSignedIn;
  final GetUser getUser;
  final SignOut signOut;

  NavigationAuthBloc({
    @required this.isSignedIn,
    @required this.getUser,
    @required this.signOut,
  })  : assert(isSignedIn != null),
        assert(getUser != null),
        assert(signOut != null);

  @override
  NavigationAuthState get initialState => Uninitialized();

  @override
  Stream<NavigationAuthState> mapEventToState(
    NavigationAuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<NavigationAuthState> _mapAppStartedToState() async* {
    final isSignedInEither = await isSignedIn(NoParams());
    yield* isSignedInEither.fold(
      (failure) async* {
        yield Unauthenticated();
      },
      (success) async* {
        final nameEither = await getUser(NoParams());
        yield* nameEither.fold(
          (failure) async* {
            throw UnimplementedError();
          },
          (email) async* {
            if (email == null) {
              yield Unauthenticated();
            } else {
              yield Authenticated(email);
            }
          },
        );
      },
    );
  }

  Stream<NavigationAuthState> _mapLoggedInToState() async* {
    final nameEither = await getUser(NoParams());
    yield* nameEither.fold(
      (failure) async* {
        throw UnimplementedError();
      },
      (email) async* {
        yield Authenticated(email);
      },
    );
  }

  Stream<NavigationAuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    signOut(NoParams());
  }
}
