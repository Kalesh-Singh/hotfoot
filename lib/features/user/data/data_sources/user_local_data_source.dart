import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<void> insertOrUpdateUser({@required UserModel userModel});

  Future<UserModel> getUserInfo();
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;

  const UserLocalDataSource({
    @required this.userDao,
  }) : assert(userDao != null);

  @override
  Future<void> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }

  @override
  Future<UserModel> getUserInfo() async {
    return await userDao.get();
  }
}
