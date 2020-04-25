import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/run_update/run_update_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/accept_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/active_run_info_widget.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/cancel_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/open_close_chat_button.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_type/user_type_state.dart';
import 'package:hotfoot/injection_container.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';

class RunPlacedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navScreenBloc = BlocProvider.of<NavigationScreenBloc>(context);
    final currRun = navScreenBloc.state.runModel;
    final bool isRunner =
    BlocProvider.of<UserTypeBloc>(context).state is RunnerUserType;
    final json1 = json.encode(currRun.toJson());
    print('FROM NAV BLOC');
    print(json1);
    return isRunner
        ? _runnerRunPlacedScreen(context, currRun)
        : _customerRunPlacedScreen(context, currRun);
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
      body: BlocProvider<RunUpdateBloc>(
        create: (context) => sl<RunUpdateBloc>(),
        child: SingleChildScrollView(
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
              ActiveRunInfoWidget(runModel: currRun),
            ],
          ),
        ),
      ),
    );
  }

}
