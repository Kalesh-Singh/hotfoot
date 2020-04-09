import 'package:hotfoot/features/places/data/models/place_model.dart';
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
  final PlaceModel destinationPlace;

  const DestinationChanged({@required this.destinationPlace});

  @override
  List<Object> get props => [destinationPlace];

  @override
  String toString() =>
      'DestinationChanged { destinationPlace :$destinationPlace }';
}

class PickupPlaceIdAndDestinationPlaceChanged extends CurrentRunEvent {
  final String pickupPlaceId;
  final PlaceModel destinationPlace;

  const PickupPlaceIdAndDestinationPlaceChanged({
    @required this.pickupPlaceId,
    @required this.destinationPlace,
  });

  @override
  List<Object> get props => [pickupPlaceId, destinationPlace];

  @override
  String toString() => 'PickupPlaceIdChanged { pickupPlaceId :$pickupPlaceId }';
}

class OrderAndTimePlacedChanged extends CurrentRunEvent {
  final String order;
  final DateTime timePlaced;

  const OrderAndTimePlacedChanged({
    @required this.order,
    @required this.timePlaced,
  });

  @override
  List<Object> get props => [order, timePlaced];
}
