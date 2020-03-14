import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_event.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_state.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final SignUp signUp;
  final Validators validators;

  RegistrationBloc({
    @required this.signUp,
    @required this.validators,
  })  : assert(signUp != null),
        assert(validators != null);

  @override
  RegistrationState get initialState => RegistrationState.empty();

  @override
  Stream<RegistrationState> transformEvents(
    Stream<RegistrationEvent> events,
    Stream<RegistrationState> Function(RegistrationEvent event) next,
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
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegistrationState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: validators.isValidEmail(email),
    );
  }

  Stream<RegistrationState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: validators.isValidPassword(password),
    );
  }

  Stream<RegistrationState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegistrationState.loading();

    final signUpEither = await signUp(SignUpParams(
      email: email,
      password: password,
    ));

    yield* signUpEither.fold(
      (failure) async* {
        yield RegistrationState.failure();
      },
      (success) async* {
        yield RegistrationState.success();
      },
    );
  }
}
