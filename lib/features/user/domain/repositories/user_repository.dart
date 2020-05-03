import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
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

  Future<Either<Failure, UserEntity>> getUserInfoById(
      {@required String userId});

  Future<Either<Failure, double>> getUserFunds();

  Future<Either<Failure, void>> updateUserFunds({@required double funds});

  Future<Either<Failure, double>> addUserFunds({@required double funds});

  Future<Either<Failure, double>> subtractUserFunds({@required double funds});

  Future<Either<Failure, File>> insertOrUpdateUserPhoto(
      {@required File userPhotoFile});

  /// If no [userId] is provided gets the photo of the
  /// currently signed in user. Else gets the photo
  /// for the provided [userId].
  Future<Either<Failure, File>> getUserPhoto([String userId]);

  Future<Either<Failure, RatingsEntity>> getUserRatings();

  Future<Either<Failure, void>> addCustomerRating(
      {@required String userId, @required double rating});

  Future<Either<Failure, void>> addRunnerRating(
      {@required String userId, @required double rating});
}
