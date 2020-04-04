import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/validators/validators.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_event.dart';
import 'package:hotfoot/features/registration/presentation/bloc/registration_state.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:mockito/mockito.dart';

import '../../domain/use_cases/sign_up_test.dart';

class MockSignUp extends Mock implements SignUp {}

class MockValidators extends Mock implements Validators {}

class MockAuthResult extends Mock implements AuthResult {}

class MockUserResult extends Mock implements UserModel {}

void main() {
  RegistrationBloc bloc;
  MockSignUp mockSignUp;
  MockValidators mockValidators;

  setUp(() {
    mockSignUp = MockSignUp();
    mockValidators = MockValidators();
    bloc = RegistrationBloc(
      signUp: mockSignUp,
      validators: mockValidators,
    );
  });

  final String tValidPassword = 'valid_password';
  final String tInvalidPassword = 'invalid_password';
  final tInvalidEmail = 'invalid@email.com';
  final tValidEmail = 'valid@email.com';
  final tAuthResult = MockAuthResult();
  final tMockUserResult = MockUserModel();

  test('should have initial state of [RegistrationState.empty()]', () async {
    // assert
    expect(bloc.initialState, equals(RegistrationState.empty()));
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
        RegistrationState.empty(),
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
        RegistrationState.empty(),
        RegistrationState.empty().update(isEmailValid: false),
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
        RegistrationState.empty(),
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
        RegistrationState.empty(),
        RegistrationState.empty().update(isPasswordValid: false),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(PasswordChanged(password: tInvalidPassword));
    });
  });

  group('Submitted', () {
    test('should yield [RegistrationState.success()] if sign up was successful',
        () async {
      // arrange
      when(mockSignUp(any)).thenAnswer((_) async => Right(tMockUserResult));

      // assert later
      final expectedStates = [
        RegistrationState.empty(),
        RegistrationState.loading(),
        RegistrationState.success(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(Submitted(email: tValidEmail, password: tValidPassword));
    });

    test('should yield [RegistrationState.failure()] if sign up failed',
        () async {
      // arrange
      when(mockSignUp(any))
          .thenAnswer((_) async => Left(FirebaseAuthFailure()));

      // assert later
      final expectedStates = [
        RegistrationState.empty(),
        RegistrationState.loading(),
        RegistrationState.failure(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(Submitted(email: tValidEmail, password: tValidPassword));
    });
  });
}
