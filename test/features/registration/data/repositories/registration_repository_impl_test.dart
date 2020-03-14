import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthResult extends Mock implements AuthResult {}

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  RegistrationRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    repository = RegistrationRepository(firebaseAuth: mockFirebaseAuth);
  });

  final String tEmail = 'email';
  final String tPassword = 'password';

  group('Sign Up', () {
    test('should create user with email and password using FirebaseAuth',
        () async {
      // arrange
      final MockAuthResult tAuthResult = MockAuthResult();
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => tAuthResult);

      // act
      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ));
      expect(result, equals(Right(tAuthResult)));
    });

    test('should return [FirebaseAuthFailure] if an exception is thrown',
        () async {
      // arrange
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception());

      //act
      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ));
      expect(result, equals(Left(FirebaseAuthFailure())));
    });
  });
}
