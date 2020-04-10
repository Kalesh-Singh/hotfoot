import 'package:dartz/dartz.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:meta/meta.dart';

class RunModel extends RunEntity {
  const RunModel({
    @required String id,
    @required String order,
    @required Either<String, PlaceEntity> pickupPlaceIdOrCustomPlace,
    @required PlaceEntity destinationPlace,
    @required String customerId,
    @required String runnerId,
    @required DateTime timePlaced,
    @required DateTime timeDelivered,
    @required double cost,
    @required String status,
  }) : super(
          id: id,
          order: order,
          pickupPlaceIdOrCustomPlace: pickupPlaceIdOrCustomPlace,
          destinationPlace: destinationPlace,
          customerId: customerId,
          runnerId: runnerId,
          timePlaced: timePlaced,
          timeDelivered: timeDelivered,
          cost: cost,
          status: status,
        );

  factory RunModel.fromJson(Map json) => json != null
      ? RunModel(
          id: (json['id'] as String),
          order: (json['order'] as String),
          pickupPlaceIdOrCustomPlace: _getPickupPlaceFromJson(json),
          destinationPlace: PlaceModel.fromJson(json['destinationPlace']),
          customerId: (json['customerId'] as String),
          runnerId: (json['runnerId'] as String),
          timePlaced: DateTime.tryParse(json['timePlaced'] as String),
          timeDelivered: DateTime.tryParse((json['timeDelivered'] as String)),
          cost: (json['cost'] as double),
          status: (json['status'] as String),
        )
      : null;

  static Either<String, PlaceEntity> _getPickupPlaceFromJson(Map json) {
    String pickupPlaceId = json['pickupPlaceId'];
    PlaceEntity customPickupPlace =
        PlaceModel.fromJson(json['customPickupPlace']);

    if (pickupPlaceId != null) {
      return Left(pickupPlaceId);
    } else if (customPickupPlace != null) {
      return Right(customPickupPlace);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    Map map = Map<String, dynamic>();

    map['id'] = this.id;
    map['order'] = this.order;
    map['destinationPlace'] = (destinationPlace as PlaceModel)?.toJson();
    map['customerId'] = customerId;
    map['runnerId'] = runnerId;
    map['timePlaced'] = timePlaced?.toIso8601String();
    map['timeDelivered'] = timeDelivered?.toIso8601String();
    map['cost'] = cost;
    map['status'] = status;

    pickupPlaceIdOrCustomPlace?.fold(
      (pickupPlaceId) {
        map['pickupPlaceId'] = pickupPlaceId;
      },
      (customPlace) {
        map['customPickupPlace'] = (customPlace as PlaceModel)?.toJson();
      },
    );

    return map;
  }

  RunEntity copyWith({
    String id,
    String order,
    Either<String, PlaceEntity> pickupPlaceIdOrCustomPlace,
    PlaceEntity destinationPlace,
    String customerId,
    String runnerId,
    DateTime timePlaced,
    DateTime timeDelivered,
    double cost,
    String status,
//    LocationEntity runnerLocation,
  }) {
    return RunModel(
      id: id ?? this.id,
      order: order ?? this.order,
      pickupPlaceIdOrCustomPlace:
          pickupPlaceIdOrCustomPlace ?? this.pickupPlaceIdOrCustomPlace,
      destinationPlace: destinationPlace ?? this.destinationPlace,
      customerId: customerId ?? this.customerId,
      runnerId: runnerId ?? this.runnerId,
      timePlaced: timePlaced ?? this.timePlaced,
      timeDelivered: timeDelivered ?? this.timeDelivered,
      cost: cost ?? this.cost,
      status: status ?? this.status,
//      runnerLocation: runnerLocation ?? this.runnerLocation,
    );
  }

  factory RunModel.empty() {
    return RunModel(
      id: null,
      order: null,
      pickupPlaceIdOrCustomPlace: null,
      destinationPlace: null,
      customerId: null,
      runnerId: null,
      timePlaced: null,
      timeDelivered: null,
      cost: null,
      status: null,
    );
  }
}
