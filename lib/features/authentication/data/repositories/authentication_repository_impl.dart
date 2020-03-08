import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  const AuthenticationRepository({
    @required this.firebaseAuth,
    @required this.googleSignIn,
  });

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final currentUser = await firebaseAuth.currentUser();
      return Right(currentUser != null);
    } catch (e) {
      print(e); // Log exceptions
      return Left(FirebaseAuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signInWithCredentials({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }

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

  @override
  Future<void> signOut() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

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

  // Returns null if no user is signed in, else returns the user's email.
  @override
  Future<String> getUser() async {
    return (await firebaseAuth.currentUser())?.email;
  }
}
