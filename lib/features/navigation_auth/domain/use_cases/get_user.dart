import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/navigation_auth/domain/repositories/navigation_auth_repository.dart';
import 'package:meta/meta.dart';

class GetUser implements UseCase<String, NoParams> {
  final INavigationAuthRepository navigationAuthRepository;

  const GetUser({@required this.navigationAuthRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await navigationAuthRepository.getUser();
  }
}
