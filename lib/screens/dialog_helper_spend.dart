import 'package:flutter/material.dart';
import 'package:token_cards_first/screens/ScanQRSpendPage.dart';
import 'package:token_cards_first/screens/EnterTokenIDSpendPage.dart';

class DialogHelperSpend {
  static void showChoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
  TextButton(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white, // Text Color
      backgroundColor: Colors.purple.shade400, // Button Background Color
      padding: const EdgeInsets.all(16), // Button Padding
    ),
    onPressed: () {
      // Close the dialog
      Navigator.of(context).pop();
      // Navigate to the QR code scan page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanQRSpendPage()),
      );
    },
    child: const Text("Scan a token's QR code"),
  ),
  const Padding(padding: EdgeInsets.all(8.0)), // You might not need this if using buttons
  TextButton(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white, // Text Color
      backgroundColor: Colors.purple.shade400, // Button Background Color
      padding: const EdgeInsets.all(16), // Button Padding
    ),
    onPressed: () {
      // Close the dialog
      Navigator.of(context).pop();
      // Navigate to the page to enter the tokenID manually
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EnterTokenIDSpendPage()),
      );
    },
    child: const Text("Enter the tokenID manually"),
  ),
],

          ),
        );
      },
    );
  }
}
