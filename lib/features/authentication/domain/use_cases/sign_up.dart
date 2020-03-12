import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class SignUp implements UseCase<void, SignUpParams> {
  final IAuthenticationRepository authenticationRepository;

  const SignUp({@required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return await authenticationRepository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({
    @required this.email,
    @required this.password,
  });
}
