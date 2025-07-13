import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

final logger = Logger();

const String baseUrl = "http://10.0.2.2:5004/api/gratitude"; // ✅ Localhost for Android emulator

class GratitudeService {
  /// Save today's gratitude entry
  static Future<bool> saveGratitude(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final lastSavedDate = prefs.getString('lastGratitudeDate');
    if (lastSavedDate == today) {
      logger.w("⛔ Already submitted gratitude for today");
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
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
        logger.e("❌ Failed to save gratitude: ${response.statusCode} → ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("❌ Exception during saving gratitude", error: e);
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

  /// Get completed day indexes for calendar tracking
  static Future<List<int>> getCompletedDayNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastGratitudeDate');
    final List<int> completedDays = [];

    for (int i = 0; i < 21; i++) {
      final date = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: i)));
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
      final response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((entry) {
          return {
            'date': entry['date'],
            'text': entry['text'],
          };
        }).toList();
      } else {
        logger.e("❌ Failed to fetch gratitude history: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logger.e("❌ Exception during fetching history", error: e);
      return [];
    }
  }
}
