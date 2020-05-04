import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

class RatingsEntity extends Equatable {
  final double customerRating;
  final int customerRatingCount;
  final double runnerRating;
  final int runnerRatingCount;

  const RatingsEntity({
    @required this.customerRating,
    @required this.customerRatingCount,
    @required this.runnerRating,
    @required this.runnerRatingCount,
  });

  @override
  String toString() =>
      "Customer Rating: $customerRating, Runner Rating: $runnerRating";

  @override
  List<Object> get props => [
        customerRating,
        customerRatingCount,
        runnerRating,
        runnerRatingCount,
      ];
}
