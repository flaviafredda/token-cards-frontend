import 'package:flutter/material.dart';
import 'package:token_cards_first/screens/TokenIDRSAPage.dart';
import 'package:token_cards_first/screens/dialog_helper_spend.dart';
import 'package:token_cards_first/screens/dialog_helper_verify.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Token Cards First',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

//Home Page
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('TokenCards'),
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
        Card(
            color: Colors.purple.shade200,
            child: Padding(
              padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TokenIDPageRSA()),
                    ),
                    child: const Text('New tokenID'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => DialogHelperVerify.showChoiceDialog(context),
                    child: const Text('Verify a token'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () => DialogHelperSpend.showChoiceDialog(context),
                    child: const Text('Spend a token'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: const Text('Publish on the blockchain'),
                  ),
                ),
              ],
            ),
            ),
          ),
      ],
        ),
      );

  }
}

