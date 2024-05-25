import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert'; // Import Dart convert library

class TokenIDPageRSA extends StatefulWidget {
  const TokenIDPageRSA({Key? key}) : super(key: key);

  @override
  TokenIDPageRSAState createState() => TokenIDPageRSAState();
}

class TokenIDPageRSAState extends State<TokenIDPageRSA> {
  String _tokenID = '';

  @override
  void initState() {
    super.initState();
    requestToken();
  }

// Function to request tokenID from the server 
Future<void> requestToken() async {
  var url = Uri.parse('http://127.0.0.1:5000/generate-token');
  try {
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var tokenID = data['tokenID']; // Assuming 'tokenID' is the key in the JSON response
      setState(() {
        _tokenID = tokenID; // No need to convert to int and back to String
      });
    } else {
      print('Server error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  // Function to send tokenID back to the server for accumulation
  Future<bool> accumulateToken(String tokenID) async {
  var url = Uri.parse('http://127.0.0.1:5000/accumulate-token');
  try {
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'tokenID': tokenID}), // Send tokenID as received
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Token ID Page'),
      ),
      body: Column(
        children: <Widget> [
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
          Align(
            alignment: Alignment.center,
        child: Card(
          color: Colors.purple.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add some padding around the contents
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use min to fit the content inside the card
                children: <Widget>[
                  _tokenID.isEmpty 
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 300.0,
                      height: 300.0,
                      child: QrImageView(
                        data: _tokenID,
                        version: QrVersions.auto,
                      ),
                  ),
                  const SizedBox(height: 16), // Provides spacing between the QR code and the button
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () => showAlertDialog(context, accumulateToken, _tokenID),
                        child: const Text('Accumulate TokenID'),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Return to Home Page'),
                  ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

void showAlertDialog(BuildContext context, Future<bool> Function(String) accumulateTokenFunction, String tokenID) {
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
      bool success = await accumulateTokenFunction(tokenID);
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
