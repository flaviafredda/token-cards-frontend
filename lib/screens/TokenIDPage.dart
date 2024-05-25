import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class TokenIDPage extends StatefulWidget {
  const TokenIDPage({Key? key}) : super(key: key);

  @override
  TokenIDPageState createState() => TokenIDPageState();
}

class TokenIDPageState extends State<TokenIDPage> {
  late String tokenID;

  @override
  void initState() {
    super.initState();
    tokenID = generateTokenID();
  }
    // Function to send a POST request to the server
  Future<bool> addToken(String tokenID) async {
    var url = Uri.parse('http://127.0.0.1:5000/add-token');
    try {

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'tokenID': tokenID}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to add token. Status code: ${response.statusCode}');
        return false;

      }
    } catch (e) {
      print('Error occurred: $e');
      return false;

    }
  }

  static String generateTokenID() {
    var random = Random.secure();
    var bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return sha256.convert(bytes).toString();
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
            QrImageView(
              data: tokenID,
              version: QrVersions.auto,
              size: 200.0,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Return to Home Page'),
            ),
            ElevatedButton(
              onPressed: () => showAlertDialog(context, addToken, tokenID),
              child: const Text('Accumulate TokenID'),
            ),
          ],
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context, Future<bool> Function(String) addTokenFunction, String tokenID) {
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
      bool success = await addTokenFunction(tokenID);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(success ? 'Token added successfully' : 'Failed to add token'),
        ),
      );
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Attention"),
    content: const Text("Would you like to accumulate this tokenID?"),
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