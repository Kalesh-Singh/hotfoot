import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:hotfoot/features/login/domain/use_cases/sign_in_with_credentials.dart';
import 'package:mockito/mockito.dart';

class MockLoginRepository extends Mock implements ILoginRepository {}

class MockAuthResult extends Mock implements AuthResult {}

void main() {
  SignInWithCredentials useCase;
  MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    useCase = SignInWithCredentials(loginRepository: mockLoginRepository);
  });

  final String tEmail = 'email';
  final String tPassword = 'password';

  test('should return Future<void> on sign in success', () async {
    // arrange
    final MockAuthResult tAuthResult = MockAuthResult();
    when(mockLoginRepository.signInWithCredentials(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(tAuthResult));

    // act
    final result = await useCase(SignInWithCredentialsParams(
      email: tEmail,
      password: tPassword,
    ));

    // assert
    expect(result, Right(tAuthResult));
    verify(mockLoginRepository.signInWithCredentials(
      email: tEmail,
      password: tPassword,
    ));
    verifyNoMoreInteractions(mockLoginRepository);
  });

  test('should return [FirebaseAuthFailure] on failure', () async {
    // arrange
    when(mockLoginRepository.signInWithCredentials(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Left(FirebaseAuthFailure()));

    // act
    final result = await useCase(SignInWithCredentialsParams(
      email: tEmail,
      password: tPassword,
    ));

    // assert
    expect(result, Left(FirebaseAuthFailure()));
    verify(mockLoginRepository.signInWithCredentials(
      email: tEmail,
      password: tPassword,
    ));
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
