import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/get_user.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/is_signed_in.dart';
import 'package:hotfoot/features/navigation_auth/domain/use_cases/sign_out.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_bloc.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_event.dart';
import 'package:hotfoot/features/navigation_auth/presentation/bloc/navigation_auth_state.dart';
import 'package:mockito/mockito.dart';

class MockIsSignedIn extends Mock implements IsSignedIn {}

class MockGetUser extends Mock implements GetUser {}

class MockSignOut extends Mock implements SignOut {}

void main() {
  NavigationAuthBloc bloc;
  MockIsSignedIn mockIsSignedIn;
  MockGetUser mockGetUser;
  MockSignOut mockSignOut;

  setUp(() {
    mockIsSignedIn = MockIsSignedIn();
    mockGetUser = MockGetUser();
    mockSignOut = MockSignOut();

    bloc = NavigationAuthBloc(
      isSignedIn: mockIsSignedIn,
      getUser: mockGetUser,
      signOut: mockSignOut,
    );
  });

  test('should have initial state of [Uninitialized]', () async {
    // assert
    expect(bloc.initialState, equals(Uninitialized()));
  });

  // Group tests based on bloc events

  group('App Started', () {
    test('should yield [Unauthenticated] on failure', () async {
      // arrange
      when(mockIsSignedIn(any))
          .thenAnswer((_) async => Left(FirebaseAuthFailure()));

      // assert later
      final expectedStates = [
        Uninitialized(),
        Unauthenticated(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(AppStarted());
    });

    test('should yield [Unauthenticated] if current user email is null',
        () async {
      // arrange
      when(mockIsSignedIn(any)).thenAnswer((_) async => Right(true));
      when(mockGetUser(any)).thenAnswer((_) async => Right(null));

      // assert later
      final expectedStates = [
        Uninitialized(),
        Unauthenticated(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(AppStarted());
    });

    test(
        "should yield [Authenticated(email)] if current user's email is not null",
        () async {
      // arrange
      final String tUserEmail = 'user@email.com';
      when(mockIsSignedIn(any)).thenAnswer((_) async => Right(true));
      when(mockGetUser(any)).thenAnswer((_) async => Right(tUserEmail));

      // assert later
      final expectedStates = [
        Uninitialized(),
        Authenticated(tUserEmail),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(AppStarted());
    });
  });

  group('Logged In', () {
    test('should yield [Authenticated(email)] if user is logged in', () async {
      // arrange
      final String tUserEmail = 'user@email.com';
      when(mockGetUser(any)).thenAnswer((_) async => Right(tUserEmail));

      // assert later
      final expectedStates = [
        Uninitialized(),
        Authenticated(tUserEmail),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoggedIn());
    });
  });

  group('Logged Out', () {
    test('should sign out the user', () async {
      // arrange
      when(mockSignOut(any)).thenAnswer((_) async => Right(null));
      // The value null doesn't really matter, since Future<void> is returned,
      // and therefore cannot be used anyways.

      // act
      bloc.add(LoggedOut());
      await untilCalled(mockSignOut(any));

      // assert
      verify(mockSignOut(NoParams()));
    });

    test('should yield [Unauthenticated] on log out', () async {
      // arrange
      when(mockSignOut(any)).thenAnswer((_) async => Right(null));
      // The value null doesn't really matter, since Future<void> is returned,
      // and therefore cannot be used anyways.

      // assert later
      final expectedStates = [
        Uninitialized(),
        Unauthenticated(),
      ];

      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expectedStates),
      );

      // act
      bloc.add(LoggedOut());
    });
  });
}
