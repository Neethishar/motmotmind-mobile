import 'dart:convert';
import 'dart:io'; // for Platform checking
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SleepService {
  // Dynamically resolve the correct base URL depending on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:5006/api/sleep"; // Android Emulator
    } else if (Platform.isIOS) {
      return "http://localhost:5006/api/sleep"; // iOS Simulator
      // For physical iOS devices: replace localhost with your machine's local IP
      // e.g., return "http://192.168.1.100:5006/api/sleep";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<bool> saveSleepEntry() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final lastSavedDate = prefs.getString('lastSleepDate');
    if (lastSavedDate == today) return false;

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'date': today}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setString('lastSleepDate', today);
        int completed = prefs.getInt('sleepCompletedDays') ?? 0;
        await prefs.setInt('sleepCompletedDays', completed + 1);
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  static Future<int> getCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('sleepCompletedDays') ?? 0;
  }

  static Future<List<int>> getCompletedDayNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('lastSleepDate');
    List<int> completed = [];

    for (int i = 0; i < 21; i++) {
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: i)));
      if (savedDate == date) completed.add(21 - i);
    }
    return completed;
  }
}
