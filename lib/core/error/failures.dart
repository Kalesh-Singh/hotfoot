import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General Failures
class FirebaseAuthFailure extends Failure {}
class FirebaseAuthEmailAlreadyInUseFailure extends Failure {}

class GoogleSignInFailure extends Failure {}

class DatabaseFailure extends Failure {}

class FirestoreFailure extends Failure {}

class FirebaseStorageFailure extends Failure {}

class NetworkFailure extends Failure {}
