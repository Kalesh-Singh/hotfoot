import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_bloc.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_state.dart';
import 'package:hotfoot/features/runs/presentation/blocs/accept_run/accept_run_event.dart';
import 'package:hotfoot/injection_container.dart';

class AcceptRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final runModel = navScreenBloc.state.runModel;
    return BlocProvider(
      create: (context) => sl<AcceptRunBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Run Details'),
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
            child: BlocBuilder<AcceptRunBloc, AcceptRunState>(
              builder: (BuildContext context, AcceptRunState state){
                if (state is AcceptRunSuccess) {
                  BlocProvider.of<NavigationScreenBloc>(context).add(EnteredRunPlaced(runModel: runModel, isRunner: true));
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300,
                          width: double.maxFinite,
                          child: Card(
                            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 28.0,),
                                  Text("Maybe image of restaurant here?", 
                                    style: TextStyle(
                                      fontSize: 18, 
                                      color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 18.0,),
                                  Text(runModel.destinationPlace.address, 
                                    style: TextStyle(
                                      fontSize: 18, 
                                      color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 18.0,),
                                  Text(
                                    runModel.order,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.0,),
                        Center(
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
                                BlocProvider.of<AcceptRunBloc>(context).add(AcceptRunButtonPressed(runModel: runModel));
                              },
                              label:
                                  Text('Accept Run', style: TextStyle(color: Colors.white)),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                      ],
                    )
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}