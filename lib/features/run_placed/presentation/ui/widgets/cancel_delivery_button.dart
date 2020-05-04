import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_bloc.dart';
import 'package:hotfoot/features/navigation_screen/presentation/bloc/navigation_screen_event.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/use_cases/update_or_insert_run.dart';
import 'package:hotfoot/features/runs/domain/entities/run_status.dart';

class CancelDeliveryButton extends StatelessWidget {
  final RunModel currRun;
  final UpdateOrInsertRun updateOrInsertRun;

  CancelDeliveryButton({
    @required this.currRun,
    @required this.updateOrInsertRun,
  })  : assert(currRun != null),
        assert(updateOrInsertRun != null);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 140.0,
      height: 40.0,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        icon: FaIcon(FontAwesomeIcons.windowClose, color: Colors.white),
        onPressed: () {
          print("Cancel delivery button is pressed");
          final returnVal =
              updateOrInsertRun(currRun.copyWith(status: RunStatus.CANCELLED));
          returnVal.then((val) {
            print(val.getOrElse(null).props);
          });
          BlocProvider.of<NavigationScreenBloc>(context).add(EnteredHome());
        },
        label: Text('Cancel Delivery',
            style: style.copyWith(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        color: Colors.redAccent,
      ),
    );
  }
}
