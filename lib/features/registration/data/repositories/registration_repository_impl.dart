import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/registration/domain/repositories/registration_repository.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/data/data_sources/user_remote_data_source.dart';

class RegistrationRepository implements IRegistrationRepository {
  final FirebaseAuth firebaseAuth;
  final IUserRepository userRepository;

  const RegistrationRepository({
    @required this.firebaseAuth,
    @required this.userRepository,
  })  : assert(firebaseAuth != null),
        assert(userRepository != null);

  @override
  Future<Either<Failure, UserModel>> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final _firebaseUser = result.user;
      if (_firebaseUser == null) {
        print("firebase user is null");
      }
      final either = await userRepository.initUser();
      return either.fold(
        (failure) {
          return Left(failure);
        },
        (success) {
          return Right(success);
        },
      );
    } catch (e) {
      print(e);
      return Left(FirebaseAuthFailure());
    }
  }
}
