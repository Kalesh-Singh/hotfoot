import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:hotfoot/features/user/data/data_sources/user_local_data_source.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:hotfoot/core/network/network_info.dart';

class UserRepository implements IUserRepository {
  final INetworkInfo networkInfo;
  final IUserLocalDataSource userLocalDataSource;
  final IUserRemoteDataSource userRemoteDataSource;

  UserRepository({
    @required this.networkInfo,
    @required this.userRemoteDataSource,
    @required this.userLocalDataSource,
  })  : assert(networkInfo != null),
        assert(userLocalDataSource != null),
        assert(userRemoteDataSource != null);

  Future<Either<Failure, String>> getUserId() async {
    try {
      final uid = await userRemoteDataSource.getUserId();
      return Right(uid);
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> insertOrUpdateUser(
      {UserModel userModel}) async {
    if (await networkInfo.isConnected) {
      await userRemoteDataSource.insertOrUpdateUser(userModel: userModel);
      await userLocalDataSource.insertOrUpdateUser(userModel: userModel);
      return Right(userModel);
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final UserModel userModel = await userRemoteDataSource.getUserInfo();
        await userLocalDataSource.insertOrUpdateUser(userModel: userModel);
        return Right(userModel);
      } catch (e) {
        print('FIRESTORE FAILURE: $e');
        return Left(FirestoreFailure());
      }
    } else {
      final UserModel userModel = await userLocalDataSource.getUserInfo();
      return Right(userModel);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> initUser() async {
    UserModel userModel;
    try {
      userModel = await userRemoteDataSource.getUserFromFirebase();
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
    final either = await insertOrUpdateUser(userModel: userModel);
    return either.fold(
      (failure) {
        return Left(failure);
      },
      (success) {
        return Right(success);
      },
    );
  }

  @override
  Future<Either<Failure, UserType>> getUserType() async {
    final userModelEither = await getUserInfo();
    return userModelEither.fold(
      (failure) {
        return Left(failure);
      },
      (userModel) {
        return Right(userModel.type);
      },
    );
  }

  @override
  Future<Either<Failure, UserType>> toggleUserType() async {
    final userModelEither = await getUserInfo();
    return userModelEither.fold(
      (failure) {
        print('FAILED TO GET USER INFO');
        return Left(failure);
      },
      (userModel) async {
        final currUserType = userModel.type;
        final newUserType = (currUserType == UserType.CUSTOMER)
            ? UserType.RUNNER
            : UserType.CUSTOMER;
        UserModel newUserModel =
            (userModel as UserModel).copyWith(type: newUserType);
        final updateEither = await insertOrUpdateUser(userModel: newUserModel);
        return updateEither.fold(
          (failure) {
            print('FAILED TO UPDATE USER MODEL');
            return Left(failure);
          },
          (userModel) {
            return Right(userModel.type);
          },
        );
      },
    );
  }

  Future<Either<Failure, UserEntity>> getUserInfoById({String userId}) async {
    try {
      final UserModel userModel =
          await userRemoteDataSource.getUserInfoById(userId: userId);
      return Right(userModel);
    } catch (e) {
      print('FIRESTORE FAILURE: $e');
      return Left(FirestoreFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getUserFunds() async {
    final userModelEither = await getUserInfo();
    return userModelEither.fold(
      (failure) {
        return Left(failure);
      },
      (userModel) {
        return userModel.funds != null ? Right(userModel.funds) : Right(0.0);
      },
    );
  }

  @override
  Future<Either<Failure, void>> updateUserFunds({double funds}) async {
    final userModelEither = await getUserInfo();
    return userModelEither.fold(
      (failure) {
        return Left(failure);
      },
      (userModel) async {
        UserModel newUserModel =
            (userModel as UserModel).copyWith(funds: funds);
        final result = await insertOrUpdateUser(userModel: newUserModel);
        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, double>> addUserFunds({double funds}) async {
    final userFundsEither = await getUserFunds();
    return userFundsEither.fold(
      (failure) {
        return Left(failure);
      },
      (userFunds) async {
        final newFunds = userFunds + funds;
        final updateFundsEither = await updateUserFunds(funds: newFunds);
        return updateFundsEither.fold((failure) {
          return Left(failure);
        }, (_) {
          return Right(newFunds);
        });
      },
    );
  }

  @override
  Future<Either<Failure, double>> subtractUserFunds({double funds}) async {
    final userFundsEither = await getUserFunds();
    return userFundsEither.fold(
      (failure) {
        return Left(failure);
      },
      (userFunds) async {
        final newFunds = userFunds - funds;
        final updateFundsEither = await updateUserFunds(funds: newFunds);
        return updateFundsEither.fold((failure) {
          return Left(failure);
        }, (_) {
          return Right(newFunds);
        });
      },
    );
  }
}
