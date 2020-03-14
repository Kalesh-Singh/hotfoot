import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_bloc.dart';
import 'package:hotfoot/features/navigation_home/presentation/bloc/navigation_home_state.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/home_tab.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/orders_tab.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/search_tab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<NavigationHomeBloc, NavigationHomeState>(
          builder: (context, state) {
        switch (state.runtimeType) {
          case HomeIconTab:
            return HomeTab();
          case SearchIconTab:
            return SearchTab();
          case OrdersIconTab:
            return OrdersTab();
          default:
            return HomeTab();
        }
      }),
    );
  }
}
