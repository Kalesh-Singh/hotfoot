import 'package:flutter/material.dart';
import 'package:hotfoot/features/navigation_home/presentation/ui/widgets/run_list_tile.dart';

class RunsList extends StatelessWidget {
  final List<String> runsIds;
  final bool isRunner;

  const RunsList({
    Key key,
    @required this.runsIds,
    @required this.isRunner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: runsIds.length,
      itemBuilder: (context, index) {
        return RunListTile(
          runId: runsIds[index],
          isRunner: isRunner,
        );
      },
    );
  }
}
