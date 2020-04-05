import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/registration/domain/use_cases/sign_up.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthResult extends Mock implements AuthResult {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockUserModel extends Mock implements UserModel {}

class MockRegistrationRepository extends Mock
    implements IRegistrationRepository {}

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  MockUserRepository mockUserRepository;
  SignUp useCase;
  MockRegistrationRepository mockRegistrationRepository;
  RegistrationRepository repository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserRepository = MockUserRepository();
    repository = RegistrationRepository(
      firebaseAuth: mockFirebaseAuth,
      userRepository: mockUserRepository,
    );
    mockRegistrationRepository = MockRegistrationRepository();
    useCase = SignUp(registrationRepository: mockRegistrationRepository);
  });

  final String tEmail = 'email';
  final String tPassword = 'password';

  group('Sign Up', () {
    test('Should return UserModel upon sign in with registration repository',
        () async {
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
      verify(mockRegistrationRepository.signUp(
        email: tEmail,
        password: tPassword,
      ));
      verifyNoMoreInteractions(mockRegistrationRepository);
      expect(result, Right(tUserModelResult));
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
