import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_bloc.dart';
import 'package:hotfoot/features/location/presentation/bloc/location_event.dart';
import 'package:hotfoot/features/location/presentation/ui/location_form.dart';
import 'package:hotfoot/injection_container.dart';

class AddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => sl<LocationBloc>()..add(CurrentPlaceRequested()),
      child: Container(
        child: LocationForm(),
      ),
    );
  }
}
