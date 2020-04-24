import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/cancel_delivery_button.dart';
import 'package:hotfoot/features/run_placed/presentation/ui/widgets/open_close_chat_button.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/get_run_stream.dart';
import 'package:hotfoot/injection_container.dart';

class ActiveRunInfoWidget extends StatefulWidget {
  final RunModel runModel;

  const ActiveRunInfoWidget({@required this.runModel});

  @override
  _ActiveRunInfoWidgetState createState() => _ActiveRunInfoWidgetState();
}

class _ActiveRunInfoWidgetState extends State<ActiveRunInfoWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: Wrap in Run Update Bloc Builder
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${this.widget.runModel.status}", style: TextStyle(fontSize: 24.0)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CancelDeliveryButton(currRun: this.widget.runModel, updateOrInsertRun: sl()),
            OpenCloseChatButton(runModel: this.widget.runModel, buttonText: 'Contact Runner'),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _listenForRunUpdates();
  }

  void _listenForRunUpdates() async {
    final runId =
        BlocProvider.of<NavigationScreenBloc>(context).state.runModel.id;
    final runStream = await _getRunStream(
      getRunStream: sl<GetRunStream>(),
      runId: runId,
    );
    runStream.listen(_handleRunUpdate);
  }

  Future<Stream<QuerySnapshot>> _getRunStream({
    @required GetRunStream getRunStream,
    @required String runId,
  }) async {
    final runStreamEither = await getRunStream(runId);
    return runStreamEither.fold(
      (_) => null,
      (runStream) => runStream,
    );
  }

  void _handleRunUpdate(QuerySnapshot querySnapshot) {
    // TODO: Pass Run Model to Run Updated Event
    print('RUN DOCUMENT CHANGED');
    RunModel runModel;
    querySnapshot.documents.forEach((DocumentSnapshot documentSnapshot) {
      documentSnapshot.data.forEach((k, v) {
        print("$k: $v");
      });
      runModel = RunModel.fromJson(documentSnapshot.data);
    });
    // TODO: Pass run model to the bloc.
  }
}
