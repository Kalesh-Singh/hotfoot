import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_state.dart';

class UnknownPlaceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UnknownPlaceScreen();
}

class _UnknownPlaceScreen extends State<UnknownPlaceScreen> {
  final _placeNameController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  // TODO: Get the current coordinates from home tab.
  LatLng markerLatLng = LatLng(37.42199552647863, -122.08394385874273);
  final singletonMarkerId = MarkerId("Marker");

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnknownPlaceScreenBloc, UnknownPlaceScreenState>(
      listener: (context, state) {
        if (state is PlaceModelLoaded) {
          print("Continuing order");
          final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
          final runModel = navScreenBloc.state.runModel;
          navScreenBloc.add(
            EnteredPurchaseFlow(
              runModel: runModel.copyWith(
                pickupPlaceIdOrCustomPlace: dartz.Right(state.placeModel),
                destinationPlace: state.placeModel,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Manual Location'),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              BlocProvider.of<SearchHandlerScreenBloc>(context)
                  .add(SearchBarPressed());
            },
            child: Icon(
              Icons.arrow_back,
              size: 25.0,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: Center(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: markerLatLng,
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(
                    <Marker>[
                      Marker(
                        draggable: true,
                        markerId: singletonMarkerId,
                        position: markerLatLng,
                        icon: BitmapDescriptor.defaultMarker,
                        onDragEnd: ((value) {
                          markerLatLng =
                              LatLng(value.latitude, value.longitude);
                          print("Marker moved to $markerLatLng");
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0.0, 0.0),
                      height: 50,
                      child: Text(
                        "Please provide more details of the place for runners",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: TextField(
                        controller: _placeNameController,
                        decoration: InputDecoration(
                          labelText: 'Place Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: ButtonTheme(
                          minWidth: 140.0,
                          height: 40.0,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              BlocProvider.of<UnknownPlaceScreenBloc>(context)
                                  .add(ContinueOrderButtonPressed(
                                      latLng: markerLatLng,
                                      placeName: _placeNameController.text));
                            },
                            label: Text('Continue Order',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            icon: FaIcon(FontAwesomeIcons.penAlt,
                                color: Colors.white),
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }
}
