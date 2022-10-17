
import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatefulWidget {
  static const String routeName = '/sucessful_page';

  @override
  State<OrderSuccessfulPage> createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Successful'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your order has been placed'),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text('Go back to Home'))
          ],
        ),
      ),
    );;
  }
}
