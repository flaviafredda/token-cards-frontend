import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import Dart convert library

class ScanQRPageVerify extends StatefulWidget {
  const ScanQRPageVerify({Key? key}) : super(key: key);

  @override
  ScanQRPageVerifyState createState() => ScanQRPageVerifyState();
}

class ScanQRPageVerifyState extends State<ScanQRPageVerify> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
      ),
      body: Column(
        children: <Widget>[
          Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/TokenCardsLogo2.png', // Corrected path
            width: 400,
            fit: BoxFit.contain,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
        ),
            Container(
              height: 600, 
              child: QRView(
                key: qrKey,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: Colors.red,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ) ,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
              ],
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> sendQRCode(String? code) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/verification-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'qrCode': code!,
      }),
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Handle server response if needed
    } else {
      print('Failed to send QR code');
    }
  }
}