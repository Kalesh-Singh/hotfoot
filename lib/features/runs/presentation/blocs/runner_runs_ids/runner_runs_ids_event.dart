import 'package:equatable/equatable.dart';

abstract class RunnerRunsIdsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RunnerRunsRequested extends RunnerRunsIdsEvent {}
