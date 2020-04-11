import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class ToggleUserType implements UseCase<UserType, NoParams> {
  final IUserRepository userRepository;
  const ToggleUserType({@required this.userRepository});

  @override
  Future<Either<Failure, UserType>> call(NoParams params) async {
    return await userRepository.toggleUserType();
  }
}