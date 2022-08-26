import 'package:flutter/material.dart';
import 'package:polysleeper/models/sleep.dart';

class Sleepdetailpage extends StatelessWidget {
  const Sleepdetailpage({Key? key, required SleepModel sleep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("No errore")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
