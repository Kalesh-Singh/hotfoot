import 'package:hotfoot/features/user/data/models/ratings_model.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required UserType type,
    @required bool isEmailVerified,
    @required double funds,
    @required String photoUrl,
    @required RatingsEntity ratings,
  }) : super(
          id: id,
          name: name,
          email: email,
          type: type,
          isEmailVerified: isEmailVerified,
          funds: funds,
          photoUrl: photoUrl,
          ratings: ratings,
        );

  factory UserModel.fromJson(Map json) => json != null
      ? UserModel(
          id: (json['id'] as String),
          name: (json['name'] as String),
          email: (json['email'] as String),
          type: _getUserTypeFromString(json['type'] as String),
          isEmailVerified:
              _getIsEmailVerifiedFromString(json['isEmailVerified'] as String),
          funds: (json['funds'] as double),
          photoUrl: (json['photoUrl'] as String),
          ratings: RatingsModel.fromJson(json['ratings']),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['type'] = type.toString();
    map['isEmailVerified'] = isEmailVerified.toString();
    map['funds'] = funds;
    map['photoUrl'] = photoUrl;
    map['ratings'] = (ratings as RatingsModel)?.toJson();
    return map;
  }

  static UserType _getUserTypeFromString(String type) {
    return UserType.values.firstWhere((e) => e.toString() == type);
  }

  static bool _getIsEmailVerifiedFromString(String isEmailVerified) {
    return isEmailVerified == "true";
  }

  UserModel copyWith({
    String id,
    String name,
    String email,
    UserType type,
    String status,
    bool isEmailVerified,
    double funds,
    String photoUrl,
    RatingsEntity ratings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      funds: funds ?? this.funds,
      photoUrl: photoUrl ?? this.photoUrl,
      ratings: ratings ?? this.ratings,
    );
  }
}
