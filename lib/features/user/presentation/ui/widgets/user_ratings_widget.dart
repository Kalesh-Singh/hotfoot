import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotfoot/core/style/style.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_bloc.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_event.dart';
import 'package:hotfoot/features/user/presentation/blocs/user_ratings/user_ratings_state.dart';

class UserRatingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserRatingsBloc, UserRatingsState>(
        builder: (BuildContext context, UserRatingsState state) {
      BlocProvider.of<UserRatingsBloc>(context).add(UserRatingsRequested());
      return Row(
        children: <Widget>[
          Expanded(
              child: Text(
            'Rating: ',
            style: style.copyWith(fontSize: 16),
          )),
          RatingBar(
            initialRating:
                state is UserRatingsLoaded ? state.customerRating : 0.0,
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
        ],
      );
    });
  }
}
