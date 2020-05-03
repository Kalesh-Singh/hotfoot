import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_bloc.dart';
import 'package:hotfoot/features/places/presentation/blocs/place_photo/place_photo_state.dart';

class RunPhoto extends StatelessWidget {
  final PlaceEntity placeEntity;

  const RunPhoto({Key key, this.placeEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BlocBuilder<PlacePhotoBloc, PlacePhotoState>(
        builder: (BuildContext context, PlacePhotoState state) {
          if (state is PlacePhotoLoadSuccess) {
            final photoSize = state.placePhoto.lengthSync();
            print('PHOTO SIZE UI: $photoSize');
            final photoBytes = state.placePhoto.readAsBytesSync();
            return Image.memory(
              photoBytes,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.fill,
            );
          } else {
            return Image.asset(
              'assets/place-photo-placeholder.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.fill,
            );
          }
        },
      ),
    );
  }
}
