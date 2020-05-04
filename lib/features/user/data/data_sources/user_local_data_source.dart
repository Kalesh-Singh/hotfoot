import 'dart:io';

import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_photo_dao.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<UserModel> insertOrUpdateUser({@required UserModel userModel});

  Future<UserModel> getUserInfo();

  Future<File> insertOrUpdateUserPhoto({
    @required String userId,
    @required File userPhotoFile,
  });

  Future<File> getUserPhoto([String userId]);
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;
  final IUserPhotoDao userPhotoDao;
  final IUserRemoteDataSource userRemoteDataSource;

  const UserLocalDataSource({
    @required this.userDao,
    @required this.userPhotoDao,
    @required this.userRemoteDataSource,
  })  : assert(userDao != null),
        assert(userPhotoDao != null),
        assert(userRemoteDataSource != null);

  @override
  Future<UserModel> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }

  @override
  Future<UserModel> getUserInfo() async {
    return await userDao.get();
  }

  @override
  Future<File> getUserPhoto([String userId]) async {
    final String id = userId ?? (await userRemoteDataSource.getUserId());
    return await userPhotoDao.get(id: id);
  }

  @override
  Future<File> insertOrUpdateUserPhoto({
    String userId,
    File userPhotoFile,
  }) async {
    final String id = userId ?? (await userDao.get()).id;
    return await userPhotoDao.insertOrUpdate(
      id: id,
      photoFile: userPhotoFile,
    );
  }
}
