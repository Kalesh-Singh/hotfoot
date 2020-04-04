import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hotfoot/features/places/domain/entities/location_entity.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:meta/meta.dart';

/// [id] is the auto generated id from firestore.
/// [id] can be null when the object is created on the client device.
/// [order] is the input text with the user's request.
/// Possibly in the future this will be itemized and and
/// handled by an [OrderEntity] object in the future.
/// Either [pickupPlaceIdOrCustomPlace] cannot be null and must contain
/// one of the either values depending on how the order was placed.
/// It is the intention to add the CustomPlace from successful orders
/// to an "Unknown places" data store, which will be a store of potential
/// places to add to the "places" store on a TBD criteria.
/// [destinationPlaceId] will be pulled from an "address store" and not from
/// the user's current location.
/// [customerId] cannot be null.
/// [runnerId] can be null, will be populated once the run is accepted.
/// Both [runnerId] and [customerId] must be valid firebase user ids,
/// and present in the "users" firestore.
/// [timePlaced] cannot be null.
/// [timeDelivered] can be null, will be populated once run is completed.
/// Both [timePlaced] and [timeDelivered] must include UTC time zone,
/// in the string.
/// [cost] can be null, will only be populated in completed orders,
/// inorder to provide a price estimate to customers.
/// Initially [status] should be initialized with "Pending message".
/// [runnerLocation] can be null initially.
/// NOTE: This must be a subcollection in the run document. Since we will need
/// to listen to the changes as a stream. Currently I believe this is only
/// supported for firestore collections and not documents.
/// NOTE; No need for runnerLocation to be in the local objects.
/// But it will exist temporarily in the firestore, whilst the
/// run is being made.

class RunEntity extends Equatable {
  final String id;
  final String order;
  final Either<String, PlaceEntity> pickupPlaceIdOrCustomPlace;
  final String destinationPlaceId;
  final String customerId;
  final String runnerId;
  final DateTime timePlaced;
  final DateTime timeDelivered;
  final double cost;
  final String status;

//  final LocationEntity runnerLocation;

  const RunEntity({
    @required this.id,
    @required this.order,
    @required this.pickupPlaceIdOrCustomPlace,
    @required this.destinationPlaceId,
    @required this.customerId,
    @required this.runnerId,
    @required this.timePlaced,
    @required this.timeDelivered,
    @required this.cost,
    @required this.status,
//    @required this.runnerLocation,
  })  : assert(order != null),
        assert(pickupPlaceIdOrCustomPlace != null),
        assert(destinationPlaceId != null),
        assert(customerId != null),
        assert(timePlaced != null),
        assert(status != null);

  RunEntity copyWith({
    String id,
    String order,
    Either<String, PlaceEntity> pickupPlaceIdOrCustomPlace,
    String destinationPlaceId,
    String customerId,
    String runnerId,
    DateTime timePlaced,
    DateTime timeDelivered,
    double cost,
    String status,
//    LocationEntity runnerLocation,
  }) {
    return RunEntity(
      id: id ?? this.id,
      order: order ?? this.order,
      pickupPlaceIdOrCustomPlace:
          pickupPlaceIdOrCustomPlace ?? this.pickupPlaceIdOrCustomPlace,
      destinationPlaceId: destinationPlaceId ?? this.destinationPlaceId,
      customerId: customerId ?? this.customerId,
      runnerId: runnerId ?? this.runnerId,
      timePlaced: timePlaced ?? this.timePlaced,
      timeDelivered: timeDelivered ?? this.timeDelivered,
      cost: cost ?? this.cost,
      status: status ?? this.status,
//      runnerLocation: runnerLocation ?? this.runnerLocation,
    );
  }

  @override
  List<Object> get props => [
        id,
        order,
        pickupPlaceIdOrCustomPlace,
        destinationPlaceId,
        customerId,
        runnerId,
        timePlaced,
        timeDelivered,
        cost,
        status,
//        runnerLocation,
      ];
}
