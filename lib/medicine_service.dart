import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicineService {
  static const String baseUrl = "http://127.0.0.1:5001"; // match Flask port

  static Future<String> getRecommendedMedicine(String disease, int age) async {
    try {
      final url = Uri.parse('$baseUrl/recommend');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"disease": disease, "age": age}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['recommended_medicine'] ?? "No medicine found";
      } else {
        return "Error: Could not fetch medicines";
      }
    } catch (e) {
      return "Error: Could not connect to server";
    }
  }
}
