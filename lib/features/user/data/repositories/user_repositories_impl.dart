import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:hotfoot/features/user/data/data_sources/user_local_data_source.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:hotfoot/core/network/network_info.dart';

class UserRepository implements IUserRepository {
  final FirebaseAuth firebaseAuth;
  final INetworkInfo networkInfo;
  final IUserLocalDataSource userLocalDataSource;
  final IUserRemoteDataSource userRemoteDataSource;

  UserRepository({
    @required this.firebaseAuth,
    @required this.networkInfo,
    @required this.userRemoteDataSource,
    @required this.userLocalDataSource,
  })  : assert(firebaseAuth != null),
        assert(networkInfo != null),
        assert(userLocalDataSource != null),
        assert(userRemoteDataSource != null);

  Future<Either<Failure, String>> getUserId() async {
      try {
        final user = await firebaseAuth.currentUser();
        final userId = user.uid;
        return Right(userId);
      } catch (e) {
        print(e);
        return Left(FirebaseAuthFailure());
      }
  }

  @override
  Future<Either<Failure, void>> insertOrUpdateUser({UserModel userModel}) async {
    if (await networkInfo.isConnected) {
      await userRemoteDataSource.insertOrUpdateUser(userModel: userModel);
      await userLocalDataSource.insertOrUpdateUser(userModel: userModel);
      return Right(Future.value());
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() {
    // TODO: implement getUserInfo
    return null;
  }
}
