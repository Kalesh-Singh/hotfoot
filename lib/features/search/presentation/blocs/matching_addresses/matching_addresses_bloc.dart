import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/search/domain/use_cases/get_matching_addresses.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_state.dart';
import 'package:meta/meta.dart';

class MatchingAddressesBloc
    extends Bloc<MatchingAddressesEvent, MatchingAddressesState> {
  static const String _ERROR_MSG = 'Failed to retrieve search results';
  final GetMatchingAddresses getMatchingAddresses;

  MatchingAddressesBloc({@required this.getMatchingAddresses});

  @override
  MatchingAddressesState get initialState => MatchingAddressesEmpty();

  @override
  @override
  Stream<MatchingAddressesState> mapEventToState(
      MatchingAddressesEvent event) async* {
    if (event is AddressEntered) {
      String placeAddress = event.placeAddress;
      if (placeAddress.length == 0) {
        yield MatchingAddressesEmpty();
      } else {
        final failureOrMatchingAddresses =
            await getMatchingAddresses(placeAddress);
        yield* _eitherMatchingAddressesSearchedOrFailureState(
            failureOrMatchingAddresses);
      }
    }
  }

  Stream<MatchingAddressesState> _eitherMatchingAddressesSearchedOrFailureState(
    Either<Failure, List<String>> failureOrMatchingAddresses,
  ) async* {
    yield failureOrMatchingAddresses.fold(
      (failure) => MatchingAddressesFailure(message: _ERROR_MSG),
      (matchingAddresses) =>
          MatchingAddressesSearched(matchingAddresses: matchingAddresses),
    );
  }
}
