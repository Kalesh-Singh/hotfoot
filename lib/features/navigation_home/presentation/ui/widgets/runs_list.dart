import 'package:flutter/material.dart';

class RunsList extends StatelessWidget {
  final List<String> runsIds;

  const RunsList({Key key, this.runsIds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: runsIds.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(runsIds[index]),
        );
      },
    );
  }
}
