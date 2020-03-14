import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/data/repositories/navigation_auth_repository_impl.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/sign_out.dart';
import 'package:mockito/mockito.dart';

class MockNavigationAuthRepository extends Mock
    implements NavigationAuthRepository {}

void main() {
  MockNavigationAuthRepository mockNavigationAuthRepository;
  SignOut useCase;

  setUp(() {
    mockNavigationAuthRepository = MockNavigationAuthRepository();
    useCase = SignOut(navigationAuthRepository: mockNavigationAuthRepository);
  });

  test('should call NavigationAuthRepository.signOut()', () async {
    // arrange
    when(mockNavigationAuthRepository.signOut())
        .thenAnswer((_) async => Right(null));
    // Returns Future<void> on success, so the value of null really
    // doesn't matter since it can't be used anyways.

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, Right(null));
    verify(mockNavigationAuthRepository.signOut());
    verifyNoMoreInteractions(mockNavigationAuthRepository);
  });
}
