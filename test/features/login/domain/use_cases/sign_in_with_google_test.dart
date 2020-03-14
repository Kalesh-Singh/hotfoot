import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_google.dart';
import 'package:mockito/mockito.dart';

class MockLoginRepository extends Mock implements ILoginRepository {}

class MockAuthResult extends Mock implements AuthResult {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

void main() {
  SignInWithGoogle useCase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    useCase = SignInWithGoogle(loginRepository: mockLoginRepository);
  });

  final String tEmail = 'email';
  final String tPassword = 'password';

  test('should return Future<FirebaseUser> on sign in success', () async {
    // arrange
    final MockFirebaseUser tFirebaseUser = MockFirebaseUser();
    when(mockLoginRepository.signInWithGoogle())
        .thenAnswer((_) async => Right(tFirebaseUser));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(tFirebaseUser));
    verify(mockLoginRepository.signInWithGoogle());
    verifyNoMoreInteractions(mockLoginRepository);
  });

  test('should return [FirebaseAuthFailure] on failure', () async {
    // arrange
    when(mockLoginRepository.signInWithGoogle())
        .thenAnswer((_) async => Left(FirebaseAuthFailure()));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Left(FirebaseAuthFailure()));
    verify(mockLoginRepository.signInWithGoogle());
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
