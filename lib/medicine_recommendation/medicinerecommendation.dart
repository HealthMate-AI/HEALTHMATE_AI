import 'package:flutter/material.dart';
import 'package:healthmate/homepage.dart';
import 'medicine_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicineRecommendationPage extends StatefulWidget {
  final String username;
  final String email;
  const MedicineRecommendationPage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  _MedicineRecommendationPageState createState() =>
      _MedicineRecommendationPageState();
}

class _MedicineRecommendationPageState
    extends State<MedicineRecommendationPage> {
  TextEditingController diseaseController = TextEditingController();
  int age = 35; // Default age
  List<String> recommendedMedicines = [];
  String errorMessage = "";
  String? correctedDisease;
  String? noteMessage;
  bool isLoading = false;

  final List<String> conditions = [
    'Influenza (Flu)',
    'Migraine',
    'Hypertension (High Blood Pressure)',
  ];
  final List<String> tags = ['#Headache', '#Fever', '#Cough'];

  bool get isInputValid {
    return diseaseController.text.trim().isNotEmpty && age > 0;
  }

  Future<void> saveRecommendation(String disease, String medicine) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("past_medicine_recommendations")
          .add({
        "userId": user.uid,
        "diseaseName": disease,
        "medicineName": medicine,
        "timestamp": FieldValue.serverTimestamp(),
        "source": "app",
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to save recommendation: $e";
      });
    }
  }

  void getRecommendation() async {
    if (!isInputValid) {
      setState(() {
        errorMessage = "Please enter a valid condition and age.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      recommendedMedicines = [];
      errorMessage = "";
      correctedDisease = null;
      noteMessage = null;
    });

    String disease = diseaseController.text.trim();
    final result = await MedicineService.getRecommendedMedicine(disease, age);

    setState(() {
      isLoading = false;

      if (result.error != null) {
        errorMessage = result.error!;
      } else if (result.note != null) {
        noteMessage = result.note;
      } else if (result.medicine != null) {
        recommendedMedicines = [result.medicine!];
        correctedDisease = result.correctedDisease;
        String finalDisease = result.correctedDisease ?? disease;
        if (!result.medicine!.toLowerCase().contains("error")) {
          saveRecommendation(finalDisease, result.medicine!);
        } else {
          errorMessage = "No medicine found for this input.";
        }
      } else {
        errorMessage = "No recommendation available for the input.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF01D6A4)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => Homepage(
                  username: widget.username,
                  email: widget.email,
                ),
              ),
            );
          },
        ),
        title: const Text(
          "Medicine Recommendation",
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Tell Us About Yourself",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "This information helps us recommend the safest and most effective medicine.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "1. Your Age (Years)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: Color(0xFF01D6A4)),
                    onPressed: () {
                      setState(() {
                        if (age > 1) age--;
                      });
                    },
                  ),
                  Text(
                    '$age',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: Color(0xFF01D6A4)),
                    onPressed: () {
                      setState(() {
                        age++;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "2. Your Condition or Disease",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: diseaseController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type your condition (e.g., Flu, Migraine)",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF01D6A4)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00A57E)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF01D6A4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: tags
                    .map((tag) => Chip(
                          label: Text(tag,
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: const Color(0xFF00A57E),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isInputValid ? getRecommendation : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01D6A4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Find Recommendations",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Your data is safe and private.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent))
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (noteMessage != null)
                Center(
                  child: Text(
                    noteMessage!,
                    style: const TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (recommendedMedicines.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (correctedDisease != null &&
                        correctedDisease!.toLowerCase() !=
                            diseaseController.text.trim().toLowerCase())
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Did you mean: $correctedDisease?",
                          style: const TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const Text(
                      "Recommended Medicine:",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ...recommendedMedicines.map(
                      (med) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          color: const Color(0xFF00A57E),
                          child: ListTile(
                            leading: const Icon(Icons.medical_services,
                                color: Colors.white),
                            title: Text(
                              med,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "⚠️ Consult a doctor for personalized advice.",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
