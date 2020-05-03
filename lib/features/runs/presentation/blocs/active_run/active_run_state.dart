import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class ActiveRunState extends Equatable {
  const ActiveRunState();

  @override
  List<Object> get props => [];
}

class ActiveRunUninitialized extends ActiveRunState {}

class NoActiveRuns extends ActiveRunState {}

class RunActive extends ActiveRunState {
  final RunModel activeRun;

  const RunActive({@required this.activeRun});

  @override
  List<Object> get props => [activeRun];
}
