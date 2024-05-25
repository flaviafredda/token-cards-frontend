import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert'; // Import Dart convert library
import 'dart:io';


class SpendPage extends StatefulWidget {
  const SpendPage({Key? key}) : super(key: key);

  @override
  SpendPageState createState() => SpendPageState();
}

class SpendPageState extends State<SpendPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final tokenIDController = TextEditingController(); // Controller for the input form


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            flex: 1,
            child: Column(
              children: [
                (result != null)
                    ? Text('Data: ${result!.code}')
                    : TextField(
                        controller: tokenIDController,
                        decoration: const InputDecoration(
                          labelText: 'Enter TokenID Manually',
                          border: OutlineInputBorder(),
                        ),
                      ),
                ElevatedButton(
                  onPressed: () {
                    if (result != null) {
                      print('We send this ${result!.code}');
                      sendQRCode(result!.code);

                    } else if (tokenIDController.text.isNotEmpty) {
                      print('We send this ${tokenIDController.text}');
                      sendQRCode(tokenIDController.text);
                    }
                  },
            child: const Text('Send to Server'),
          ),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Return to Home Page'),
            ),
        ],
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
    tokenIDController.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<void> sendQRCode(String? code) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/spend-token'),
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