import 'package:flutter/material.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:intl/intl.dart';

class RunCard extends StatelessWidget {
  final RunEntity runEntity;
  final bool isRunner;

  const RunCard({
    Key key,
    @required this.runEntity,
    @required this.isRunner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRunner ? null : () => _showOrderAgainModal(context),
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
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(runEntity.timePlaced),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showOrderAgainModal(BuildContext context) {
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
                              onPressed: () {},
                              child: Text('Cancel'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {},
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
}
