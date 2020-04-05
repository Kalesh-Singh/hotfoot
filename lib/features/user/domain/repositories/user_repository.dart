import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserModel>> getUser();

  Future<Either<Failure, void>> addUser({@required UserModel userModel});

  Future<Either<Failure, List<String>>> getPastOrderIds();

  Future<Either<Failure, List<String>>> getPastOrderAddresses();
}