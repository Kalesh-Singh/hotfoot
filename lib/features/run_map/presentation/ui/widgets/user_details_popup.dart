import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_bloc.dart';
import 'package:hotfoot/features/run_map/presentation/blocs/other_user_details/other_user_details_state.dart';
import 'package:hotfoot/features/user/data/models/user_model.dart';
import 'package:hotfoot/features/user/domain/entities/user_entity.dart';
import 'package:hotfoot/features/user/presentation/ui/widgets/user_photo_widget.dart';
import 'package:hotfoot/features/user/domain/entities/ratings_entity.dart';

class UserDetailsPopUp extends StatelessWidget {
  final UserType userType;

  const UserDetailsPopUp({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherUserDetailsBloc, OtherUserDetailsState>(
        builder: (BuildContext context, OtherUserDetailsState state) {
      final bool isRunner = userType == UserType.RUNNER;
      return AlertDialog(
        title: Text(
          '${isRunner ? 'Customer' : 'Runner'} Details',
          textAlign: TextAlign.center,
        ),
        content: _showUserDetails(isRunner, state),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close')),
        ],
      );
    });
  }

  Widget _showUserDetails(bool currUserIsRunner, OtherUserDetailsState state) {
    if (state is OtherUserDetailsLoaded) {
      UserModel otherUserModel = state.otherUserModel;
      print("Here");
      print("Here2");
      print("Here23");
      print("OtherUserModel = $otherUserModel");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: UserPhotoWidget(
              userId: otherUserModel.id,
              borderWidth: 3,
              radius: 50,
              editable: false,
            ),
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(' Name: '),
              Expanded(
                child: Text(otherUserModel.name),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text('Rating: '),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RatingBar(
                    initialRating: _displayRating(
                        currUserIsRunner: currUserIsRunner,
                        otherUserRatings: otherUserModel.ratings),
                    ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.3),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    } else {
      return Text("Details not available...");
    }
  }

  double _displayRating({
    @required bool currUserIsRunner,
    @required RatingsEntity otherUserRatings,
  }) {
    if (otherUserRatings != null) {
      if (currUserIsRunner) {
        return otherUserRatings.customerRating;
      }
      return otherUserRatings.runnerRating;
    }
    return 0.0;
  }
}
