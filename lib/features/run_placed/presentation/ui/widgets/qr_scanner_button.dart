import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_bloc.dart';
import 'package:hotfoot/features/run_placed/presentation/blocs/qr_code/qr_code_state.dart';

class QRScannerButton extends StatelessWidget {
  final QRCodeState qrCodeState;

  QRScannerButton({
    @required this.qrCodeState,
  }) : assert(qrCodeState != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCodeBloc, QRCodeState>(
      builder: (BuildContext context, QRCodeState state) {
        if (state is QRCodeLoadSuccess) {
          return ButtonTheme(
            minWidth: 140.0,
            height: 40.0,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              icon: FaIcon(FontAwesomeIcons.qrcode, color: Colors.white),
              onPressed: () async {
                print("QR Scanner button is pressed");
                try {
                  String qrScanResult = await FlutterBarcodeScanner.scanBarcode(
                      "#000000", "Cancel", true, ScanMode.QR);
                  print("Scanned QR = $qrScanResult");
                } catch (e) {
                  throw new Exception("Error scanning QRCode!");
                }
              },
              label: Text('Scan QR', style: TextStyle(color: Colors.white)),
              color: Colors.blue,
            ),
          );
        }
        return ButtonTheme(
          minWidth: 140.0,
          height: 40.0,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            icon: FaIcon(FontAwesomeIcons.qrcode, color: Colors.white),
            onPressed: null,
            label: Text('Scan QR', style: TextStyle(color: Colors.white)),
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
