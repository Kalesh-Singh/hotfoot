import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General Failures
class FirebaseAuthFailure extends Failure {}

class GoogleSignInFailure extends Failure {}
