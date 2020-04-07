import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CurrentRunEvent extends Equatable {
  const CurrentRunEvent();

  @override
  List<Object> get props => [];
}

class CustomerChanged extends CurrentRunEvent {}

class OrderChanged extends CurrentRunEvent {
  final String order;

  const OrderChanged({@required this.order});

  @override
  List<Object> get props => [order];

  @override
  String toString() => 'OrderChanged { order :$order }';
}

class PickupPlaceIdChanged extends CurrentRunEvent {
  final String pickupPlaceId;

  const PickupPlaceIdChanged({@required this.pickupPlaceId});

  @override
  List<Object> get props => [pickupPlaceId];

  @override
  String toString() => 'PickupPlaceIdChanged { pickupPlaceId :$pickupPlaceId }';
}

class DestinationChanged extends CurrentRunEvent {
  final PlaceEntity destinationPlace;

  const DestinationChanged({@required this.destinationPlace});

  @override
  List<Object> get props => [destinationPlace];

  @override
  String toString() =>
      'DestinationChanged { destinationPlace :$destinationPlace }';
}



