import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUser implements UseCase<String, NoParams> {
  final IUserRepository userRepository;
  const GetUser({@required this.userRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await userRepository.getUser();
  }
}