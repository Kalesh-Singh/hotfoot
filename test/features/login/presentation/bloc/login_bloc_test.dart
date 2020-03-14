import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_credentials.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_google.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_bloc.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_event.dart';
import 'package:hotfoot/features/login/presentation/bloc/login_state.dart';
import 'package:mockito/mockito.dart';

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignInWithCredentials extends Mock implements SignInWithCredentials {}

class MockValidators extends Mock implements Validators {}

class MockAuthResult extends Mock implements AuthResult {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

void main() {
  LoginBloc bloc;
  MockSignInWithGoogle mockSignInWithGoogle;
  MockSignInWithCredentials mockSignInWithCredentials;
  MockValidators mockValidators;

  setUp(() {
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockSignInWithCredentials = MockSignInWithCredentials();
    mockValidators = MockValidators();

    bloc = LoginBloc(
      signInWithGoogle: mockSignInWithGoogle,
      signInWithCredentials: mockSignInWithCredentials,
      validators: mockValidators,
    );
  });

  final String tValidPassword = 'valid_password';
  final String tInvalidPassword = 'invalid_password';
  final tInvalidEmail = 'invalid@email.com';
  final tValidEmail = 'valid@email.com';
  final tAuthResult = MockAuthResult();
  final tFirebaseUser = MockFirebaseUser();

  test('should have initial state of [LoginState.empty()]', () async {
    // assert
    expect(bloc.initialState, equals(LoginState.empty()));
  });

// Group tests based on the bloc events
  group('Email Changed', () {
    test('''should call [validators.isValidEmail] when an email change occurs
        to check if the new email is valid''', () async {
      // arrange
      when(mockValidators.isValidEmail(any)).thenReturn(true);

      // act
      bloc.add(EmailChanged(email: tValidEmail));
      await untilCalled(mockValidators.isValidEmail(tValidEmail));

      // assert
      verify(mockValidators.isValidEmail(tValidEmail));
    });

    test('''should set [isEmailValid] to true if email changed from an invalid
    to a valid email''', () async {
      // arrange
      bloc.state.update(isEmailValid: false);
      when(mockValidators.isValidEmail(any)).thenReturn(true);

      // assert later

      // The initial state isEmailValid == true, the bloc will not yield
      // states that are equivalent (so as to reduce improve efficiency).
      final expectedStates = [
        LoginState.empty(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(EmailChanged(email: tValidEmail));
    });

    test('''should set [isEmailValid] to false if email changed from a valid
    to an invalid email''', () async {
      // arrange
      bloc.state.update(
        isEmailValid: true,
      ); // Although the initial state is already true
      when(mockValidators.isValidEmail(any)).thenReturn(false);

      // assert later

      // The initial state isEmailValid == true, the bloc will not yield
      // states that are equivalent (so as to reduce improve efficiency).
      final expectedStates = [
        LoginState.empty(),
        LoginState.empty().update(isEmailValid: false),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(EmailChanged(email: tInvalidEmail));
    });
  });

  group('Password Changed', () {
    test('''should call [validators.isValidPassword] when a password change 
    occurs to check if the new password is valid''', () async {
      // arrange
      when(mockValidators.isValidPassword(any)).thenReturn(true);

      // act
      bloc.add(EmailChanged(email: tValidPassword));
      await untilCalled(mockValidators.isValidEmail(tValidPassword));

      // assert
      verify(mockValidators.isValidEmail(tValidPassword));
    });

    test('''should set [isPasswordValid] to true if password changed from an 
    invalid to a valid password''', () async {
      // arrange
      bloc.state.update(isPasswordValid: false);
      when(mockValidators.isValidPassword(any)).thenReturn(true);

      // assert later

      // The initial state isPasswordValid == true, the bloc will not yield
      // states that are equivalent (so as to reduce improve efficiency).
      final expectedStates = [
        LoginState.empty(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(PasswordChanged(password: tValidPassword));
    });

    test('''should set [isPasswordValid] to false if password changed from a 
    valid to an invalid password''', () async {
      // arrange
      bloc.state.update(isPasswordValid: true);
      when(mockValidators.isValidPassword(any)).thenReturn(false);

      // assert later

      // The initial state isPasswordValid == true, the bloc will not yield
      // states that are equivalent (so as to reduce improve efficiency).
      final expectedStates = [
        LoginState.empty(),
        LoginState.empty().update(isPasswordValid: false),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(PasswordChanged(password: tInvalidPassword));
    });
  });

  group('Log In With Credentials Pressed', () {
    test('''should yield [LoginState.success()] if sign in with credentials was 
    successful''', () async {
      // arrange
      when(mockSignInWithCredentials(any))
          .thenAnswer((_) async => Right(tAuthResult));

      // assert later
      final expectedStates = [
        LoginState.empty(),
        LoginState.success(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoginWithCredentialsPressed(
        email: tValidEmail,
        password: tValidPassword,
      ));
    });

    test('''should yield [LoginState.failure()] if sign in with credentials was 
    not successful''', () async {
      // arrange
      when(mockSignInWithCredentials(any))
          .thenAnswer((_) async => Left(FirebaseAuthFailure()));

      // assert later
      final expectedStates = [
        LoginState.empty(),
        LoginState.failure(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoginWithCredentialsPressed(
        email: tValidEmail,
        password: tValidPassword,
      ));
    });
  });

  group('Log In With Google Pressed', () {
    test('''should yield [LoginState.success()] if sign in with Google was 
    successful''', () async {
      // arrange
      when(mockSignInWithGoogle(any))
          .thenAnswer((_) async => Right(tFirebaseUser));

      // assert later
      final expectedStates = [
        LoginState.empty(),
        LoginState.success(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoginWithGooglePressed());
    });

    test('''should yield [LoginState.failure()] if sign in with Google was
    not successful''', () async {
      // arrange
      when(mockSignInWithGoogle(any))
          .thenAnswer((_) async => Left(FirebaseAuthFailure()));

      // assert later
      final expectedStates = [
        LoginState.empty(),
        LoginState.failure(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoginWithGooglePressed());
    });
  });
}
