import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/data_access_objects/user_dao.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<List<String>> getPastOrderIds();
  Future<List<String>> getPastOrderAddresses();
  Future<void> insertOrUpdateUser({@required UserModel userModel});
  Future<UserModel> getUser();
  Future<void> updateRunsIds({@required List<String> runsIds});
  Future<List<String>> getRunsIds();
}

class UserLocalDataSource implements IUserLocalDataSource {
  final IUserDao userDao;

  const UserLocalDataSource({
    @required this.userDao,
  }) : assert(userDao != null);

  @override
  Future<List<String>> getPastOrderIds() async {
    print('Getting all order ids of the current user');
    List<String> orderIds = await userDao.getRunsIds();
    print('Number of orders ${orderIds.length}');
    return orderIds;
  }

  @override
  Future<List<String>> getPastOrderAddresses() async {
    print('Getting all past order addresses of the current user');
    List<String> pastOrderAddresses = await userDao.getPastOrderAddresses();
    print('Number of past order addresses ${pastOrderAddresses.length}');
    return pastOrderAddresses;
  }

  @override
  Future<void> insertOrUpdateUser({UserModel userModel}) async {
    return await userDao.insertOrUpdate(userModel: userModel);
  }

  @override
  Future<UserModel> getUser() async {
    return await userDao.getUserInformation();
  }

  @override
  Future<List<String>> getRunsIds() {
    // TODO: implement getRunsIds
    return null;
  }

  @override
  Future<void> updateRunsIds({List<String> runsIds}) {
    // TODO: implement updateRunsIds
    return null;
  }
}