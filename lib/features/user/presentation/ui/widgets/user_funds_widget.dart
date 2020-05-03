import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_funds/user_funds_state.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/add_funds_popup.dart';

class UserFundsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFundsBloc, UserFundsState>(
        builder: (BuildContext context, UserFundsState state) {
      BlocProvider.of<UserFundsBloc>(context).add(UserFundsRequested());
      double funds = 0.0;
      if (state is UserFundsLoaded) {
        funds = state.funds;
      }
      return Row(
        children: <Widget>[
          Expanded(
              child: Text(
            'Hotfoot Funds:',
            style: style.copyWith(fontSize: 16),
          )),
          Text('\$${funds.toStringAsFixed(2)}',
              style: style.copyWith(fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: GestureDetector(
              child: Icon(Icons.add_circle),
              onTap: () async {
                final addedFundsTextOrNull = await showDialog(
                    context: context,
                    builder: (_) {
                      return AddFundsPopUp();
                    });
                if (addedFundsTextOrNull != null &&
                    addedFundsTextOrNull != "") {
                  BlocProvider.of<UserFundsBloc>(context).add(UserFundsAdded(
                      addedFunds: double.parse(addedFundsTextOrNull)));
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
