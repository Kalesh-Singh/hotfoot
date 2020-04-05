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
  Future<Either<Failure, UserEntity>> getUserInfo() {
    // TODO: implement getUserInfo
    return null;
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
}
