import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_handler_screen/search_handler_screen_state.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/unknown_place_screen/unknown_place_screen_bloc.dart';
import 'package:hotfoot/features/search/presentation/ui/screens/search_handler_screen.dart';
import 'package:hotfoot/features/search/presentation/ui/screens/unknown_place_screen.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_bottom_drawer.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_map.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_bar.dart';

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ResultsWithMatchingAddressBloc>(
          create: (context) => sl<ResultsWithMatchingAddressBloc>(),
        ),
        BlocProvider<SearchMapBloc>(
          create: (context) => sl<SearchMapBloc>(),
        ),
        BlocProvider<DrawerContentsBloc>(
          create: (context) => sl<DrawerContentsBloc>(),
        ),
        BlocProvider<SearchHandlerScreenBloc>(
          create: (context) => sl<SearchHandlerScreenBloc>(),
        ),
        BlocProvider<UnknownPlaceScreenBloc>(
          create: (context) => sl<UnknownPlaceScreenBloc>(),
        ),
      ],
      child: BlocBuilder<SearchHandlerScreenBloc, SearchHandlerScreenState>(
          builder: (context, state) {
        if (state is SearchHandlerScreenOpened) {
          return SearchHandlerScreen();
        } else if (state is ManuallyLocateScreenOpened) {
          return UnknownPlaceScreen();
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: <Widget>[
                SearchMap(),
                SearchBar(),
                SearchBottomDrawer(),
              ],
            ),
            bottomNavigationBar: BottomNavBar(),
          );
        }
      }),
    );
  }
}
