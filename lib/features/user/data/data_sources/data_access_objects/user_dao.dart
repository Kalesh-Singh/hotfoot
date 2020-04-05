import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:sembast/sembast.dart';

abstract class IUserDao {
  Future<void> insert({@required UserModel userModel});
  Future<void> update({@required UserModel userModel});
  Future<void> delete({@required String id});
  Future<List<String>> getRunsIds();
  Future<void> updateRunsIds();
  Future<List<String>> getPastOrderAddresses();
  Future<void> addOrderId({@required String orderId});
  Future<void> addAddress({@required String address});
  Future<int> deleteAll();
  Future<UserModel> getUserInformation();
  Future<void> insertOrUpdate({UserModel userModel});
}

class UserDao implements IUserDao {
  final Database database;
  static const String _USER_STORE_NAME = 'users';
  final _userStore = stringMapStoreFactory.store(_USER_STORE_NAME);

  UserDao({@required this.database});

  @override
  Future<void> insert({@required UserModel userModel}) async {
    return await _userStore
      .record(userModel.id)
      .put(database, userModel.toJson());
  }

  @override
  Future<void> update({@required UserModel userModel}) async {
    final finder = Finder(filter: Filter.byKey(userModel.id));
    return await _userStore.update(
      database,
      userModel.toJson(),
      finder: finder,
    );
  }

  @override
  Future<void> delete({@required String id}) async {
    return await _userStore.record(id).delete(database);
  }

  // If you have a more optimal way of doing this please update this code
  // Not sure exactly how I can access the specific list field we need to update
  // Instead of fetching the entire user model object
  // Get the user info, add the new address and update the usermodel
  @override
  Future<void> addOrderId({@required String orderId}) async {
    final recordSnapshots = await _userStore.find(database);
    if (recordSnapshots.length == 0) {
      return null;
    }
    final record = recordSnapshots[0];
    final userInfo = UserModel.fromJson(record.value);
    userInfo.pastOrderIds.add(orderId);
    update(userModel: userInfo);
  }
  // Get the user info, add the new address and update the usermodel
  @override
  Future<void> addAddress({@required String address}) async {
    final recordSnapshots = await _userStore.find(database);
    if (recordSnapshots.length == 0) {
      return null;
    }
    final record = recordSnapshots[0];
    final userInfo = UserModel.fromJson(record.value);
    userInfo.pastOrderAddresses.add(address);
    update(userModel: userInfo);
  }

  @override
  Future<UserModel> getUserInformation() async {
    final recordSnapshots = await _userStore.find(database);
    if (recordSnapshots.length == 0) {
      return null;
    }
    final record = recordSnapshots[0];
    return UserModel.fromJson(record.value);
  }

  @override
  Future<List<String>> getRunsIds() async {
    final result = await getUserInformation();
    return result.pastOrderIds;
  }

  @override
  Future<List<String>> getPastOrderAddresses() async {
    final result = await getUserInformation();
    return result.pastOrderAddresses;
  }

  @override
  Future<int> deleteAll() async {
    return await _userStore.delete(database);
  }

  @override
  Future<void> insertOrUpdate({UserModel userModel}) async {
    final finder = Finder(filter: Filter.byKey(userModel.id));
    final key = await _userStore.findKey(
      database,
      finder: finder,
    );
    if (key != null) {
      await update(userModel: userModel);
    } else {
      await insert(userModel: userModel);
    }
  }

  @override
  Future<void> updateRunsIds() {
    // TODO: implement updateRunsIds
    return null;
  }
}