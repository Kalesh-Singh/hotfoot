import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:meta/meta.dart';

class PlaceEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final LocationEntity locationEntity;
  final String photoUrl;
  final int orders;

  const PlaceEntity({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.locationEntity,
    @required this.photoUrl,
    @required this.orders,
  });

  @override
  String toString() => "$name, $locationEntity";

  @override
  List<Object> get props => [
        id,
        name,
        address,
        locationEntity,
        photoUrl,
        orders,
      ];
}
