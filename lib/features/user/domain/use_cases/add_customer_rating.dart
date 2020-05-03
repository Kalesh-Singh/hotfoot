import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/user/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class AddCustomerRating implements UseCase<void, RatingParams> {
  final IUserRepository userRepository;

  const AddCustomerRating({@required this.userRepository});

  @override
  Future<Either<Failure, void>> call(RatingParams params) async {
    return await userRepository.addCustomerRating(
      userId: params.userId,
      rating: params.rating,
    );
  }
}

class RatingParams {
  final String userId;
  final double rating;

  const RatingParams({
    @required this.userId,
    @required this.rating,
  });
}
