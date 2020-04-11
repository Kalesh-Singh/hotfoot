import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_results_list.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/bottom_nav_bar.dart';
import 'package:hotfoot/features/search/presentation/blocs/matching_addresses/matching_addresses_bloc.dart';
import 'package:hotfoot/features/search/presentation/ui/widgets/search_bar.dart';

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MatchingAddressesBloc>(
            create: (context) => sl<MatchingAddressesBloc>(),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
          ),
          body: Column(
            children: <Widget>[
              SearchBar(),
              Expanded(child: SearchResultsList()),
            ],
          ),
          bottomNavigationBar: BottomNavBar(),
        ));
  }
}
