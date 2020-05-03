import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';
import 'package:meta/meta.dart';

enum UserType { CUSTOMER, RUNNER }

class UserEntity extends Equatable {
  final String id;

  // Name and email might be the same unless we allow users to set their user names?
  final String name;
  final String email;
  final UserType type;
  final bool isEmailVerified;
  final double funds;
  final String photoUrl;
  final RatingsEntity ratings;

  const UserEntity({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.type,
    @required this.isEmailVerified,
    @required this.funds,
    @required this.photoUrl,
    @required this.ratings,
  });

  @override
  String toString() => "$name, $email";

  @override
  List<Object> get props => [
        id,
        name,
        email,
        type,
        isEmailVerified,
        funds,
        photoUrl,
        ratings,
      ];

  UserEntity copyWith({
    String id,
    String name,
    String email,
    UserType type,
    bool isEmailVerified,
    double funds,
    String photoUrl
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      funds: funds ?? this.funds,
      photoUrl: photoUrl ?? this.photoUrl
    );
  }
}
