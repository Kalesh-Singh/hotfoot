import 'package:equatable/equatable.dart';

abstract class NavigationScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EnteredPurchaseFlow extends NavigationScreenEvent {}

class EnteredLogin extends NavigationScreenEvent {}

class EnteredSettings extends NavigationScreenEvent {}

class EnteredHome extends NavigationScreenEvent {}
