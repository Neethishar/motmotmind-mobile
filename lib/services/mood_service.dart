import 'dart:convert';
import 'dart:io'; // For Platform checks
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:http/http.dart' as http;

final String moodApiUrl = Platform.isAndroid
    ? 'http://10.0.2.2:5008/api/mood'
    : 'http://localhost:5008/api/mood'; // For iOS simulator

Future<void> sendMood({
  required String userId,
  required String moodLabel,
  required String moodIcon,
  required String reason,
  required int day,
}) async {
  final response = await http.post(
    Uri.parse(moodApiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'userId': userId,
      'moodLabel': moodLabel,
      'moodIcon': moodIcon,
      'reason': reason,
      'day': day,
    }),
  );

  if (response.statusCode == 201) {
    debugPrint('✅ Mood saved successfully');
  } else {
    debugPrint('❌ Failed to save mood: ${response.statusCode}');
    debugPrint(response.body);
  }
}
