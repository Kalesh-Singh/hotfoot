import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      initializeFirestore(email: email);
      return Right(result);
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }

  // Make a collection with users email
  // Could add other fields in the future
  // Creates a document with email field with a randomly generated key for the name of the document
  // DocumentReference reference = await databaseReference.collection("users").add({'email' : email});
  // print(reference.documentID);
  // Making the document id unique based on email address so it can be retrieved
  Future<Either<Failure, void>> initializeFirestore({
    @required String email,
  }) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference.collection("users").document(email).setData({
        'email': email
        });
        return Right(databaseReference);
    } catch (e) {
      print(e);
      return Left(FirestoreFailure());
    }
  }
}
