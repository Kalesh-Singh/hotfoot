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
    @required String destinationPlaceId,
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
          destinationPlaceId: destinationPlaceId,
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
          destinationPlaceId: (json['destinationPlaceId'] as String),
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

    map['id'] = id;
    map['order'] = order;
    map['destinationPlaceId'] = destinationPlaceId;
    map['customerId'] = customerId;
    map['runnerId'] = runnerId;
    map['timePlaced'] = timePlaced.toIso8601String();
    map['timeDelivered'] = timeDelivered?.toIso8601String();
    map['cost'] = cost;
    map['status'] = status;

    pickupPlaceIdOrCustomPlace.fold(
      (pickupPlaceId) {
        map['pickupPlaceId'] = pickupPlaceId;
      },
      (customPlace) {
        map['customPickupPlace'] = (customPlace as PlaceModel).toJson();
      },
    );

    return map;
  }
}