import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_event.dart';
import 'package:hotfoot/features/runs/presentation/ui/widgets/run_form.dart';
import 'package:hotfoot/injection_container.dart';

class RunDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    print('FROM NAV BLOC');
    print(json.encode(navScreenBloc.state.runModel.toJson()));

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
          title: const Text('Run Details'),
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
          child: GestureDetector(
            // Hide keyboard
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SafeArea(
              child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
                builder: (BuildContext context, PlaceDetailsState state) {
                  if (state is PlaceDetailsUninitialized) {
                    final pickUpEither =
                        navScreenBloc.state.runModel.pickupPlaceIdOrCustomPlace;
                    pickUpEither?.fold(
                      (pickupPlaceId) {
                        BlocProvider.of<PlaceDetailsBloc>(context)
                            .add(PlaceDetailsRequested(placeId: pickupPlaceId));
                      },
                      (customPlace) {
                        // TODO: Handle event for CustomPlace
                        BlocProvider.of<PlaceDetailsBloc>(context).add(
                            CustomPlaceDetailsReceived(
                                placeEntity: customPlace));
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
                    return RunForm(
                      placeEntity: placeEntity,
                      initialOrder: navScreenBloc.state.runModel.order,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
