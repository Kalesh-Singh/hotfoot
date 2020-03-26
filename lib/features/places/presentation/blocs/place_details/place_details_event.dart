import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PlaceDetailsEvent extends Equatable {
  const PlaceDetailsEvent();

  @override
  List<Object> get props => [];
}

class PlaceDetailsRequested extends PlaceDetailsEvent {
  final String placeId;

  const PlaceDetailsRequested({@required this.placeId});
}

class PlacePhotoRequested extends PlaceDetailsEvent {}
