import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required UserType type,
  }) : super(
          id: id,
          name: name,
          email: email,
          type: type,
        );

  factory UserModel.fromJson(Map json) => json != null
      ? UserModel(
          id: (json['id'] as String),
          name: (json['name'] as String),
          email: (json['email'] as String),
          type: _getUserTypeFromString(json['type'] as String),
        )
      : null;

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['type'] = type.toString();
    return map;
  }

  static UserType _getUserTypeFromString(String type) {
    return UserType.values
        .firstWhere((e) => e.toString() == 'UserModel.' + type);
  }

  UserModel copyWith({
    String id,
    String name,
    String email,
    UserType type,
    String status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
    );
  }
}
