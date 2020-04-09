import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

abstract class NavigationScreenEvent extends Equatable {
  const NavigationScreenEvent();

  @override
  List<Object> get props => [];
}

class EnteredPurchaseFlow extends NavigationScreenEvent {
  final PlaceEntity placeEntity;

  const EnteredPurchaseFlow({@required this.placeEntity});

  @override
  List<Object> get props => [placeEntity];
}

class EnteredLogin extends NavigationScreenEvent {}

class EnteredSettings extends NavigationScreenEvent {}

class EnteredHome extends NavigationScreenEvent {}

class EnteredRunPlaced extends NavigationScreenEvent {}
