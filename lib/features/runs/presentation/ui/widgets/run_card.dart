import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:hotfoot/features/runs/domain/entities/run_status.dart';
import 'package:hotfoot/src/utils/style.dart';
import 'package:intl/intl.dart';

class RunCard extends StatelessWidget {
  final RunEntity runEntity;
  final bool isRunner;
  final bool isPending;

  const RunCard({
    Key key,
    @required this.runEntity,
    @required this.isRunner,
    @required this.isPending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Run card tapped');
        print('isRunner: $isRunner');
        print('isPending: $isPending');
        if (isPending) {
          _acceptRun(context);
        } else if (!isRunner) {
          _showOrderAgainModal(context);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 140,
        width: double.maxFinite,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    runEntity.order,
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(runEntity.timePlaced), style: style.copyWith(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderAgainModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 140,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Text(
                        this.runEntity.order,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () => _cancelOrderAgain(context),
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () => _orderAgain(context),
                              child: Text('Order Again'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _orderAgain(BuildContext context) {
    final newRunModel = RunModel.empty().copyWith(
      // NOTE: runId must be [null] in order for the run to be
      // new and not update the old run.
      customerId: runEntity.customerId,
      destinationPlace: runEntity.destinationPlace,
      pickupPlaceIdOrCustomPlace: runEntity.pickupPlaceIdOrCustomPlace,
      order: runEntity.order,
      status: RunStatus.PENDING,
    );
    BlocProvider.of<NavigationScreenBloc>(context)
        .add(EnteredPurchaseFlow(runModel: newRunModel));
    Navigator.pop(context);
  }

  void _cancelOrderAgain(BuildContext context) {
    Navigator.pop(context);
  }

  void _acceptRun(BuildContext context) {
    BlocProvider.of<NavigationScreenBloc>(context)
        .add(EnteredAcceptRun(runModel: runEntity));
  }
}
