import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:meta/meta.dart';

class SignInWithGoogle implements UseCase<FirebaseUser, NoParams> {
  final ILoginRepository loginRepository;

  const SignInWithGoogle({@required this.loginRepository});

  @override
  Future<Either<Failure, FirebaseUser>> call(NoParams params) async {
    return await loginRepository.signInWithGoogle();
  }
}
