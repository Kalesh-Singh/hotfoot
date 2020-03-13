import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/data/repositories/navigation_auth_repository_impl.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/get_user.dart';
import 'package:mockito/mockito.dart';

class MockNavigationAuthRepository extends Mock
    implements NavigationAuthRepository {}

void main() {
  MockNavigationAuthRepository mockNavigationAuthRepository;
  GetUser useCase;

  setUp(() {
    mockNavigationAuthRepository = MockNavigationAuthRepository();
    useCase = GetUser(navigationAuthRepository: mockNavigationAuthRepository);
  });

  final String tUserEmail = 'user@email.com';

  test('should return user email on success', () async {
    // arrange
    when(mockNavigationAuthRepository.getUser())
        .thenAnswer((_) async => Right(tUserEmail));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(tUserEmail));
    verify(mockNavigationAuthRepository.getUser());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });

  test('should return null if there is no current user', () async {
    // arrange
    when(mockNavigationAuthRepository.getUser())
        .thenAnswer((_) async => Right(null));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(null));
    verify(mockNavigationAuthRepository.getUser());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });
}
