// lib/disease_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DiseaseService {
  // Base URL of your Flask backend
  static const String baseUrl = "http://10.254.219.151:5000";

  /// Predict disease based on selected symptoms.
  /// [symptomsMap] should be a map of symptom -> 1/0
  /// Example: {"anxiety and nervousness": 1, "depression": 0}
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
        // Assuming your backend returns: {"predicted_disease": "anxiety"}
        return data['predicted_disease'] ?? 'Unknown';
      } else {
        // Server responded with an error
        print('Server error: ${response.statusCode}');
        return 'Error: Could not predict disease';
      }
    } catch (e) {
      // Exception (e.g., no connection)
      print('Exception occurred: $e');
      return 'Error: Could not connect to server';
    }
  }
}
