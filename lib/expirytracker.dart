import 'package:flutter/material.dart';

class Expirytracker extends StatelessWidget {
  const Expirytracker({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Center(
            child: Text("Medicine Expiry Tracker",
            style: TextStyle(color: Colors.white)),),
        ],
      ),
    );
  }
}