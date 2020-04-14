import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';

abstract class SearchBottomDrawerState extends Equatable {
  const SearchBottomDrawerState();

  @override
  List<Object> get props => [];
}

class SearchBottomDrawerUninitialized extends SearchBottomDrawerState {}

class SearchBottomDrawerLoaded extends SearchBottomDrawerState {
  final File photo;
  final PlaceEntity placeEntity;

  const SearchBottomDrawerLoaded({@required this.photo, this.placeEntity});

  @override
  List<Object> get props => [photo, placeEntity];
}

class SearchBottomDrawerFailure extends SearchBottomDrawerState {
  final String message;

  const SearchBottomDrawerFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
