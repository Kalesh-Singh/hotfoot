import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:meta/meta.dart';

abstract class AcceptRunEvent extends Equatable {
  const AcceptRunEvent();

  @override
  List<Object> get props => [];
}

class AcceptRunButtonPressed extends AcceptRunEvent {
  final RunModel runModel;

  const AcceptRunButtonPressed({@required this.runModel});
}
