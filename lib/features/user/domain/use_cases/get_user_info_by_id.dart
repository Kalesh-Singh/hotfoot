import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUserInfoById implements UseCase<UserEntity, String> {
  final IUserRepository userRepository;

  const GetUserInfoById({@required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await userRepository.getUserInfoById(userId: userId);
  }
}
