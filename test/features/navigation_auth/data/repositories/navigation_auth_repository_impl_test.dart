import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/navigation_auth/data/repositories/navigation_auth_repository_impl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseUser extends Mock implements FirebaseUser {
  final String email;

  MockFirebaseUser({@required this.email});
}

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  MockGoogleSignIn mockGoogleSignIn;
  NavigationAuthRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    repository = NavigationAuthRepository(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  final String tUserEmail = 'user@email.com';
  final MockFirebaseUser tFirebaseUser = MockFirebaseUser(email: tUserEmail);

  group('Is Signed In', () {
    test('should return FirebaseFailure as now the isEmailVerified parameter should not be null', () async {
      // arrange
      when(mockFirebaseAuth.currentUser())
          .thenAnswer((_) async => tFirebaseUser);

      //act
      final result = await repository.isSignedIn();

      // assert
      verify(mockFirebaseAuth.currentUser());
      expect(result, Left(FirebaseAuthFailure()));
    });

    test('should return false if there is no user signed in', () async {
      // arrange
      when(mockFirebaseAuth.currentUser()).thenAnswer((_) async => null);

      //act
      final result = await repository.isSignedIn();

      // assert
      verify(mockFirebaseAuth.currentUser());
      expect(result, equals(Right(false)));
    });

    test('should return [FirebaseAuthFailure] if an exception is thrown',
        () async {
      // arrange
      when(mockFirebaseAuth.currentUser()).thenThrow(Exception());

      //act
      final result = await repository.isSignedIn();

      // assert
      verify(mockFirebaseAuth.currentUser());
      expect(result, equals(Left(FirebaseAuthFailure())));
    });
  });

  group('Sign Out', () {
    test('should attempt to sign out from both Google and FirebaseAuth',
        () async {
      // arrange
      when(mockFirebaseAuth.signOut())
          .thenAnswer((_) async => Future.value(null));
      when(mockGoogleSignIn.signOut())
          .thenAnswer((_) async => Future.value(null));
      // Both calls return Future<void>, so the value of null really
      // doesn't matter since it can't be used anyways.

      //act
      await repository.signOut();

      // assert
      verify(mockFirebaseAuth.signOut());
      verifyNoMoreInteractions(mockFirebaseAuth);
      verify(mockGoogleSignIn.signOut());
      verifyNoMoreInteractions(mockGoogleSignIn);
    });
  });

  group('Get User', () {
    test('should return user email if there is a signed in user', () async {
      // arrange
      when(mockFirebaseAuth.currentUser())
          .thenAnswer((_) async => tFirebaseUser);

      //act
      final result = await repository.getUser();

      // assert
      verify(mockFirebaseAuth.currentUser());
      verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, Right(tUserEmail));
    });

    test('should return null if no user is signed in', () async {
      // arrange
      when(mockFirebaseAuth.currentUser()).thenAnswer((_) async => null);

      //act
      final result = await repository.getUser();

      // assert
      verify(mockFirebaseAuth.currentUser());
      verifyNoMoreInteractions(mockFirebaseAuth);
      expect(result, Right(null));
    });
  });
}
