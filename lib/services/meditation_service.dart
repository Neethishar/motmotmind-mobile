import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

// Replace with your Mac's IP (check with `ifconfig` or `ipconfig getifaddr en0`)
const String localNetworkIP = "10.0.0.109";
const int backendPort = 5002;

/// Dynamically pick the best base URL depending on the platform
String getBaseUrl() {
  if (kIsWeb) {
    return "http://localhost:$backendPort";
  } else if (Platform.isAndroid) {
    // Android Emulator
    return "http://10.0.2.2:$backendPort";
  } else if (Platform.isIOS) {
    // iOS Simulator or device on same network
    return "http://$localNetworkIP:$backendPort";
  } else {
    // macOS/Windows/Linux builds
    return "http://$localNetworkIP:$backendPort";
  }
}

/// Try multiple base URLs in case one fails
Future<String?> getWorkingBaseUrl(List<String> urls) async {
  for (final url in urls) {
    try {
      final resp = await http.get(Uri.parse("$url/ping"))
          .timeout(const Duration(seconds: 3));
      if (resp.statusCode == 200) {
        logger.i("✅ Connected to backend at $url");
        return url;
      }
    } catch (_) {
      logger.w("⚠️ Failed to connect to $url");
    }
  }
  return null;
}

/// Save meditation data to backend
Future<bool> saveMeditation({
  required String userId,
  required int duration,
  required DateTime startTime,
  required DateTime endTime,
}) async {
  final possibleUrls = [
    getBaseUrl(),
    "http://$localNetworkIP:$backendPort",
    "http://10.0.2.2:$backendPort",
    "http://localhost:$backendPort",
  ];

  final baseUrl = await getWorkingBaseUrl(possibleUrls);
  if (baseUrl == null) {
    logger.e("❌ No backend connection available");
    return false;
  }

  final endpoint = '$baseUrl/api/meditation';
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

/// Local storage functions
Future<int> getCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('completedDays') ?? 0;
}

Future<int> incrementCompletedDays() async {
  final prefs = await SharedPreferences.getInstance();
  final updated = (prefs.getInt('completedDays') ?? 0) + 1;
  await prefs.setInt('completedDays', updated);
  return updated;
}

Future<void> setLastMeditationDate(String today) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastMeditationDate', today);
}

Future<String?> getLastMeditationDate() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastMeditationDate');
}
