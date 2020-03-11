import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:meta/meta.dart';

abstract class IAuthenticationRepository {
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, void>> signInWithCredentials({
    @required String email,
    @required String password,
  });
  Future<Either<Failure, FirebaseUser>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> signUp();
  // Returns null if no user is signed in, else returns the user's email.
  Future<Either<Failure, String>> getUser();
}
