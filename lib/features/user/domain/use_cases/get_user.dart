import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUser implements UseCase<FirebaseUser, NoParams> {
  final IUserRepository userRepository;
  const GetUser({@required this.userRepository});

  @override
  Future<Either<Failure, FirebaseUser>> call(NoParams params) async {
    return await userRepository.getUser();
  }
}