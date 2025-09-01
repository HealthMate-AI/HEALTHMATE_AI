import 'package:flutter/material.dart';

class Firstaidguide extends StatelessWidget {
  const Firstaidguide({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Center(
            child: Text("First Aid Guide",
            style: TextStyle(color: Colors.white)),),
        ],
      ),
    );
  }
}