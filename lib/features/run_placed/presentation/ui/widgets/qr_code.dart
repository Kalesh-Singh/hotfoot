import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCodeBloc, QRCodeState>(
        builder: (BuildContext context, QRCodeState state) {
          if (state is QRCodeLoadSuccess) {
            return GestureDetector(
              onTap: () {
                // TODO: Maybe enlarge the QR code
                print("Your QR Code is = ${state.ownQRCode}");
                print("Counterpart QR Code is = ${state.counterpartQRCode}");
              },
              child: QrImage(
                data: state.ownQRCode,
                size: 130,
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
            ),
            width: 130,
            height: 130,
            child: Align(
              alignment: Alignment.center,
              child: Text("Code not ready yet"),
            ),
          );
        });
  }
}
