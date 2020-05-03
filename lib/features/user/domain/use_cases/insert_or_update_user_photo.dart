import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class InsertOrUpdateUserPhoto implements UseCase<File, File> {
  final IUserRepository userRepository;

  const InsertOrUpdateUserPhoto({@required this.userRepository});

  @override
  Future<Either<Failure, File>> call(File params) async {
    return await userRepository.insertOrUpdateUserPhoto(userPhotoFile: params);
  }
}
