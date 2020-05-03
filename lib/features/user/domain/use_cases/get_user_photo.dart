import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUserPhoto implements UseCase<File, String> {
  final IUserRepository userRepository;

  const GetUserPhoto({@required this.userRepository});

  /// Passing null for [params] will get the photo for the
  /// currently signed in user. Passing a valid user id
  /// for [params] will give the corresponding user photo.
  @override
  Future<Either<Failure, File>> call(String params) async {
    return await userRepository.getUserPhoto(params);
  }
}
