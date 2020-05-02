import 'dart:io';

import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<UserModel> insertOrUpdateUser({@required UserModel userModel});

  Future<UserModel> getUserInfo();

  Future<void> insertOrUpdateUserPhoto();

  Future<File> getUserPhoto();
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;

  const UserLocalDataSource({
    @required this.userDao,
  }) : assert(userDao != null);

  @override
  Future<UserModel> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }

  @override
  Future<UserModel> getUserInfo() async {
    return await userDao.get();
  }

  @override
  Future<File> getUserPhoto() {
    // TODO: implement getUserPhoto
    return null;
  }

  @override
  Future<void> insertOrUpdateUserPhoto() {
    // TODO: implement insertOrUpdateUserPhoto
    return null;
  }
}
