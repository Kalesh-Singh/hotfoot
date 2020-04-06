import 'package:dartz/dartz.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/location/domain/entities/location_entity.dart';
import 'package:hotfoot/features/location/domain/repositories/location_repository.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

class LocationRepository implements ILocationRepository {
  final Geolocator geolocator;

  const LocationRepository({
    @required this.geolocator,
  }) : assert(geolocator != null);

  Future<LocationEntity> _getCurrentLocation() async {
    final Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LocationEntity(
      lat: position.latitude,
      lng: position.longitude,
    );
  }

  @override
  Future<Either<Failure, PlaceEntity>> getCurrentPlace() async {
    final currentLocation = await _getCurrentLocation();
    final coordinates = new Coordinates(
      currentLocation.lat,
      currentLocation.lng,
    );
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final firstAddress = addresses.first;
    print("${firstAddress.featureName} : ${firstAddress.addressLine}");
    return Right(
      PlaceEntity(
        id: null,
        name: firstAddress.addressLine,
        address: firstAddress.addressLine,
        locationEntity: LocationEntity(
          lat: firstAddress.coordinates.latitude,
          lng: firstAddress.coordinates.longitude,
        ),
        orders: null,
        photoUrl: null,
      ),
    );
  }

  @override
  Future<Either<Failure, PlaceEntity>> getPlaceFromAddress({String address}) {
    // TODO: implement getPlaceFromAddress
    return null;
  }
}
