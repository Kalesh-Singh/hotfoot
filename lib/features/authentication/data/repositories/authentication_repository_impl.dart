import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Future<bool> isSignedIn() async {
    final currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<void> signInWithCredentials(String email, String password) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser();
  }

  @override
  Future<void> signOut() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  @override
  Future<void> signUp({String email, String password}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> getUser() async {
    return (await firebaseAuth.currentUser()).email;
  }
}
