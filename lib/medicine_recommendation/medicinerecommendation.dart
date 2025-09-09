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
  TextEditingController ageController = TextEditingController();

  List<String> recommendedMedicines = [];
  String errorMessage = "";
  String? correctedDisease;
  String? noteMessage; // ✅ new field
  bool isLoading = false;

  bool get isInputValid {
    String disease = diseaseController.text.trim();
    int age = int.tryParse(ageController.text.trim()) ?? 0;
    return disease.isNotEmpty && age > 0;
  }

  // Save recommendation to Firestore
  Future<void> saveRecommendation(String disease, String medicine) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("past_medicine_recommendations")
          .add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "diseaseName": disease, // ✅ corrected disease
        "medicineName": medicine,
        "timestamp": FieldValue.serverTimestamp(),
            "source": "app"

      });
    } catch (e) {
      print("Failed to save recommendation: $e");
    }
  }

  void getRecommendation() async {
    if (!isInputValid) return;

    setState(() {
      isLoading = true;
      recommendedMedicines = [];
      errorMessage = "";
      correctedDisease = null;
      noteMessage = null;
    });

    String disease = diseaseController.text.trim();
    int age = int.tryParse(ageController.text.trim()) ?? 0;

    final result = await MedicineService.getRecommendedMedicine(disease, age);

    setState(() {
      isLoading = false;

      if (result.error != null) {
        errorMessage = result.error!;
      } else if (result.note != null) {
        // ✅ show backend note if disease not found
        noteMessage = result.note;
      } else if (result.medicine != null) {
        recommendedMedicines = [result.medicine!];

        correctedDisease = result.correctedDisease;

        // ✅ Save only if a valid medicine exists
        String finalDisease = result.correctedDisease ?? disease;
        saveRecommendation(finalDisease, result.medicine!);
        if (!result.medicine!.toLowerCase().contains("error")) {
          String finalDisease = result.correctedDisease ?? disease;
          saveRecommendation(finalDisease, result.medicine!);
        } else {
          errorMessage = "No medicine found for this input";
        }
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            TextField(
              controller: diseaseController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter disease",
                hintStyle: const TextStyle(color: Colors.greenAccent),
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
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter age",
                hintStyle: const TextStyle(color: Colors.greenAccent),
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: isInputValid ? getRecommendation : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: isInputValid
                      ? const LinearGradient(
                          colors: [Color(0xFF056443), Color(0xFF013924)],
                        )
                      : const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                        ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF00A57E), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x6600A57E),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Get Recommendation",
                    style: TextStyle(
                        color: isInputValid ? Colors.white : Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) ...[
              const CircularProgressIndicator(color: Colors.greenAccent),
            ] else if (errorMessage.isNotEmpty) ...[
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (noteMessage != null) ...[
              Text(
                noteMessage!,
                style: const TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (recommendedMedicines.isNotEmpty) ...[
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
                  ),
                ),
              const Text(
                "Recommended Medicine:",
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...recommendedMedicines.map(
                (med) => ListTile(
                  leading: const Icon(Icons.medical_services,
                      color: Colors.greenAccent),
                  title: Text(
                    med,
                    style: const TextStyle(color: Colors.white70, fontSize: 19),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "⚠️ Note: Please consult a healthcare professional for personalized advice.",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
