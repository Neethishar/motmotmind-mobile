// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/gratitude_service.dart'; // ✅ Ensure this file exists and class is correctly defined

class GratitudeWriteScreen extends StatefulWidget {
  const GratitudeWriteScreen({super.key});

  @override
  State<GratitudeWriteScreen> createState() => _GratitudeWriteScreenState();
}

class _GratitudeWriteScreenState extends State<GratitudeWriteScreen> {
  final TextEditingController _gratitudeController = TextEditingController();

  Future<void> _saveGratitude() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final formattedDate = '${today.year}-${today.month}-${today.day}';

    final lastSavedDate = prefs.getString('last_gratitude_date');

    if (lastSavedDate == formattedDate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You've already written your gratitude for today."),
        ),
      );
      return;
    }

    final text = _gratitudeController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write something before saving."),
        ),
      );
      return;
    }

    // ✅ Save to backend
    await GratitudeService.saveGratitude(text); // Removed dayCount if not needed

    // ✅ Mark today as saved
    await prefs.setString('last_gratitude_date', formattedDate);

    // ✅ Navigate to congratulations
    Navigator.pushNamed(context, '/gratitude_congratulations');
  }

  @override
  void dispose() {
    _gratitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "What are you grateful for today?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _gratitudeController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write here...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGratitude,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
