import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DiseasePredictionPage extends StatefulWidget {
  const DiseasePredictionPage({super.key});

  @override
  State<DiseasePredictionPage> createState() => _DiseasePredictionPageState();
}

class _DiseasePredictionPageState extends State<DiseasePredictionPage> {
  // Symptoms list
  final Map<String, int> _symptoms = {
    "fever": 0,
    "cough": 0,
    "fatigue": 0,
    "headache": 0,
    "nausea": 0,
    "vomiting": 0,
    "sore_throat": 0,
    "runny_nose": 0,
    "chest_pain": 0,
    "diarrhea": 0,
  };

  String _prediction = ""; // Display prediction
  bool _loading = false;

  // Function to send data to Flask API
  Future<void> _getPrediction() async {
    setState(() {
      _loading = true;
      _prediction = "";
    });

    try {
final url = Uri.parse('http://10.0.2.2:5000/predict');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_symptoms),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _prediction = data['prediction'];
        });
      } else {
        setState(() {
          _prediction = "Error: Failed to get prediction";
        });
      }
    } catch (e) {
      setState(() {
        _prediction = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disease Prediction"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select symptoms you have:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _symptoms.keys.map((symptom) {
                  return SwitchListTile(
                    title: Text(symptom.replaceAll('_', ' ').toUpperCase()),
                    value: _symptoms[symptom]! == 1,
                    onChanged: (val) {
                      setState(() {
                        _symptoms[symptom] = val ? 1 : 0;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _getPrediction,
                    child: const Text("Predict Disease"),
                  ),
            const SizedBox(height: 20),
            if (_prediction.isNotEmpty)
              Text(
                "Predicted Disease: $_prediction",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
