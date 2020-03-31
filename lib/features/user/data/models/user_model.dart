import 'package:meta/meta.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {

  const UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required List<String> pastOrderIds,
  }) : super(
          id: id,
          name: name,
          email: email,
          pastOrderIds: pastOrderIds,
        );

  factory UserModel.fromJson(Map json) => json != null
      ? UserModel(
        id: (json['id'] as String),
        name: (json['name'] as String),
        email: (json['email'] as String),
        pastOrderIds: (json['pastOrderIds'] as List<String>),
      )
    : null;
  
  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['pastOrderIds'] = pastOrderIds;
    return map;
  }
}