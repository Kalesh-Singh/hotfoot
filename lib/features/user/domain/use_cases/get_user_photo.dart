import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUserPhoto implements UseCase<File, NoParams> {
  final IUserRepository userRepository;

  const GetUserPhoto({@required this.userRepository});

  @override
  Future<Either<Failure, File>> call(NoParams params) async {
    return await userRepository.getUserPhoto();
  }
}
