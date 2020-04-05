import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:meta/meta.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> initializeFirestore(
      {@required String email, @required FirebaseUser firebaseUser});

  Future<UserModel> getUserInfo();

  Future<void> insertOrUpdateUser({@required UserModel userModel});
}

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Firestore firestore;
  final FirebaseAuth firebaseAuth;

  UserRemoteDataSource({
    @required this.firestore,
    @required this.firebaseAuth,
  })  : assert(firestore != null),
        assert(firebaseAuth != null);

  // Make a collection with users email
  // Could add other fields in the future
  // Creates a document with email field with a randomly generated key for the name of the document
  // DocumentReference reference = await databaseReference.collection("users").add({'email' : email});
  // print(reference.documentID);
  // Making the document id unique based on email address so it can be retrieved
  @override
  Future<UserModel> initializeFirestore(
      {@required String email, @required FirebaseUser firebaseUser}) async {
    print("Setting data in firestore");
    await firestore.collection("users").document(firebaseUser.uid).setData({
      'id': firebaseUser.uid,
      'email': email,
      // ! kattenlaf =>
      // Right now we will keep name as email,
      // if user wants to change their username we can implement that functionality
      // Or I can parse the email to get the names but like I said its not safe because
      // Howard sometimes makes emails weird with numbers or abbreviations etc
      'name': email,
      'pastOrderIds': {},
      'pastOrderAddresses': []
    });
    UserModel userModel = UserModel(
      email: email,
      id: firebaseUser.uid,
      name: email,
    );
    return userModel;
  }

  @override
  Future<UserModel> getUserInfo() async {
    final user = await (firebaseAuth.currentUser());
    final userId = user.uid;
    final userData =
        await (firestore.collection('users').document(userId).get());
    final userJson = userData.data;
    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> insertOrUpdateUser({UserModel userModel}) async {
    final user = await (firebaseAuth.currentUser());
    final userId = user.uid;
    firestore.collection("users").document(userId).setData(userModel.toJson());
  }
}
