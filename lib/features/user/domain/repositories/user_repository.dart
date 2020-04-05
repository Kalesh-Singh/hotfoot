import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class IUserRepository {
  Future<Either<Failure, String>> getUserId();

  Future<Either<Failure, UserEntity>> getUserInfo();

  Future<Either<Failure, void>> insertOrUpdateUser({@required UserModel userModel});
}