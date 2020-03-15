import 'package:equatable/equatable.dart';

abstract class NavigationHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeIconPressed extends NavigationHomeEvent {}

class SearchIconPressed extends NavigationHomeEvent {}

class OrdersIconPressed extends NavigationHomeEvent {}
