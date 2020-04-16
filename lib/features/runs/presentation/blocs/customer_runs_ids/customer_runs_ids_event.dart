import 'package:equatable/equatable.dart';

abstract class CustomerRunsIdsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CustomerRunsRequested extends CustomerRunsIdsEvent {}
