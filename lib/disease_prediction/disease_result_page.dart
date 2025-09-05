import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'disease_data.dart';

class DiseaseResultPage extends StatefulWidget {
  final String diseaseName;
  final List<String> selectedSymptoms;

  const DiseaseResultPage({
    super.key,
    required this.diseaseName,
    required this.selectedSymptoms,
  });

  @override
  State<DiseaseResultPage> createState() => _DiseaseResultPageState();
}

class _DiseaseResultPageState extends State<DiseaseResultPage> {
  @override
  void initState() {
    super.initState();
    savePastPrediction();
  }

  Future<void> savePastPrediction() async {
    final diseaseInfo = diseaseData[widget.diseaseName.toLowerCase()] ?? {
      "details": "No details available for this disease.",
      "precautions": ["No precautions available."]
    };

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection("past_disease_predictions").add({
      "userId": currentUserId,
      "diseaseName": widget.diseaseName,
      "details": diseaseInfo["details"],
      "precautions": diseaseInfo["precautions"],
      "symptoms": widget.selectedSymptoms,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final diseaseInfo = diseaseData[widget.diseaseName.toLowerCase()] ?? {
      "details": "No details available for this disease.",
      "precautions": ["No precautions available."]
    };

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Prediction Result",
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF01D6A4)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disease Name
              const Text(
                "Predicted Disease:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.diseaseName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Symptoms
              const Text(
                "Your Symptoms:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
  spacing: 8,
  children: widget.selectedSymptoms
      .map((symptom) => Chip(
            label: Text(
              symptom,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF056443),
          ))
      .toList(),
),
              const SizedBox(height: 20),

              // Disease Details
              const Text(
                "Disease Details:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                diseaseInfo["details"],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Precautions
              const Text(
                "Precautions:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              ...List.generate(
                (diseaseInfo["precautions"] as List).length,
                (index) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    diseaseInfo["precautions"][index],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  tileColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
