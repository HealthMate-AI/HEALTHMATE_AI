import 'package:flutter/material.dart';
import 'package:healthmate/homepage.dart';
import 'disease_service.dart';
import 'disease_symptoms.dart';
import 'disease_result_page.dart';

class DiseasePredictionPage extends StatefulWidget {
  const DiseasePredictionPage({super.key});

  @override
  _DiseasePredictionPageState createState() => _DiseasePredictionPageState();
}

class _DiseasePredictionPageState extends State<DiseasePredictionPage> {
  Map<String, int> selectedSymptoms = {};
  List<String> displayedSymptoms = [];
  String predictedDisease = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var symptom in allSymptoms) {
      selectedSymptoms[symptom] = 0;
    }
    displayedSymptoms = List.from(allSymptoms);
  }

  void filterSymptoms(String query) {
    setState(() {
      displayedSymptoms = allSymptoms
          .where((s) => s.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  bool get hasSelectedSymptoms => selectedSymptoms.containsValue(1);

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
          "Disease Prediction",
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF056443), Color(0xFF013924)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF00A57E), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x6600A57E),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search symptoms...",
                  hintStyle: const TextStyle(color: Colors.greenAccent),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF01D6A4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: filterSymptoms,
              ),
            ),
            const SizedBox(height: 10),

            // Symptoms List
            Expanded(
              child: ListView(
                children: displayedSymptoms.map((symptom) {
                  return CheckboxListTile(
                    tileColor: Colors.black,
                    activeColor: const Color(0xFF01D6A4),
                    checkColor: Colors.black,
                    title: Text(symptom,
                        style: const TextStyle(color: Colors.greenAccent)),
                    value: selectedSymptoms[symptom] == 1,
                    onChanged: (val) {
                      setState(() {
                        selectedSymptoms[symptom] = val! ? 1 : 0;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            // Predict Button
            GestureDetector(
              onTap: hasSelectedSymptoms
                  ? () async {
                      String result = await DiseaseService.predictDisease(
                          selectedSymptoms);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiseaseResultPage(
                            diseaseName: result,
                            selectedSymptoms: selectedSymptoms.entries
                                .where((entry) => entry.value == 1)
                                .map((entry) => entry.key)
                                .toList(),
                          ),
                        ),
                      );

                      setState(() {
                        predictedDisease = result;
                      });
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: hasSelectedSymptoms
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
                    "Predict Disease",
                    style: TextStyle(
                        color:
                            hasSelectedSymptoms ? Colors.white : Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
