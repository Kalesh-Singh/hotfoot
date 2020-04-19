import 'package:flutter/material.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome()),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Container(
            child: Center(
              child: Text('TODO: Accept run screen @zaykha'),
            ),
          ),
        ),
      ),
    );
  }
}
