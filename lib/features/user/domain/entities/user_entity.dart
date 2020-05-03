import 'package:equatable/equatable.dart';
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
  final double customerRating;

  const UserEntity({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.type,
    @required this.isEmailVerified,
    @required this.funds,
    @required this.photoUrl,
    @required this.customerRating,
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
        customerRating,
      ];
}
