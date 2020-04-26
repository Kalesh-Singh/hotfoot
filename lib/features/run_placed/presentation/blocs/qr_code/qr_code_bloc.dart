import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_event.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_state.dart';

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  static const String _UNACCEPTED_RUN_ERR_MSG = 'Run is still not accepted';
  static const String _NULL_RUNNER_ERR_MSG = 'Runner ID is null';

  @override
  QRCodeState get initialState => QRCodeUninitialized();

  @override
  Stream<QRCodeState> mapEventToState(QRCodeEvent event) async* {
    if (event is RunUpdatedInDatabase) {
      final runEntity = event.runEntity;
      if (runEntity.status != "Accepted") {
        yield QRCodeLoadFailure(message: _UNACCEPTED_RUN_ERR_MSG);
      } else if (runEntity.runnerId == null) {
        yield QRCodeLoadFailure(message: _NULL_RUNNER_ERR_MSG);
      } else {
        final String customerQR = runEntity.id + runEntity.customerId;
        final String runnerQR = runEntity.id + runEntity.runnerId;
        yield event.isRunner
            ? QRCodeLoadSuccess(
            ownQRCode: runnerQR, counterpartQRCode: customerQR)
            : QRCodeLoadSuccess(
            ownQRCode: customerQR, counterpartQRCode: runnerQR);
      }
    }
  }
}
