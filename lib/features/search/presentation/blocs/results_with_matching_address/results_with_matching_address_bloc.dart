import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/search/domain/use_cases/get_results_with_matching_address.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_state.dart';
import 'package:meta/meta.dart';

class ResultsWithMatchingAddressBloc extends Bloc<
    ResultsWithMatchingAddressEvent, ResultsWithMatchingAddressState> {
  static const String _ERROR_MSG = 'Failed to retrieve search results';
  final GetResultsWithMatchingAddress getResultsWithMatchingAddress;

  ResultsWithMatchingAddressBloc(
      {@required this.getResultsWithMatchingAddress});

  @override
  ResultsWithMatchingAddressState get initialState =>
      ResultsWithMatchingAddressEmpty();

  @override
  Stream<ResultsWithMatchingAddressState> mapEventToState(
      ResultsWithMatchingAddressEvent event) async* {
    if (event is AddressEntered) {
      String placeAddress = event.placeAddress;
      if (placeAddress.length == 0) {
        yield ResultsWithMatchingAddressEmpty();
      } else {
        final failureOrResultsWithMatchingAddress =
            await getResultsWithMatchingAddress(placeAddress);
        yield* _eitherResultsWithMatchingAddressSearchedOrFailureState(
            failureOrResultsWithMatchingAddress);
      }
    } else if (event is ListEntryClicked) {
      yield ResultsWithMatchingAddressEmpty();
    }
  }

  Stream<ResultsWithMatchingAddressState>
      _eitherResultsWithMatchingAddressSearchedOrFailureState(
    Either<Failure, List<PlaceEntity>> failureOrResultsWithMatchingAddress,
  ) async* {
    yield failureOrResultsWithMatchingAddress.fold(
      (failure) => ResultsWithMatchingAddressFailure(message: _ERROR_MSG),
      (resultsWithMatchingAddress) => ResultsWithMatchingAddressSearched(
          resultsWithMatchingAddress: resultsWithMatchingAddress),
    );
  }
}
