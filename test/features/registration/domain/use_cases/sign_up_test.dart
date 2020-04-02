import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:mockito/mockito.dart';

class MockRegistrationRepository extends Mock
    implements IRegistrationRepository {}

class MockAuthResult extends Mock implements AuthResult {}

class MockUserModel extends Mock implements UserModel {}

void main() {
  SignUp useCase;
  MockRegistrationRepository mockRegistrationRepository;

  setUp(() {
    mockRegistrationRepository = MockRegistrationRepository();
    useCase = SignUp(registrationRepository: mockRegistrationRepository);
  });

  final String tEmail = 'email';
  final String tPassword = 'password';

  test('should return Future<UserModel> on registration success', () async {
    // arrange
    final MockUserModel tUserModelResult = MockUserModel();
    when(mockRegistrationRepository.signUp(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Right(tUserModelResult));

    // act
    final result = await useCase(SignUpParams(
      email: tEmail,
      password: tPassword,
    ));

    // assert
    expect(result, Right(tUserModelResult));
    verify(mockRegistrationRepository.signUp(
      email: tEmail,
      password: tPassword,
    ));
    verifyNoMoreInteractions(mockRegistrationRepository);
  });

  test('should return [FirebaseAuthFailure] on failure', () async {
    // arrange
    when(mockRegistrationRepository.signUp(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => Left(FirebaseAuthFailure()));

    // act
    final result = await useCase(SignUpParams(
      email: tEmail,
      password: tPassword,
    ));

    // assert
    expect(result, Left(FirebaseAuthFailure()));
    verify(mockRegistrationRepository.signUp(
      email: tEmail,
      password: tPassword,
    ));
    verifyNoMoreInteractions(mockRegistrationRepository);
  });
}
