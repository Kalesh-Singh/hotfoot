import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required UserType type,
    @required bool isEmailVerified,
  }) : super(
          id: id,
          name: name,
          email: email,
          type: type,
          isEmailVerified: isEmailVerified,
        );

  factory UserModel.fromJson(Map json) => json != null
      ? UserModel(
          id: (json['id'] as String),
          name: (json['name'] as String),
          email: (json['email'] as String),
          type: _getUserTypeFromString(json['type'] as String),
          isEmailVerified: (json['isEmailVerified'] as bool),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['type'] = type.toString();
    map['isEmailVerified'] = isEmailVerified.toString();
    return map;
  }

  static UserType _getUserTypeFromString(String type) {
    return UserType.values
        .firstWhere((e) => e.toString() == type);
  }

  UserModel copyWith({
    String id,
    String name,
    String email,
    UserType type,
    String status,
    bool isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
