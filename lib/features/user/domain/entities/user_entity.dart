import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserEntity extends Equatable {
  final String id;
  // Name and email might be the same unless we allow users to set their user names?
  final String name;
  final String email;
  final List<String> pastOrderIds;
  final List<String> pastOrderAddresses;

  const UserEntity({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.pastOrderIds,
    @required this.pastOrderAddresses,
  });

  @override
  String toString() => "$name, $email";

  @override
  List<Object> get props => [
    id,
    name,
    email,
    pastOrderIds,
    pastOrderAddresses,
  ];
  
}