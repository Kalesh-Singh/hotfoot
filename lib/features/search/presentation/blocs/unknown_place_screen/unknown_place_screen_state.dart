import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

abstract class UnknownPlaceScreenState extends Equatable {
  const UnknownPlaceScreenState();

  @override
  List<Object> get props => [];
}

class UnknownPlaceScreenUninitialized extends UnknownPlaceScreenState {}

class PlaceModelLoaded extends UnknownPlaceScreenState {
  final PlaceModel placeModel;

  const PlaceModelLoaded({@required this.placeModel});

  @override
  List<Object> get props => [placeModel];
}
