import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class SignInWithCredentials
    implements UseCase<void, SignInWithCredentialsParams> {
  final IAuthenticationRepository authenticationRepository;

  const SignInWithCredentials({@required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> call(SignInWithCredentialsParams params) async {
    return await authenticationRepository.signInWithCredentials(
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
