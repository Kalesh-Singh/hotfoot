import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hotfoot/features/authentication/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/authentication/presentation/bloc/register/register_event.dart';
import 'package:hotfoot/features/authentication/presentation/bloc/register/register_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hotfoot/src/utils/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUp signUp;

  RegisterBloc({@required this.signUp}) : assert(signUp != null);

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
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
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();

    final signUpEither = await signUp(SignUpParams(
      email: email,
      password: password,
    ));

    yield* signUpEither.fold(
      (failure) async* {
        yield RegisterState.failure();
      },
      (success) async* {
        yield RegisterState.success();
      },
    );
  }
}
