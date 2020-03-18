import 'package:equatable/equatable.dart';

abstract class NavigationHomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeIconTab extends NavigationHomeState {}

class SearchIconTab extends NavigationHomeState {}

class OrdersIconTab extends NavigationHomeState {}
