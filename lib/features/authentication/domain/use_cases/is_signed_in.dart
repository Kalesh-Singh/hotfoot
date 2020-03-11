import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

class IsSignedIn implements UseCase<bool, NoParams> {
  final IAuthenticationRepository authenticationRepository;

  const IsSignedIn({@required this.authenticationRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authenticationRepository.isSignedIn();
  }
}