import 'package:equatable/equatable.dart';

abstract class PendingRunsIdsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PendingRunsRequested extends PendingRunsIdsEvent {}
