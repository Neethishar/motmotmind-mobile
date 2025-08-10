import 'dart:convert';
import 'dart:io'; // For Platform checks

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

/// Get Platform-Specific Base URL
String getBaseUrl() {
  if (Platform.isAndroid) {
    // Android Emulator uses 10.0.2.2 to access host machine's localhost
    return "http://10.0.2.2:5005/api/drink";
  } else if (Platform.isIOS) {
    // iOS simulator can access localhost directly
    return "http://localhost:5005/api/drink";
  } else {
    // Default for other platforms (Web, Windows, MacOS, Linux)
    return "http://localhost:5005/api/drink";
  }
}

/// Save Drink Water Log to Backend
Future<bool> saveDrinkWaterLog({
  required String userId,
  required List<Map<String, String>> drinkEntries,
  required DateTime date,
}) async {
  try {
    final uri = Uri.parse(getBaseUrl());
    final body = json.encode({
      'userId': userId,
      'entries': drinkEntries,
      'date': date.toIso8601String(),
    });

    logger.i("📤 Sending drink water log → $uri");
    logger.d("📦 Payload: $body");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      logger.i("✅ Drink Water log saved successfully");
      return true;
    } else {
      logger.e(
        "❌ Failed to save drink log: ${response.statusCode} → ${response.body}",
      );
      return false;
    }
  } catch (e, stack) {
    logger.e("❌ Error saving drink water log", error: e, stackTrace: stack);
    return false;
  }
}

/// Get Completed Days Count from SharedPreferences
Future<int> getDrinkCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('drinkWaterCompletedDays') ?? 0;
}

/// Increment Completed Days by 1 and Save
Future<int> incrementDrinkCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  int current = prefs.getInt('drinkWaterCompletedDays') ?? 0;
  await prefs.setInt('drinkWaterCompletedDays', current + 1);
  return current + 1;
}

/// Set the Last Date When Water Was Logged
Future<void> setLastDrinkDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastDrinkWaterDate', today);
}

/// Get the Last Date When Water Was Logged
Future<String?> getLastDrinkDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastDrinkWaterDate');
}
