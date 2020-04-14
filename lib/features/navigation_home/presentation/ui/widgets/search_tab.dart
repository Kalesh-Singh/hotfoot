import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
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
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              SearchMap(),
              SearchBar(),
              SearchBottomDrawer(),
            ],
          ),
          bottomNavigationBar: BottomNavBar(),
        ));
  }
}
