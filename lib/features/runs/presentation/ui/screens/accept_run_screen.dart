import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_state.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_state.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_event.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/run_photo.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_photo_widget.dart';
import 'package:hotfoot/injection_container.dart';

class AcceptRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final runModel = navScreenBloc.state.runModel;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AcceptRunBloc>(
          create: (context) => sl<AcceptRunBloc>(),
        ),
        BlocProvider<PlaceDetailsBloc>(
          create: (context) => sl<PlaceDetailsBloc>(),
        ),
        BlocProvider<PlacePhotoBloc>(
          create: (context) => sl<PlacePhotoBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Run Details',
          style: style.copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => BlocProvider.of<NavigationScreenBloc>(context)
                .add(EnteredHome()),
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SafeArea(
            child: BlocBuilder<AcceptRunBloc, AcceptRunState>(
              builder: (BuildContext context, AcceptRunState state) {
                if (state is AcceptRunSuccess) {
                  BlocProvider.of<NavigationScreenBloc>(context).add(
                      EnteredRunPlaced(runModel: runModel, isRunner: true));
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
                          builder:
                              (BuildContext context, PlaceDetailsState state) {
                            PlaceEntity placeEntity;
                            if (state is PlaceDetailsUninitialized) {
                              runModel.pickupPlaceIdOrCustomPlace.fold(
                                (pickupPlaceId) {
                                  BlocProvider.of<PlaceDetailsBloc>(context)
                                      .add(PlaceDetailsRequested(
                                          placeId: pickupPlaceId));
                                },
                                (customPlace) {
                                  placeEntity = customPlace;
                                },
                              );
                            } else if (state is PlaceDetailsLoadSuccess) {
                              placeEntity = state.placeEntity;
                              BlocProvider.of<PlacePhotoBloc>(context).add(
                                  PlacePhotoRequested(
                                      placeEntity: state.placeEntity));
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RunPhoto(placeEntity: placeEntity),
                            );
                          },
                        ),
                        Expanded(
                          child: Container(
                            width: double.maxFinite,
                            child: Card(
                              margin:
                                  EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _getLabelAndTextBody(
                                        label: 'Address: ',
                                        textBody:
                                            runModel.destinationPlace.address),
                                    _getLabelAndTextBody(
                                        label: 'Request: ',
                                        textBody: runModel.order),
                                    _getLabelAndTextBody(
                                        label: 'Compensation: \$',
                                        textBody:
                                            '${calculateRunnerFee(runModel.cost).toStringAsFixed(2)}'),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              'Customer: ',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          UserPhotoWidget(
                                            radius: 50,
                                            editable: false,
                                            borderWidth: 3,
                                            userId: runModel.customerId,
                                          ),
                                          SizedBox(width: 30),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: ButtonTheme(
                            minWidth: 140.0,
                            height: 40.0,
                            child: RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              icon: FaIcon(FontAwesomeIcons.check,
                                  color: Colors.white),
                              onPressed: () {
                                print("Accept run button is pressed");
                                BlocProvider.of<AcceptRunBloc>(context).add(
                                    AcceptRunButtonPressed(runModel: runModel));
                              },
                              label: Text('Accept Run',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLabelAndTextBody(
      {@required String label, @required String textBody}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Text(
              textBody,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Add calculation logic using distance, request load, etc.
double calculateRunnerFee(double totalCost) {
  return totalCost != null ? (1 / 5 * totalCost) : 0.0;
}
