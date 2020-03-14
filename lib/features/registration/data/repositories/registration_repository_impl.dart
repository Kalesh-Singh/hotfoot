import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:meta/meta.dart';

class RegistrationRepository implements IRegistrationRepository {
  final FirebaseAuth firebaseAuth;

  const RegistrationRepository({
    @required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, void>> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }
}
