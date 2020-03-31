import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<List<String>> getPastOrderIds();
  Future<void> insertOrUpdateUser({@required UserModel userModel});
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;

  const UserLocalDataSource({
    @required this.userDao,
  }) : assert(userDao != null);

  @override
  Future<List<String>> getPastOrderIds() async {
    print('Getting all order ids of the current user');
    List<String> orderIds = await userDao.getPastOrderIds();
    print('Number of orders ${orderIds.length}');
    return orderIds;
  }

  @override
  Future<void> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }
}