import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/config.dart'; // your baseUrl

class DashboardService {
  static Future<Map<String, dynamic>> fetchTodaySummary(String userId) async {
    final url = Uri.parse('$baseUrl/today-summary?userId=$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load summary: ${response.body}");
    }
  }
}
