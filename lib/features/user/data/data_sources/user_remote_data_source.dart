import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

abstract class IUserRemoteDataSource {
  Future<List<String>> getPastOrderIds();
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Firestore firestore;

  UserRemoteDataSource({
    @required this.firestore,
  })  : assert(firestore != null);

  
  @override
  Future<List<String>> getPastOrderIds({String userId}) async {
    print('Getting order ids from firestore');
    List<String> ordersIds = List<String>();
    List<dynamic> documentOrderIds = List<dynamic>();
    // userId for right now is email
    await firestore.collection("users").document(userId).get().then((val){
      print(val.data['email']);
      documentOrderIds = val.data['pastOrders'];
      documentOrderIds.forEach((element) => ordersIds.add(element));
    });

    print('got past order ids from firestore');
    print('Number of past orders customer has made ${ordersIds.length}');
    return ordersIds;
  }
}
