import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class QRCodeState extends Equatable {
  const QRCodeState();

  @override
  List<Object> get props => [];
}

class QRCodeUninitialized extends QRCodeState {}

class QRCodeLoadSuccess extends QRCodeState {
  final String ownQRCode;
  final String counterpartQRCode;

  const QRCodeLoadSuccess(
      {@required this.ownQRCode, @required this.counterpartQRCode});

  @override
  List<Object> get props => [ownQRCode, counterpartQRCode];
}

class QRCodeLoadFailure extends QRCodeState {
  final String message;

  const QRCodeLoadFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
