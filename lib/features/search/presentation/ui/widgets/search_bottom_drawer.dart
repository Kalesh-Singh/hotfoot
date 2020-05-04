import 'dart:io';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_state.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/data/models/place_model.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_state.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/search_bottom_drawer_state.dart';
import 'package:hotfoot/features/search/presentation/ui/utils/bottom_drawer_gesture_detector.dart';

class SearchBottomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBottomDrawerBloc>(
      create: (context) => SearchBottomDrawerBloc(),
      child: _SearchBottomDrawer(),
    );
  }
}

class _SearchBottomDrawer extends StatelessWidget {
  final double threshold = 100;

  @override
  Widget build(BuildContext context) {
    return BottomDrawerGestureDetector(
      axis: BottomDrawerGestureDetector.AXIS_Y,
      velocity: threshold,
      onSwipeUp: () {
        BlocProvider.of<SearchBottomDrawerBloc>(context)
            .add(SearchBottomDrawerSwipedUp());
      },
      onSwipeDown: () {
        BlocProvider.of<SearchBottomDrawerBloc>(context)
            .add(SearchBottomDrawerSwipedDown());
      },
      child: Stack(
        children: <Widget>[
          BlocBuilder<SearchBottomDrawerBloc, SearchBottomDrawerState>(
            builder: (context, state) {
              if (state is SearchBottomDrawerOpened) {
                print("Opened!");
                return AnimatedPositioned(
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 200),
                    left: 0,
                    bottom: 0,
                    child: DrawerContents());
              }
              return AnimatedPositioned(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 200),
                  left: 0,
                  bottom: -145,
                  child: DrawerContents());
            },
          ),
        ],
      ),
    );
  }
}

class DrawerContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
      child: Container(
        color: Colors.redAccent,
        width: width,
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.keyboard_arrow_up,
                size: 20,
              ),
              Text(
                "Place Details",
                style: style.copyWith(
                  fontSize: 17, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white
                ),
              ),
              PlaceDetails(),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerContentsBloc, DrawerContentsState>(
      builder: (BuildContext context, DrawerContentsState state) {
        if (state is DrawerContentsLoaded) {
          return PlaceCard(
              placePhoto: state.photo, placeEntity: state.placeEntity);
        } else {
          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "No places searched yet...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ));
        }
      },
    );
  }
}

class PlaceCard extends StatelessWidget {
  final File placePhoto;
  final PlaceEntity placeEntity;

  const PlaceCard({Key key, this.placePhoto, this.placeEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final photoBytes = placePhoto.readAsBytesSync();

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 140,
            padding: EdgeInsets.only(top: 10.0),
            child: Card(
              elevation: 5,
              child: Row(
                children: <Widget>[
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      photoBytes,
                      width: 140,
                      height: 140,
                      fit: BoxFit.fill,
                    ),
                  )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 12.0,
                              left: 12.0,
                            ),
                            child: Text(
                              placeEntity.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 12.0,
                              left: 12.0,
                            ),
                            child: Text(
                              placeEntity.address,
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 140,
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Confirm",
              ),
              Center(
                child: IconButton(
                  icon: Icon(Icons.check_circle),
                  iconSize: 35,
                  color: Colors.greenAccent,
                  onPressed: () {
                    // TODO: Enter purchase flow.
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
