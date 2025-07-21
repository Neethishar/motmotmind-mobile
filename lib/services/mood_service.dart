import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✅ for debugPrint
import 'package:http/http.dart' as http;

Future<void> sendMood({
  required String userId,
  required String moodLabel,
  required String moodIcon,
  required String reason,
  required int day,
}) async {
  const String url = 'http://10.0.2.2:5008/api/mood'; // replace with your IP

  final response = await http.post(
    Uri.parse(url),
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
