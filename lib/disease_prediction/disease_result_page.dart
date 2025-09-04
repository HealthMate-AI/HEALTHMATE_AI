import 'package:flutter/material.dart';
import 'disease_data.dart';

class DiseaseResultPage extends StatelessWidget {
  final String diseaseName;
  final List<String> selectedSymptoms;

  const DiseaseResultPage({
    super.key,
    required this.diseaseName,
    required this.selectedSymptoms,
  });

  @override
  Widget build(BuildContext context) {
    // Match disease name in lowercase since your disease_data keys are lowercase
    final diseaseInfo = diseaseData[diseaseName.toLowerCase()] ?? {
      "details": "No details available for this disease.",
      "precautions": ["No precautions available."]
    };

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Prediction Result",
          style: TextStyle(color: Colors.greenAccent,fontSize: 24),
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
              Text(
                "Predicted Disease:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                diseaseName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 20),

              // Symptoms
              Text(
                "Your Symptoms:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10,),
              Wrap(
                spacing: 8,
                children: selectedSymptoms
                    .map((symptom) => Chip(
                          label: Text(symptom),
                          backgroundColor: const Color(0xFF056443),
                          labelStyle: const TextStyle(color: Colors.white),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Disease Details
              Text(
                "Disease Details:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10,),
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
              Text(
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
