import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

final String baseUrl = () {
  String url;
  if (kIsWeb) {
    url = "http://localhost:5002";
  } else if (Platform.isAndroid) {
    // Use your Mac's local IP instead of 10.0.2.2
    url = "http://10.0.0.109:5002";
  } else if (Platform.isIOS) {
    url = "http://localhost:5002";
  } else {
    url = "http://10.0.0.109:5002"; // Physical devices or desktop
  }

  logger.i("Platform → Android=${!kIsWeb && Platform.isAndroid}, iOS=${!kIsWeb && Platform.isIOS}, Web=$kIsWeb");
  logger.i("Base URL → $url");

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
  logger.i("POST → $endpoint");

  try {
    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'duration': duration,
            'startTime': startTime.toIso8601String(),
            'endTime': endTime.toIso8601String(),
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      logger.i("✅ Meditation saved successfully");
      return true;
    } else {
      logger.e("❌ Save failed: ${response.statusCode} → ${response.body}");
      return false;
    }
  } catch (e, stack) {
    logger.e("❌ Error saving meditation", error: e, stackTrace: stack);
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
  final current = prefs.getInt('completedDays') ?? 0;
  final updated = current + 1;
  await prefs.setInt('completedDays', updated);
  return updated;
}

/// Save the last meditation date locally (format: YYYY-MM-DD)
Future<void> setLastMeditationDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastMeditationDate', today);
}

/// Get the last meditation date from local storage
Future<String?> getLastMeditationDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastMeditationDate');
}
