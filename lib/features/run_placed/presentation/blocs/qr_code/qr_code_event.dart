import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:meta/meta.dart';

abstract class QRCodeEvent extends Equatable {
  const QRCodeEvent();

  @override
  List<Object> get props => [];
}

class RunUpdatedInDatabase extends QRCodeEvent {
  final RunEntity runEntity;
  final bool isRunner;

  const RunUpdatedInDatabase(
      {@required this.runEntity, @required this.isRunner});
}

class CounterpartQRConfirmed extends QRCodeEvent {
  final RunModel runModel;
  final bool isRunner;

  const CounterpartQRConfirmed(
      {@required this.runModel, @required this.isRunner});
}
