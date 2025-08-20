import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final logger = Logger();

final String baseUrl = Platform.isAndroid
    ? "http://10.0.2.2:5004"
    : Platform.isIOS
        ? "http://localhost:5004"
        : "http://localhost:5004";

class GratitudeService {
  static String get gratitudeEndpoint => '$baseUrl/api/gratitude';
  static String get gratitudeHistoryEndpoint => '$baseUrl/api/gratitude/all';

  /// Save today's gratitude entry
  static Future<bool> saveGratitude(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final lastSavedDate = prefs.getString('lastGratitudeDate');
    if (lastSavedDate == today) {
      logger.w("⛔ Already submitted gratitude for today");
      return false;
    }

    final userId = prefs.getString('userId') ?? '';
    if (userId.isEmpty) {
      logger.e("⛔ No userId found in storage, cannot save gratitude");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(gratitudeEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'text': text,
          'date': today,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("✅ Gratitude saved successfully");

        await prefs.setString('lastGratitudeDate', today);
        int current = prefs.getInt('gratitudeCompletedDays') ?? 0;
        await prefs.setInt('gratitudeCompletedDays', current + 1);

        return true;
      } else {
        logger.e(
          "❌ Failed to save gratitude: ${response.statusCode} → ${response.body}",
        );
        return false;
      }
    } catch (e, stack) {
      logger.e("❌ Exception during saving gratitude", error: e, stackTrace: stack);
      return false;
    }
  }

  /// Get number of completed days
  static Future<int> getCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('gratitudeCompletedDays') ?? 0;
  }

  /// Get last saved date
  static Future<String?> getLastGratitudeDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastGratitudeDate');
  }

  /// Get completed day indexes for calendar tracking (example: last 21 days)
  /// NOTE: This currently only checks if the last saved date matches any of the last 21 days
  static Future<List<int>> getCompletedDayNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastGratitudeDate');
    final List<int> completedDays = [];

    for (int i = 0; i < 21; i++) {
      final date = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: i)),
      );
      final dayIndex = 21 - i;

      if (savedDate == date) {
        completedDays.add(dayIndex);
      }
    }

    return completedDays;
  }

  /// Get all saved gratitude entries from backend
  static Future<List<Map<String, dynamic>>> getGratitudeHistory() async {
    try {
      final response = await http.get(Uri.parse(gratitudeHistoryEndpoint));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((entry) {
          return {
            'date': entry['date'],
            'text': entry['text'],
          };
        }).toList();
      } else {
        logger.e(
          "❌ Failed to fetch gratitude history: ${response.statusCode}",
        );
        return [];
      }
    } catch (e, stack) {
      logger.e("❌ Exception during fetching history", error: e, stackTrace: stack);
      return [];
    }
  }
}
