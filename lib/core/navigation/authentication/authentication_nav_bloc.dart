import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hotfoot/core/navigation/authentication/authentication_nav_event.dart';
import 'package:hotfoot/core/navigation/authentication/authentication_nav_state.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/authentication/domain/use_cases/get_user.dart';
import 'package:hotfoot/features/authentication/domain/use_cases/is_signed_in.dart';
import 'package:hotfoot/features/authentication/domain/use_cases/sign_out.dart';
import 'package:meta/meta.dart';

class AuthenticationNavBloc
    extends Bloc<AuthenticationNavEvent, AuthenticationNavState> {
  final IsSignedIn isSignedIn;
  final GetUser getUser;
  final SignOut signOut;

  AuthenticationNavBloc({
    @required this.isSignedIn,
    @required this.getUser,
    @required this.signOut,
  })  : assert(isSignedIn != null),
        assert(getUser != null),
        assert(signOut != null);

  @override
  AuthenticationNavState get initialState => Uninitialized();

  @override
  Stream<AuthenticationNavState> mapEventToState(
    AuthenticationNavEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationNavState> _mapAppStartedToState() async* {
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
          (name) async* {
            if (name == null) {
              yield Unauthenticated();
            } else {
              yield Authenticated(name);
            }
          },
        );
      },
    );
  }

  Stream<AuthenticationNavState> _mapLoggedInToState() async* {
    final nameEither = await getUser(NoParams());
    yield* nameEither.fold(
      (failure) async* {
        throw UnimplementedError();
      },
      (name) async* {
        yield Authenticated(name);
      },
    );
  }

  Stream<AuthenticationNavState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    signOut(NoParams());
  }
}
