import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/core/use_cases/use_case.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_customer_runs_ids.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_event.dart';
import 'package:hotfoot/features/runs/presentation/blocs/customer_runs_ids/customer_runs_ids_state.dart';
import 'package:meta/meta.dart';

class CustomerRunsIdsBloc
    extends Bloc<CustomerRunsIdsEvent, CustomerRunsIdsState> {
  static const String _ERROR_MSG = 'Failed to retrieve customer runs ids';
  final GetCustomerRunsIds getCustomerRunsIds;

  CustomerRunsIdsBloc({@required this.getCustomerRunsIds});

  @override
  CustomerRunsIdsState get initialState => CustomerRunsIdsUninitialized();

  @override
  Stream<CustomerRunsIdsState> mapEventToState(
      CustomerRunsIdsEvent event) async* {
    if (event is CustomerRunsRequested) {
      print('CUSTOMER RUNS REQUESTED');
      final failureOrCustomerRunsIds = await getCustomerRunsIds(NoParams());
      yield* _eitherLoadedOrFailureState(failureOrCustomerRunsIds);
    }
  }

  Stream<CustomerRunsIdsState> _eitherLoadedOrFailureState(
    Either<Failure, List<String>> failureOrCustomerRunsIds,
  ) async* {
    yield failureOrCustomerRunsIds.fold(
      (failure) => CustomerRunsIdsLoadFailure(message: _ERROR_MSG),
      (customerRunsIds) =>
          CustomerRunsIdsLoadSuccess(customerRunsIds: customerRunsIds),
    );
  }
}
