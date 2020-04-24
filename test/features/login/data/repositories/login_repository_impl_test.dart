import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/login/data/repositories/login_repository_impl.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockFirebaseUser extends Mock implements FirebaseUser {
  final String email;

  MockFirebaseUser({@required this.email});
}

class MockAuthResult extends Mock implements AuthResult {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  MockGoogleSignIn mockGoogleSignIn;
  LoginRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    repository = LoginRepository(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  final String tEmail = 'email';
  final String tPassword = 'password';
  final AuthResult tAuthResult = MockAuthResult();
  final MockGoogleSignInAccount mockGoogleSignInAccount =
      MockGoogleSignInAccount();
  final MockGoogleSignInAuthentication mockGoogleSignInAuthentication =
      MockGoogleSignInAuthentication();
  final String tAccessToken = 'accessToken';
  final String tIdToken = 'idToken';
  final MockFirebaseUser tFirebaseUser = MockFirebaseUser(email: tEmail);

  group('Sign In With Credentials', () {
    test('should call FirebaseAuth.signInWithEmailAndPassword', () async {
      // arrange

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => tAuthResult);

      // act
      await repository.signInWithCredentials(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ));
    });

    test('should return FirebaseAuthFailure as  user can only sign in now if email is verified', () async {
      // arrang
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => tAuthResult);

      // act
      final result = await repository.signInWithCredentials(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ));
      expect(result, Left(FirebaseAuthFailure()));
    });

    test('should return [FirebaseAuthFailure] if an exception was thrown',
        () async {
      // arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception());

      // act
      final result = await repository.signInWithCredentials(
        email: tEmail,
        password: tPassword,
      );

      // assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ));
      expect(result, Left(FirebaseAuthFailure()));
    });
  });

  group('Sign In With Google', () {
    test('should call GoogleSignIn.signIn()', () async {
      // arrange
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn(tAccessToken);
      when(mockGoogleSignInAuthentication.idToken).thenReturn(tIdToken);
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => tAuthResult);
      when(mockFirebaseAuth.currentUser())
          .thenAnswer((_) async => tFirebaseUser);

      // act
      await repository.signInWithGoogle();

      // assert
      verify(mockGoogleSignIn.signIn());
    });

    test('should return [GoogleSignInFailure] if GoogleSignInAccount is null',
        () async {
      // arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      // act
      final result = await repository.signInWithGoogle();

      // assert
      verify(mockGoogleSignIn.signIn());
      expect(result, Left(GoogleSignInFailure()));
    });

    test('should return [FirebaseAuthFailure] if an exception occurs',
        () async {
      // arrange
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn(tAccessToken);
      when(mockGoogleSignInAuthentication.idToken).thenReturn(tIdToken);
      when(mockFirebaseAuth.signInWithCredential(any)).thenThrow(Exception());

      // act
      final result = await repository.signInWithGoogle();

      // assert
      verify(mockGoogleSignIn.signIn());
      expect(result, Left(FirebaseAuthFailure()));
    });

    test('should return the signed in user if successful', () async {
      // arrange
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn(tAccessToken);
      when(mockGoogleSignInAuthentication.idToken).thenReturn(tIdToken);
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => tAuthResult);
      when(mockFirebaseAuth.currentUser())
          .thenAnswer((_) async => tFirebaseUser);

      // act
      final result = await repository.signInWithGoogle();

      // assert
      verify(mockGoogleSignIn.signIn());
      expect(result, Right(tFirebaseUser));
    });
  });
}
