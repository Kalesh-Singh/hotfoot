import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_event.dart';
import 'package:hotfoot/injection_container.dart';

class AcceptRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final runModel = navScreenBloc.state.runModel;
    final acceptRunBloc = sl<AcceptRunBloc>();
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
              // TODO: Finish the page design.
              child: ButtonTheme(
                minWidth: 140.0,
                height: 40.0,
                child: RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  icon: FaIcon(FontAwesomeIcons.check, color: Colors.white),
                  onPressed: () {
                    print("Accept run button is pressed");
                    acceptRunBloc
                        .add(AcceptRunButtonPressed(runModel: runModel));
                    navScreenBloc.add(
                      EnteredRunPlaced(
                        runModel: runModel,
                        isRunner: true,
                      ),
                    );
                  },
                  label:
                      Text('Accept Run', style: TextStyle(color: Colors.white)),
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
