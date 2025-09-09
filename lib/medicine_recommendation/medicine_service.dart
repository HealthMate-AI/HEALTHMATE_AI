import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicineService {
  static const String baseUrl = "http://127.0.0.1:5001"; // Flask backend URL

  static Future<MedicineResponse> getRecommendedMedicine(
      String disease, int age) async {
    try {
      final url = Uri.parse('$baseUrl/recommend');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"disease": disease, "age": age}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return MedicineResponse(
          medicine: data["recommended_medicine"]?.toString(),
          correctedDisease: data["corrected_disease"]?.toString(),
          note: data["note"]?.toString(), // ✅ include note
        );
      } else {
        return MedicineResponse(
          error: "Error ${response.statusCode}: ${response.reasonPhrase}",
        );
      }
    } catch (e) {
      return MedicineResponse(error: "Error: Could not connect to server ($e)");
    }
  }
}

class MedicineResponse {
  final String? medicine;
  final String? error;
  final String? correctedDisease;
  final String? note; // ✅ add note field

  MedicineResponse({this.medicine, this.error, this.correctedDisease, this.note});
}
