import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class AddUserFunds implements UseCase<double, double> {
  final IUserRepository userRepository;
  const AddUserFunds({@required this.userRepository});

  @override
  Future<Either<Failure, double>> call(double funds) async {
    return await userRepository.addUserFunds(funds: funds);
  }
}