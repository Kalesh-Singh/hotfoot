import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_state.dart';
import 'package:hotfoot/features/runs/presentation/blocs/current_run/current_run_bloc.dart';
import 'package:hotfoot/injection_container.dart';

class OrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentRunBloc = BlocProvider.of<CurrentRunBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaceDetailsBloc>(
          create: (context) => sl<PlaceDetailsBloc>(),
        ),
        BlocProvider<PlacePhotoBloc>(
          create: (context) => sl<PlacePhotoBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            // TODO: This has to account for going back to the pin
            // location screen too.
            onPressed: () => BlocProvider.of<NavigationScreenBloc>(context)
                .add(EnteredHome()),
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SafeArea(
            child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
              builder: (BuildContext context, PlaceDetailsState state) {
                if (state is PlaceDetailsUninitialized) {
                  final pickUpEither =
                      currentRunBloc.state.runModel.pickupPlaceIdOrCustomPlace;
                  pickUpEither.fold(
                    (pickupPlaceId) {
                      BlocProvider.of<PlaceDetailsBloc>(context)
                          .add(PlaceDetailsRequested(placeId: pickupPlaceId));
                    },
                    (customPlace) {
                      // TODO: Handle event for CustomPlace
                    },
                  );
                  return Container(
                    height: 50,
                    child: Center(
                      child: Text('Loading'),
                    ),
                  );
                } else if (state is PlaceDetailsLoadSuccess) {
                  final placeEntity = state.placeEntity;
                  BlocProvider.of<PlacePhotoBloc>(context)
                      .add(PlacePhotoRequested(placeEntity: placeEntity));
                  return BlocBuilder<PlacePhotoBloc, PlacePhotoState>(
                    builder: (BuildContext context, PlacePhotoState state) {
                      if (state is PlacePhotoLoadSuccess) {
                        final photoSize = state.placePhoto.lengthSync();
                        print('PHOTO SIZE UI: $photoSize');
                        final photoBytes = state.placePhoto.readAsBytesSync();
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Image.memory(
                                photoBytes,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    (MediaQuery.of(context).size.height / 4),
                                fit: BoxFit.fill,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Text(
                                  placeEntity.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  maxLines: 5,
                                ),
                              ),
                            ],
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
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
