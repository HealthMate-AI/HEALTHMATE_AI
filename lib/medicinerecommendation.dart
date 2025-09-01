import 'package:flutter/material.dart';

class Medicinerecommendation extends StatelessWidget {
  const Medicinerecommendation({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Center(
            child: Text("Medicine Recommendation",
            style: TextStyle(color: Colors.white)),),
        ],
      ),
    );
  }
}