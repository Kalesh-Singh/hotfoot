import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';

class SignUp implements UseCase<void, SignUpParams> {
  final IRegistrationRepository registrationRepository;

  const SignUp({@required this.registrationRepository});

  @override
  Future<Either<Failure, UserModel>> call(SignUpParams params) async {
    return await registrationRepository.signUp(
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
