// lib/disease_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class to communicate with the Flask backend for disease prediction
class DiseaseService {
  // Base URL of your Flask backend
  static const String baseUrl = "http://127.0.0.1:5000";

  /// Predict disease based on selected symptoms.
  /// [symptomsMap] should be a map of symptom -> 1/0
  /// Example: {"anxiety and nervousness": 1, "depression": 0}
  /// Returns the predicted disease name as a string.
  static Future<String> predictDisease(Map<String, int> symptomsMap) async {
    try {
      final url = Uri.parse('$baseUrl/predict');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(symptomsMap),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend returns: {"disease": "Panic disorder"}
        return data['disease'] ?? 'Unknown';
      } else {
        print('Server error: ${response.statusCode}');
        return 'Error: Could not predict disease';
      }
    } catch (e) {
      print('Exception occurred: $e');
      return 'Error: Could not connect to server';
    }
  }
}
