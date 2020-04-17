import 'package:flutter/material.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:intl/intl.dart';

class RunCard extends StatelessWidget {
  final RunEntity runEntity;

  const RunCard({Key key, this.runEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
