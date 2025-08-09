import 'dart:convert';
import 'dart:io'; // Needed for Platform checks

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = Platform.isAndroid
    ? "http://10.0.2.2:5002/api/meditation" // Android Emulator
    : "http://localhost:5002/api/meditation"; // iOS Simulator

final logger = Logger();

Future<bool> saveMeditation({
  required String userId,
  required int duration,
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
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      logger.i("✅ Meditation saved successfully");
      return true;
    } else {
      logger.e(
        "❌ Failed to save meditation: ${response.statusCode} → ${response.body}",
      );
      return false;
    }
  } catch (e) {
    logger.e("❌ Error saving meditation", error: e);
    return false;
  }
}

Future<int> getCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('completedDays') ?? 0;
}

Future<int> incrementCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt('completedDays') ?? 0;
  await prefs.setInt('completedDays', current + 1);
  return current + 1;
}

Future<void> setLastMeditationDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastMeditationDate', today);
}

Future<String?> getLastMeditationDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastMeditationDate');
}
