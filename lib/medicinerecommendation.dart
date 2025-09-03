import 'package:flutter/material.dart';
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
        const SnackBar(content: Text("Please enter valid disease and age")),
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
        title: const Text(
          "Medicine Recommendation",
          style: TextStyle(color: Colors.greenAccent),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: diseaseController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter disease",
                hintStyle: TextStyle(color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter age",
                hintStyle: TextStyle(color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getRecommendation,
              child: const Text("Get Recommendation"),
            ),
            const SizedBox(height: 20),
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
                    title: Text(med,
                        style: const TextStyle(color: Colors.white70)),
                  )),
            ]
          ],
        ),
      ),
    );
  }
}
