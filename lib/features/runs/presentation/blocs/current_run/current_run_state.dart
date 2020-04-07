import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

@immutable
class CurrentRunState extends Equatable {
  final RunModel runModel;

  const CurrentRunState({
    @required this.runModel,
  });

  @override
  List<Object> get props => [runModel];
}
