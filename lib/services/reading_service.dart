import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://10.0.2.2:5003/api/reading"; // ✅ Emulator IP for reading backend
final logger = Logger();

class ReadingService {
  static const _dayKey = 'reading_completed_days';
  static const _lastDateKey = 'last_reading_date';

  /// ✅ Save a reading session to backend
  static Future<bool> saveReading({
    required String userId,
    required int pagesRead,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'pagesRead': pagesRead,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        logger.i("✅ Reading session saved successfully");
        return true;
      } else {
        logger.e("❌ Failed to save reading session: ${response.statusCode} → ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("❌ Error saving reading session", error: e);
      return false;
    }
  }

  /// ✅ Get completed reading days from local storage
  static Future<int> getCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dayKey) ?? 0;
  }

  /// ✅ Increment completed reading days and save
  static Future<int> incrementCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_dayKey) ?? 0;
    current = current + 1;
    await prefs.setInt(_dayKey, current);
    return current;
  }

  /// ✅ Set the last reading date to today
  static Future<void> setLastReadingDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastDateKey, date);
  }

  /// ✅ Get the last date a reading session was recorded
  static Future<String?> getLastReadingDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastDateKey);
  }
}
