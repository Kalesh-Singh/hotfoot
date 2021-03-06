import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_state.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_state.dart';
import 'package:hotfoot/core/style/style.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity placeEntity;

  const PlaceCard({Key key, this.placeEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);

    return GestureDetector(
      onTap: () {
        print('PLACE TAPPED');
        final locationState = locationBloc.state;
        if (!(locationState is LocationUninitialized)) {
          PlaceModel destinationPlace;
          if (locationState is CurrentPlaceLoadSuccess) {
            destinationPlace = locationState.placeModel;
          } else if (locationState is QueriedPlaceLoadSuccess) {
            destinationPlace = locationState.placeModel;
          } else {
            print('LOCATION STATE FAILURE');
          }
          final runModel = navScreenBloc.state.runModel;
          navScreenBloc.add(
            EnteredPurchaseFlow(
              runModel: runModel.copyWith(
                pickupPlaceIdOrCustomPlace: Left(placeEntity.id),
                destinationPlace: destinationPlace,
              ),
            ),
          );
        } else {
          print('LOCATION STATE NOT UNINITIALIZED');
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 140,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: BlocBuilder<PlacePhotoBloc, PlacePhotoState>(
                  builder: (BuildContext context, PlacePhotoState state) {
                    if (state is PlacePhotoLoadSuccess) {
                      final photoSize = state.placePhoto.lengthSync();
                      print('PHOTO SIZE UI: $photoSize');
                      final photoBytes = state.placePhoto.readAsBytesSync();
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.memory(
                          photoBytes,
                          width: 140,
                          height: 140,
                          fit: BoxFit.fill,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/place-photo-placeholder.png',
                          width: 140,
                          height: 140,
                          fit: BoxFit.fill,
                        ),
                      );
                    }
                  },
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Text(placeEntity.name, style: style.copyWith(fontSize: 16, fontWeight: FontWeight.bold),)),
                      Expanded(child: Text(placeEntity.address, style: style.copyWith(fontSize: 14),)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
