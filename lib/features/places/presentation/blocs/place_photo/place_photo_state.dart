import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PlacePhotoState extends Equatable {
  const PlacePhotoState();

  @override
  List<Object> get props => [];
}

class PlacePhotoUninitialized extends PlacePhotoState {}

class PlacePhotoLoadFailure extends PlacePhotoState {
  final String message;

  const PlacePhotoLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}

class PlacePhotoLoadSuccess extends PlacePhotoState {
  final File placePhoto;

  const PlacePhotoLoadSuccess({@required this.placePhoto});

  @override
  List<Object> get props => [placePhoto];
}
