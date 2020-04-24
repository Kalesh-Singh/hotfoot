import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:meta/meta.dart';

class LoginRepository implements ILoginRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  const LoginRepository({
    @required this.firebaseAuth,
    @required this.googleSignIn,
  })  : assert(firebaseAuth != null),
        assert(googleSignIn != null);

  @override
  Future<Either<Failure, void>> signInWithCredentials({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final FirebaseUser user = result.user;
      if (user.isEmailVerified) {
        return Right(result);
      }
      return Left(FirebaseAuthEmailUnverifiedFailure());
    } catch (e) {
      print(e);
      if(e is PlatformException) {
        if(e.code == 'ERROR_INVALID_EMAIL') {
          return Left(FirebaseAuthEmailAlreadyInUseFailure());
        }
      }
      return Left(FirebaseAuthFailure());
    }
  }

  // Not needed
  @override
  Future<Either<Failure, FirebaseUser>> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return Left(GoogleSignInFailure());
    }
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      return Right(await firebaseAuth.currentUser());
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }
}
