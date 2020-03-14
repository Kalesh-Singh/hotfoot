import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:meta/meta.dart';

abstract class IRegistrationRepository {
  Future<Either<Failure, void>> signUp({
    @required String email,
    @required String password,
  });
}
