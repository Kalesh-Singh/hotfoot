import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:meta/meta.dart';

abstract class ILoginRepository {
  Future<Either<Failure, void>> signInWithCredentials({
    @required String email,
    @required String password,
  });

  Future<Either<Failure, FirebaseUser>> signInWithGoogle();
}
