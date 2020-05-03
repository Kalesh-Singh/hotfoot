import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GiveRatingPopUp extends StatelessWidget {
  final bool isRunner;

  const GiveRatingPopUp({Key key, @required this.isRunner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _rating = 0.0;

    return AlertDialog(
      title: Text(
        'Rate the ${isRunner?'customer':'runner'}',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar(
            initialRating: _rating,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = rating;
              print("Rating selected: $_rating");
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(_rating),
            child: Text('Confirm')),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close')),
      ],
    );
  }
}
