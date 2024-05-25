import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  final TextEditingController _controller = TextEditingController();
  late QRViewController _qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late String tokenID_verify;
    // Function to send a POST request to the server
  Future<bool> verificationToken(String tokenIDVerify) async {
    var url = Uri.parse('http://127.0.0.1:5000/verification-token');
    try {

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'tokenID': tokenIDVerify}),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
            bool success = responseBody['result'];
            return success;
          } else {
            print('Failed to verify token. Status code: ${response.statusCode}');
            return false;
          } 
      } catch (e) {
      print('Error occurred: $e');
      return false;

    }
  }
  
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          _controller.text = scanData.code ?? ""; // ?? "" provides a default value for scanData.code
          tokenID_verify = scanData.code ?? "";
          _qrController.pauseCamera();
        });
        showAlertDialogVerify(context, verificationToken, tokenID_verify);
      });
    });

    
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('TokenID'),
      ),

      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              height: 600, 
              child: QRView(key: qrKey,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    width: 300,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'TokenID',
                    ),
                  ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to Home Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Use the text from the controller
                    tokenID_verify = _controller.text;
                    showAlertDialogVerify(context, verificationToken, tokenID_verify);
                  },
                  child: const Text('Verify TokenID'),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );  
  }
}

void showAlertDialogVerify(BuildContext context, Future<bool> Function(String) verificationTokenFunction, String tokenID_verify) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("No"),
    onPressed:  () {
      Navigator.of(context).pop(); // Close the dialog
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes"),
    onPressed:  () async {
       // Store the ScaffoldMessengerState before the async operation
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop(); // Close the dialog
      bool verified = await verificationTokenFunction(tokenID_verify);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(verified ? 'Token belongs to this accumulator' : 'Token Error'),
        ),
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Attention"),
    content: const Text("Would you like to verify this tokenID?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class QRCodeScannerApp extends StatefulWidget {
  @override
  _QRCodeScannerAppState createState() => _QRCodeScannerAppState();
}

class _QRCodeScannerAppState extends State<QRCodeScannerApp> {
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan a QR code'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
      _controller.scannedDataStream.listen((scanData) {
        print('Scanned data: ${scanData.code}');
        // Handle the scanned data as desired
      });
    });
  }
}