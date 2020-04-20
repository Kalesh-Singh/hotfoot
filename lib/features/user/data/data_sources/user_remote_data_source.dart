import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:meta/meta.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> getUserFromFirebase();

  Future<String> getUserId();

  Future<UserModel> getUserInfo();

  Future<UserModel> insertOrUpdateUser({@required UserModel userModel});
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Firestore firestore;
  final FirebaseAuth firebaseAuth;

  UserRemoteDataSource({
    @required this.firestore,
    @required this.firebaseAuth,
  })  : assert(firestore != null),
        assert(firebaseAuth != null);

  @override
  Future<UserModel> getUserFromFirebase() async {
    // ! kattenlaf =>
    // Right now we will keep name as email,
    // if user wants to change their username we can implement that functionality
    // Or I can parse the email to get the names but like I said its not safe because
    // Howard sometimes makes emails weird with numbers or abbreviations etc

    final firebaseUser = await firebaseAuth.currentUser();
    UserModel userModel = UserModel(
      email: firebaseUser.email,
      id: firebaseUser.uid,
      name: firebaseUser.email,
      // Initialize the user to be a customer
      type: UserType.CUSTOMER,
    );
    return userModel;
  }

  @override
  Future<UserModel> getUserInfo() async {
    final user = await (firebaseAuth.currentUser());
    final userId = user.uid;
    print('USER ID: $userId');
    final userData =
        await (firestore.collection('users').document(userId).get());
    final userJson = userData.data;
    print('Pulled user info: ${json.encode(userJson)}');
    return UserModel.fromJson(userJson);
  }

  @override
  Future<UserModel> insertOrUpdateUser({UserModel userModel}) async {
    final user = await (firebaseAuth.currentUser());
    final userId = user.uid;
    await firestore
        .collection('users')
        .document(userId)
        .setData(userModel.toJson());
    return userModel;
  }

  @override
  Future<String> getUserId() async {
    return (await firebaseAuth.currentUser()).uid;
  }
}
