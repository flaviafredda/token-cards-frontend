import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import Dart convert library

class ScanQRSpendPage extends StatefulWidget {
  const ScanQRSpendPage({Key? key}) : super(key: key);

  @override
  ScanQRSpendPageState createState() => ScanQRSpendPageState();
}

class ScanQRSpendPageState extends State<ScanQRSpendPage> {
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