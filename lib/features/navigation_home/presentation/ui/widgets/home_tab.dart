import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/location/presentation/ui/address_widget.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/places/presentation/blocs/places_ids/places_ids_bloc.dart';
import 'package:hotfoot/features/places/presentation/ui/widgets/place_list.dart';
import 'package:hotfoot/injection_container.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlacesIdsBloc>(
          create: (context) => sl<PlacesIdsBloc>(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => sl<LocationBloc>()..add(CurrentPlaceRequested()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Popular Near You'),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .add(EnteredSettings());
                  },
                  child: Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(
          children: <Widget>[
            AddressWidget(),
            Expanded(child: PlacesList()),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
