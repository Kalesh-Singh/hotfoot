import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class IAuthenticationRepository {
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signInWithCredentials(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<void> signUp({@required String email, @required String password});
}
