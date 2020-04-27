import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/navigation_auth/domain/repositories/navigation_auth_repository.dart';
import 'package:meta/meta.dart';

class NavigationAuthRepository implements INavigationAuthRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  const NavigationAuthRepository({
    @required this.firebaseAuth,
    @required this.googleSignIn,
  });

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final currentUser = await firebaseAuth.currentUser();
      return Right(currentUser != null && currentUser.isEmailVerified);
    } catch (e) {
      print(e); // Log exceptions
      return Left(FirebaseAuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return Right(Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]));
  }

  @override
  Future<Either<Failure, String>> getUser() async {
    final user = await firebaseAuth.currentUser();
    if(user == null || user.isEmailVerified == false) {
      return Right(null);
    }
    else {
      return Right(user.email);
    }
  }
}
