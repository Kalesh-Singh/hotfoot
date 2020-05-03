import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class GetUserRatings implements UseCase<RatingsEntity, NoParams> {
  final IUserRepository userRepository;

  const GetUserRatings({@required this.userRepository});

  @override
  Future<Either<Failure, RatingsEntity>> call(NoParams params) async {
    return await userRepository.getUserRatings();
  }
}
