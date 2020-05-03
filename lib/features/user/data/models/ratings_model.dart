import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
import 'package:meta/meta.dart';

class RatingsModel extends RatingsEntity {
  final double customerRating;
  final int customerRatingCount;
  final double runnerRating;
  final int runnerRatingCount;

  const RatingsModel({
    @required this.customerRating,
    @required this.customerRatingCount,
    @required this.runnerRating,
    @required this.runnerRatingCount,
  }) : super(
          customerRating: customerRating,
          customerRatingCount: customerRatingCount,
          runnerRating: runnerRating,
          runnerRatingCount: runnerRatingCount,
        );

  factory RatingsModel.fromJson(Map json) => json != null
      ? RatingsModel(
          customerRating: (json['customerRating'] as num).toDouble(),
          customerRatingCount: (json['customerRatingCount'] as num).toInt(),
          runnerRating: (json['runnerRating'] as num).toDouble(),
          runnerRatingCount: (json['runnerRatingCount'] as num).toInt(),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['customerRating'] = customerRating;
    map['customerRatingCount'] = customerRatingCount;
    map['runnerRating'] = runnerRating;
    map['runnerRatingCount'] = runnerRatingCount;
    return map;
  }

  factory RatingsModel.empty() {
    return RatingsModel(
      customerRating: 0.0,
      customerRatingCount: 0,
      runnerRating: 0.0,
      runnerRatingCount: 0,
    );
  }

  RatingsModel copyWith({
    double customerRating,
    int customerRatingCount,
    double runnerRating,
    int runnerRatingCount,
  }) {
    return RatingsModel(
      customerRating: customerRating ?? this.customerRating,
      customerRatingCount: customerRatingCount ?? this.customerRatingCount,
      runnerRating: runnerRating ?? this.runnerRating,
      runnerRatingCount: runnerRatingCount ?? this.runnerRatingCount,
    );
  }
}
