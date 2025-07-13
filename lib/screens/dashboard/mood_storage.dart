import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoodStorage {
  static Future<void> saveMood(int day, String emojiPath) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> moods =
        Map<String, String>.from(json.decode(prefs.getString('moods') ?? '{}'));
    moods[day.toString()] = emojiPath;
    await prefs.setString('moods', json.encode(moods));
  }

  static Future<Map<int, String>> loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('moods');
    if (data == null) return {};
    final Map<String, dynamic> decoded = json.decode(data);
    return decoded.map((k, v) => MapEntry(int.parse(k), v.toString()));
  }
}
