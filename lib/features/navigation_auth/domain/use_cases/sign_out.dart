import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/domain/repositories/navigation_auth_repository.dart';
import 'package:meta/meta.dart';

class SignOut implements UseCase<void, NoParams> {
  final INavigationAuthRepository navigationAuthRepository;

  const SignOut({@required this.navigationAuthRepository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await navigationAuthRepository.signOut();
  }
}
