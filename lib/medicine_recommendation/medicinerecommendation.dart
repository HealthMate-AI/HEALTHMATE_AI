import 'package:flutter/material.dart';
import 'package:healthmate/homepage.dart';
import 'medicine_service.dart';

class MedicineRecommendationPage extends StatefulWidget {
  const MedicineRecommendationPage({super.key});

  @override
  _MedicineRecommendationPageState createState() =>
      _MedicineRecommendationPageState();
}

class _MedicineRecommendationPageState
    extends State<MedicineRecommendationPage> {
  TextEditingController diseaseController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<String> recommendedMedicines = [];
  bool isLoading = false;

  void getRecommendation() async {
    String disease = diseaseController.text.trim();
    int age = int.tryParse(ageController.text.trim()) ?? 0;

    if (disease.isEmpty || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid disease and age"),
          backgroundColor: Colors.red, // Red background for error
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      recommendedMedicines = [];
    });

    String medicine =
        await MedicineService.getRecommendedMedicine(disease, age);

    setState(() {
      recommendedMedicines = [medicine];
      isLoading = false;
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
              MaterialPageRoute(builder: (_) => const Homepage()),
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
            // Disease TextField
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
            ),
            const SizedBox(height: 16),

            // Age TextField
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
            ),
            const SizedBox(height: 20),

            // Get Recommendation Button with gradient
            GestureDetector(
              onTap: getRecommendation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF056443), Color(0xFF013924)],
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
                child: const Center(
                  child: Text(
                    "Get Recommendation",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recommended Medicines Display
            if (isLoading) ...[
              const CircularProgressIndicator(color: Colors.greenAccent),
            ] else if (recommendedMedicines.isNotEmpty) ...[
              const Text(
                "Recommended Medicines:",
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...recommendedMedicines.map((med) => ListTile(
                    leading: const Icon(Icons.medical_services,
                        color: Colors.greenAccent),
                    title: Text(med, style: const TextStyle(color: Colors.white70)),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}
