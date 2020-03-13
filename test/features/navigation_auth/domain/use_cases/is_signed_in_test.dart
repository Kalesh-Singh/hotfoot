import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/data/repositories/navigation_auth_repository_impl.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/is_signed_in.dart';
import 'package:mockito/mockito.dart';

class MockNavigationAuthRepository extends Mock
    implements NavigationAuthRepository {}

void main() {
  MockNavigationAuthRepository mockNavigationAuthRepository;
  IsSignedIn useCase;

  setUp(() {
    mockNavigationAuthRepository = MockNavigationAuthRepository();
    useCase =
        IsSignedIn(navigationAuthRepository: mockNavigationAuthRepository);
  });

  test('should return true if there is a signed in user', () async {
    // arrange
    when(mockNavigationAuthRepository.isSignedIn())
        .thenAnswer((_) async => Right(true));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(true));
    verify(mockNavigationAuthRepository.isSignedIn());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });

  test('should return false if no user is signed in', () async {
    // arrange
    when(mockNavigationAuthRepository.isSignedIn())
        .thenAnswer((_) async => Right(false));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(false));
    verify(mockNavigationAuthRepository.isSignedIn());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });

  test('should return [FirebaseAuthFailure] on failure', () async {
    // arrange
    when(mockNavigationAuthRepository.isSignedIn())
        .thenAnswer((_) async => Left(FirebaseAuthFailure()));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Left(FirebaseAuthFailure()));
    verify(mockNavigationAuthRepository.isSignedIn());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });
}
