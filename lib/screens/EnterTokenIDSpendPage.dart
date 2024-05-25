import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert'; // Import Dart convert library

class EnterTokenIDSpendPage extends StatefulWidget {
  const EnterTokenIDSpendPage({Key? key}) : super(key: key);

  @override
  EnterTokenIDSpendPageState createState() => EnterTokenIDSpendPageState();
}

class EnterTokenIDSpendPageState extends State<EnterTokenIDSpendPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final tokenIDController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 150,
                      left: 20,
                      right: 20,
                      bottom:20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.height * 0.4,
                child: Card(
                  color: Colors.purple.shade200,
                  child: Column(
                children: <Widget> [ 
                  (result != null)
                    ? Text('Data: ${result!.code}')
                    : Padding(
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: 20.0) ,
                      child: TextField(
                        controller: tokenIDController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Enter TokenID Manually',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                  onPressed: () async { // Make the callback async
                    if (tokenIDController.text.isNotEmpty) {
                      // print('We send tokenID ${tokenIDController.text}');
                      BuildContext dialogContext = context;

                      // Await the result of sending the tokenID
                      bool result = await sendTokenID(tokenIDController.text);
                      if (mounted) {                     
                        showDialog(
                        context: dialogContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(result ? 'Success' : 'Error'),
                            content: Text(result 
                                ? 'The token has been spent successfully.' 
                                : 'Failed to spend the token.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      ); //showDialog
                      } //if
                    } // if
                  },
                    child: const Text('Spend the token'),
                ),
                ),
                ],
                ),
                ),
                    ),
                    ),
                  ),
                  Align(alignment: Alignment.center,
                  child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to Home Page'),
                ),
                ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    tokenIDController.dispose(); // Dispose the controller
    super.dispose();
  }

  Future<bool> sendTokenID(String? code) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/spend-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tokenID_spend': code!,
      }),
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add token. Status code: ${response.statusCode}');
      return false;
    }
  }
}