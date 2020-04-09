import 'package:dartz/dartz.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:meta/meta.dart';

class LocationRepository implements ILocationRepository {
  final Geolocator geolocator;

  PlaceModel lastPlace;

  LocationRepository({
    @required this.geolocator,
  }) : assert(geolocator != null);

  @override
  Future<Either<Failure, PlaceModel>> getCurrentPlace() async {
    if (lastPlace != null) {
      return Right(lastPlace);
    }

    final currentLocation = await _getCurrentLocation();
    final coordinates = new Coordinates(
      currentLocation.lat,
      currentLocation.lng,
    );
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final firstAddress = addresses.first;
    print("${firstAddress.featureName} : ${firstAddress.addressLine}");
    final place = _getPlaceModelFromAddress(address: firstAddress);
    lastPlace = place;
    return Right(place);
  }

  @override
  Future<Either<Failure, PlaceModel>> getPlaceFromQuery({String query}) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var firstAddress = addresses.first;
    print(
        "${firstAddress.featureName} : ${firstAddress.coordinates} : ${firstAddress.addressLine}");
    final place = _getPlaceModelFromAddress(address: firstAddress);
    lastPlace = place;
    return Right(place);
  }

  PlaceModel _getPlaceModelFromAddress({@required Address address}) {
    return PlaceModel(
      id: null,
      name: address.addressLine,
      address: address.addressLine,
      locationEntity: LocationEntity(
        lat: address.coordinates.latitude,
        lng: address.coordinates.longitude,
      ),
      orders: null,
      photoUrl: null,
    );
  }

  Future<LocationEntity> _getCurrentLocation() async {
    final Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LocationEntity(
      lat: position.latitude,
      lng: position.longitude,
    );
  }
}
