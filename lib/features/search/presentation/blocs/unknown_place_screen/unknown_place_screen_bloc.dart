import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:hotfoot/features/location/data/models/location_model.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_state.dart';

class UnknownPlaceScreenBloc
    extends Bloc<UnknownPlaceScreenEvent, UnknownPlaceScreenState> {
  @override
  UnknownPlaceScreenState get initialState => UnknownPlaceScreenUninitialized();

  @override
  Stream<UnknownPlaceScreenState> mapEventToState(
      UnknownPlaceScreenEvent event) async* {
    if (event is ContinueOrderButtonPressed) {
      final lat = event.latLng.latitude;
      final lng = event.latLng.longitude;
      final addresses = await Geocoder.local
          .findAddressesFromCoordinates(Coordinates(lat, lng));
      final PlaceModel placeModel = PlaceModel(
        id: null,
        name: event.placeName,
        address: addresses.first.addressLine,
        locationModel: LocationModel(
          lat: lat,
          lng: lng,
        ),
        orders: null,
        photoUrl: null,
      );
      yield PlaceModelLoaded(placeModel: placeModel);
    } else {
      yield UnknownPlaceScreenUninitialized();
    }
  }
}
