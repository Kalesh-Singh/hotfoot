import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_credentials.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_event.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInWithCredentials signInWithCredentials;
  final Validators validators;

  LoginBloc({
    @required this.signInWithCredentials,
    @required this.validators,
  })  : assert(signInWithCredentials != null),
        assert(validators != null);

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    final resultEither = await signInWithCredentials(
      SignInWithCredentialsParams(
        email: email,
        password: password,
      ),
    );
    yield* resultEither.fold(
      (failure) async* {
        if (failure is FirebaseAuthInvalidEmailFailure) {
          yield LoginState.failure("Email is not registered");
        } else if (failure is FirebaseAuthEmailUnverifiedFailure) {
          yield LoginState.failure("Please click the verification link sent to your email");
        } else if (failure is FirebaseAuthFailure) {
          print("Regular failure");
          yield LoginState.failure('');
        }
      },
      (success) async* {
        yield LoginState.success();
      },
    );
  }
}
