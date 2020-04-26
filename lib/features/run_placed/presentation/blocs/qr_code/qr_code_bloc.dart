import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_event.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_state.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:meta/meta.dart';

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  static const String _RUNNER_ERR_MSG = 'Runner ID is null';
  static const String _UPDATE_ERR_MSG = 'Failed to update run status';
  final UpdateOrInsertRun updateOrInsertRun;

  QRCodeBloc({
    @required this.updateOrInsertRun,
  });

  @override
  QRCodeState get initialState => QRCodeUninitialized();

  @override
  Stream<QRCodeState> mapEventToState(QRCodeEvent event) async* {
    if (event is RunUpdatedInDatabase) {
      if (event.runEntity.runnerId == null) {
        yield QRCodeFailure(message: _RUNNER_ERR_MSG);
      } else {
        yield _QRCodeLoadSuccess(event.runEntity, event.isRunner);
      }
    } else if (event is CounterpartQRConfirmed) {
      if (event.isRunner) {
        if (event.runModel.status == "ConfirmedByCustomer") {
          final failureOrUpdateSuccess = await updateOrInsertRun(event.runModel
              .copyWith(status: "Delivered", timeDelivered: DateTime.now()));
          failureOrUpdateSuccess.fold(
            (failure) => QRCodeFailure(message: _UPDATE_ERR_MSG),
            (_) => _QRCodeLoadSuccess(event.runModel, event.isRunner),
          );
        }
      } else {
        final failureOrUpdateSuccess = await updateOrInsertRun(
            event.runModel.copyWith(status: "ConfirmedByCustomer"));
        failureOrUpdateSuccess.fold(
          (failure) => QRCodeFailure(message: _UPDATE_ERR_MSG),
          (_) => _QRCodeLoadSuccess(event.runModel, event.isRunner),
        );
      }
    }
  }

  QRCodeLoadSuccess _QRCodeLoadSuccess(RunEntity runEntity, bool isRunner) {
    final String customerQR = runEntity.id + runEntity.customerId;
    final String runnerQR = runEntity.id + runEntity.runnerId;
    return isRunner
        ? QRCodeLoadSuccess(ownQRCode: runnerQR, counterpartQRCode: customerQR)
        : QRCodeLoadSuccess(ownQRCode: customerQR, counterpartQRCode: runnerQR);
  }
}
