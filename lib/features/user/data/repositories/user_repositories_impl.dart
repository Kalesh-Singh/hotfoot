import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
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

  Future<Either<Failure, String>> getUser() async {
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
  Future<Either<Failure, List<String>>> getPastOrderIds() async {
    if (await networkInfo.isConnected) {
      try {
        print('getting customers previous order ids');
        final pastOrdersIds = await userRemoteDataSource.getPastOrderIds();
        print('got past orders from remote data source');
        print('number of past orders ${pastOrdersIds.length}');
        return Right(pastOrdersIds);
      } catch (e) {
        print('Exception $e');
        return Left(FirestoreFailure());
      }
    } else {
      // Get data from local data source
      print('getting past orders from local datasource');
      final orderIds = await userLocalDataSource.getPastOrderIds();
      print('Number of past orders ${orderIds.length}');
      if (orderIds.length == 0) {
        return Left(DatabaseFailure());
      }
      print('Got order ids from local data source');
      return Right(orderIds);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getPastOrderAddresses() async {
    if (await networkInfo.isConnected) {
      try {
        print('getting customers order addresses');
        final pastOrderAddresses =
            await userRemoteDataSource.getPastOrderAddresses();
        print('got past order addresses from remote data source');
        print('number of past order addresses ${pastOrderAddresses.length}');
        return Right(pastOrderAddresses);
      } catch (e) {
        print('Exception $e');
        return Left(FirestoreFailure());
      }
    } else {
      // Get data from local data source
      print('getting past order addresses from local datasource');
      final pastOrderAddresses =
          await userLocalDataSource.getPastOrderAddresses();
      print('Number of past order addresses ${pastOrderAddresses.length}');
      if (pastOrderAddresses.length == 0) {
        return Left(DatabaseFailure());
      }
      print('Got order ids from local data source');
      return Right(pastOrderAddresses);
    }
  }

  @override
  Future<Either<Failure, void>> addUser({UserModel userModel}) async {
    if (await networkInfo.isConnected) {
      await userRemoteDataSource.insertOrUpdateUser(userModel: userModel);
      await userLocalDataSource.insertOrUpdateUser(userModel: userModel);
      return Right(Future.value());
    } else {
      return Left(NetworkFailure());
    }
  }
}
