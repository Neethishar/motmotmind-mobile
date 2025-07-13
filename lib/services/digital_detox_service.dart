import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://10.0.2.2:5007/api/digital"; // ✅ Backend route
final logger = Logger();

Future<bool> saveDigitalDetox({
  required String userId,
  required int duration,
  required String goal,
  required DateTime startTime,
  required DateTime endTime,
}) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'duration': duration,
        'goal': goal,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      logger.i("✅ Digital Detox saved successfully");
      return true;
    } else {
      logger.e("❌ Failed to save digital detox: ${response.statusCode} → ${response.body}");
      return false;
    }
  } catch (e) {
    logger.e("❌ Error saving digital detox", error: e);
    return false;
  }
}

Future<int> getCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('digitalDetoxCompletedDays') ?? 0;
}

Future<int> incrementCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt('digitalDetoxCompletedDays') ?? 0;
  await prefs.setInt('digitalDetoxCompletedDays', current + 1);
  return current + 1;
}

Future<void> setLastDetoxDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastDetoxDate', today);
}

Future<String?> getLastDetoxDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastDetoxDate');
}
