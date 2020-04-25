import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/use_cases/init_user.dart';
import 'package:meta/meta.dart';

class RegistrationRepository implements IRegistrationRepository {
  final FirebaseAuth firebaseAuth;
  final InitUser initUser;

  const RegistrationRepository({
    @required this.firebaseAuth,
    @required this.initUser,
  })  : assert(firebaseAuth != null),
        assert(initUser != null);

  @override
  Future<Either<Failure, UserModel>> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final _firebaseUser = result.user;
      if (_firebaseUser == null) {
        print("firebase user is null");
      }
      // Send verification email here
      else {
        await _firebaseUser.sendEmailVerification();
      }
      final either = await initUser(NoParams());
      return either.fold(
        (failure) {
          return Left(failure);
        },
        (success) {
          return Right(success);
        },
      );
    } catch (e) {
      if(e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return Left(FirebaseAuthEmailAlreadyInUseFailure());
        }
      }
      return Left(FirebaseAuthFailure());
    }
  }
}
