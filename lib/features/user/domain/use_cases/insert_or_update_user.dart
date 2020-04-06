import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class InsertOrUpdateUser implements UseCase<UserEntity, UserModel> {
  final IUserRepository userRepository;

  const InsertOrUpdateUser({@required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(UserModel params) async {
    return await userRepository.insertOrUpdateUser(userModel: params);
  }
}
