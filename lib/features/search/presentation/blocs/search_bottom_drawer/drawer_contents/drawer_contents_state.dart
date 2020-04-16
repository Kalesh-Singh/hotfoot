import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';

abstract class DrawerContentsState extends Equatable {
  const DrawerContentsState();

  @override
  List<Object> get props => [];
}

class DrawerContentsUninitialized extends DrawerContentsState {}

class DrawerContentsLoaded extends DrawerContentsState {
  final File photo;
  final PlaceEntity placeEntity;

  const DrawerContentsLoaded({@required this.photo, this.placeEntity});

  @override
  List<Object> get props => [photo, placeEntity];
}

class DrawerContentsFailure extends DrawerContentsState {
  final String message;

  const DrawerContentsFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
