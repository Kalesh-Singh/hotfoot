import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/login/domain/repositories/login_repository.dart';
import 'package:meta/meta.dart';

class SignInWithCredentials
    implements UseCase<void, SignInWithCredentialsParams> {
  final ILoginRepository loginRepository;

  const SignInWithCredentials({@required this.loginRepository});

  @override
  Future<Either<Failure, void>> call(SignInWithCredentialsParams params) async {
    return await loginRepository.signInWithCredentials(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInWithCredentialsParams {
  final String email;
  final String password;

  const SignInWithCredentialsParams({
    @required this.email,
    @required this.password,
  });
}
