import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicineService {
  static const String baseUrl = "http://127.0.0.1:5001"; // Flask server URL

  static Future<List<String>> getRecommendedMedicine(String disease, int age) async {
    try {
      final url = Uri.parse('$baseUrl/recommend');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"disease": disease, "age": age}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("recommended_medicine")) {
          // Always return as a List<String>
          final result = data["recommended_medicine"];
          if (result is List) {
            return result.map<String>((e) => e.toString()).toList();
          } else {
            return [result.toString()];
          }
        } else {
          return ["No medicine found for this input"];
        }
      } else {
        return ["Error ${response.statusCode}: ${response.reasonPhrase}"];
      }
    } catch (e) {
      return ["Error: Could not connect to server ($e)"];
    }
  }
}
