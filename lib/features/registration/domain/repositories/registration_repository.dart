import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class IRegistrationRepository {
  Future<Either<Failure, UserModel>> signUp({
    @required String email,
    @required String password,
  });
}
