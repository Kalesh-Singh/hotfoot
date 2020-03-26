import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_details/place_details_state.dart';

class PlaceCard extends StatelessWidget {
  final PlaceEntity placeEntity;

  const PlaceCard({Key key, this.placeEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 140,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,

              child: Image.asset('assets/place-photo-placeholder.png'),
//              child: BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
//                builder: (BuildContext context, PlaceDetailsState state) {
//                  if (state is PlacePhotoLoadSuccess) {
//                    return Image.file(state.placePhoto);
//                  } else {
//                    return Image.asset('assets/place-photo-placeholder.png');
//                  }
//                },
//              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text(placeEntity.name)),
                    Expanded(child: Text(placeEntity.address)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
