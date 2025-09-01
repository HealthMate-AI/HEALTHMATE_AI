import 'package:flutter/material.dart';

class Intakereminder extends StatelessWidget {
  const Intakereminder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Center(
            child: Text("Medicine Intake Reminder",
            style: TextStyle(color: Colors.white)),),
        ],
      ),
    );
  }
}