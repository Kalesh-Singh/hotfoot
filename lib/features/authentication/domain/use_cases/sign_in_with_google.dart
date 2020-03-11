import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class SignInWithGoogle implements UseCase<FirebaseUser, NoParams> {
  final IAuthenticationRepository authenticationRepository;

  const SignInWithGoogle({@required this.authenticationRepository});

  @override
  Future<Either<Failure, FirebaseUser>> call(NoParams params) async {
    return await authenticationRepository.signInWithGoogle();
  }
}