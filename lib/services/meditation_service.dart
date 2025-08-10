import 'dart:convert';
import 'dart:io'; // Needed for Platform checks

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

// Base URL setup with platform detection
final String baseUrl = () {
  String url;
  if (Platform.isAndroid) {
    url = "http://10.0.2.2:5002"; // Android emulator localhost
  } else if (Platform.isIOS) {
    url = "http://localhost:5002"; // iOS simulator localhost
  } else {
    url = "http://10.0.0.109:5002"; // Physical devices or other platforms
  }

  // Log platform and URL
  logger.i("Detected platform → Android=${Platform.isAndroid}, iOS=${Platform.isIOS}");
  logger.i("Using Base URL → $url");
  return url;
}();

/// Save meditation data to the backend
Future<bool> saveMeditation({
  required String userId,
  required int duration,
  required DateTime startTime,
  required DateTime endTime,
}) async {
  final String endpoint = '$baseUrl/api/meditation';
  logger.i("Posting meditation to $endpoint");

  try {
    final response = await http.post(
      Uri.parse(endpoint),
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

/// Get the number of completed days from local storage
Future<int> getCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('completedDays') ?? 0;
}

/// Increment the completed days counter
Future<int> incrementCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt('completedDays') ?? 0;
  await prefs.setInt('completedDays', current + 1);
  return current + 1;
}

/// Save the last meditation date locally
Future<void> setLastMeditationDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastMeditationDate', today);
}

/// Get the last meditation date from local storage
Future<String?> getLastMeditationDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastMeditationDate');
}
