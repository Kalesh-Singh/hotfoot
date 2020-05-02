import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetCustomerRating implements UseCase<double, NoParams> {
  final IUserRepository userRepository;
  const GetCustomerRating({@required this.userRepository});

  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await userRepository.getCustomerRating();
  }
}