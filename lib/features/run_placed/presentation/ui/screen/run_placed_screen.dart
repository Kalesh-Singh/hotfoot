import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/ui/widgets/fire_map.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/accept_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/cancel_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/open_close_chat_button.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_stream.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';

class RunPlacedScreen extends StatelessWidget {
  Stream<QuerySnapshot> returnCurrentRunStream(
      GetRunStream useCase, String id) async* {
    final runStreamEither = await useCase(id);
    if (runStreamEither.isRight()) {
      yield* runStreamEither.getOrElse(null);
    }
  }

  Widget _runnerRunPlacedScreen(BuildContext context, RunModel currRun) {
    return Scaffold(
      appBar: AppBar(title: Text('Run Status')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LinearProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                  child: Text("Live map being updated here",
                      style: TextStyle(fontSize: 24.0))),
              color: Colors.lightGreenAccent,
            ),
            SizedBox(height: 20),
            Row(
              // Should use this here so formatting stays similar across
              // all screen sizes
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 40),
                Text("Status", style: TextStyle(fontSize: 24.0)),
                SizedBox(width: 110),
                OpenCloseChatButton(
                    runModel: currRun, buttonText: 'Contact Customer'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CancelDeliveryButton(currRun: currRun, updateOrInsertRun: sl()),
                AcceptDeliveryButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _customerRunPlacedScreen(BuildContext context, RunModel currRun) {
    return Scaffold(
      appBar: AppBar(title: Text('Run Status')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LinearProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
//              child: Center(
//                  child: Text("Live map being updated here",
//                      style: TextStyle(fontSize: 24.0))),
//              color: Colors.lightGreenAccent,
              child: FireMap(),
            ),
            SizedBox(height: 20),
            Row(
              // Should use this here so formatting stays similar across
              // all screen sizes
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 40),
                Text("Status", style: TextStyle(fontSize: 24.0)),
                SizedBox(width: 110),
                OpenCloseChatButton(
                    runModel: currRun, buttonText: 'Contact Runner'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CancelDeliveryButton(currRun: currRun, updateOrInsertRun: sl()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final currRun = navScreenBloc.state.runModel;
    final GetRunStream getRunStream = sl();
    final bool isRunner =
        BlocProvider.of<UserTypeBloc>(context).state is RunnerUserType;
    final json1 = json.encode(currRun.toJson());
    print('FROM NAV BLOC');
    print(json1);
    final runStream = returnCurrentRunStream(getRunStream, currRun.id);
    return Container(
      child: StreamBuilder(
          stream: runStream,
          builder: (context, snapshot) {
            print("Isrunner variable is $isRunner");
            return isRunner
                ? _runnerRunPlacedScreen(context, currRun)
                : _customerRunPlacedScreen(context, currRun);
          }),
    );
  }
}
