import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String address;
  final Location location;
  final String photoUrl;
  final int orders;

  const Place({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.location,
    @required this.photoUrl,
    @required this.orders,
  });

  @override
  String toString() => "$name, $location";

  @override
  List<Object> get props => [
        id,
        name,
        address,
        location,
        photoUrl,
        orders,
      ];
}
