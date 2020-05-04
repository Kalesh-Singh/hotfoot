import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RunFinalizerEvent extends Equatable {
  const RunFinalizerEvent();

  @override
  List<Object> get props => [];
}

class DeliveryConfirmed extends RunFinalizerEvent {
  final bool isRunner;
  final double cost;

  const DeliveryConfirmed({@required this.isRunner, @required this.cost});
}

class RatingGiven extends RunFinalizerEvent {
  final bool isRunner;
  final String userId;
  final double rating;

  const RatingGiven(
      {@required this.isRunner, @required this.userId, @required this.rating});
}
