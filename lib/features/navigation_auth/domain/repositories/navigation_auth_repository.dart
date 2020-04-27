import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';

abstract class INavigationAuthRepository {
  Future<Either<Failure, bool>> isSignedIn();

  Future<Either<Failure, void>> signOut();

  /// Returns null if no user is signed in or if the email is unverified, else returns the user's email.
  Future<Either<Failure, String>> getUser();
}
