import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUserInfo implements UseCase<UserEntity, NoParams> {
  final IUserRepository userRepository;

  const GetUserInfo({@required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await userRepository.getUserInfo();
  }
}