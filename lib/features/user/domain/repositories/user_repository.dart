import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> initUser();

  Future<Either<Failure, String>> getUserId();

  Future<Either<Failure, UserType>> getUserType();

  Future<Either<Failure, UserType>> toggleUserType();

  Future<Either<Failure, UserEntity>> getUserInfo();

  Future<Either<Failure, UserEntity>> insertOrUpdateUser(
      {@required UserModel userModel});

  Future<Either<Failure, double>> getUserFunds();

  Future<Either<Failure, void>> updateUserFunds({@required double funds});

  Future<Either<Failure, double>> addUserFunds({@required double funds});

  Future<Either<Failure, double>> subtractUserFunds({@required double funds});
}
