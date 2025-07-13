import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_app/utils/config.dart';  // ✅ Import baseUrl

class MoodCheckInScreen extends StatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  State<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends State<MoodCheckInScreen> {
  String? selectedMood;
  final List<String> selectedFactors = [];
  final TextEditingController _noteController = TextEditingController();

  final moodEmojis = [
    {'emoji': '😍', 'label': 'Happy'},
    {'emoji': '😜', 'label': 'Excited'},
    {'emoji': '🙂', 'label': 'Calm'},
    {'emoji': '😏', 'label': 'Annoyed'},
    {'emoji': '😔', 'label': 'Depressed'},
  ];

  final moodFactors = [
    'Work', 'Friends', 'Exercise', 'Family',
    'Hobbies', 'Sleep', 'Food', 'Health',
    'Social Media', 'Weather'
  ];

  Future<void> saveMoodCheckIn() async {
    final url = Uri.parse('$baseUrl/mood');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': '123',  // 🔹 Replace with actual user ID
          'moodLabel': selectedMood,
          'moodIcon': moodEmojis.firstWhere((m) => m['label'] == selectedMood!)['emoji'],
          'reason': selectedFactors,
          'day': DateTime.now().day,
          'note': _noteController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mood Check-in Saved!")),
        );
      } else {
        debugPrint("❌ Failed: ${response.body}");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      debugPrint("🔥 Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Network Error")),
      );
    }
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/notification_icon.png', height: 24),
                        onPressed: () => navigateTo(context, '/notifications'),
                      ),
                      IconButton(
                        icon: Image.asset('assets/reward_icon.png', height: 24),
                        onPressed: () => navigateTo(context, '/rewards'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _card(
                        child: Row(
                          children: [
                            Image.asset('assets/mood_tracker.png', height: 60),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("How are you feeling?",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text("Take a moment to check in with yourself"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Mood Selector", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: moodEmojis.map((mood) {
                                final label = mood['label']!;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMood = label;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        mood['emoji']!,
                                        style: TextStyle(
                                          fontSize: 26,
                                          color: selectedMood == label ? Colors.orange : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: selectedMood == label ? FontWeight.bold : FontWeight.normal,
                                          color: selectedMood == label ? Colors.orange : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("What influenced your mood?", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: moodFactors.map((factor) {
                                final isSelected = selectedFactors.contains(factor);
                                return ChoiceChip(
                                  label: Text(
                                    factor,
                                    style: const TextStyle(color: Color(0xFF333333)),
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFFD9D9D9),
                                  backgroundColor: const Color(0xFFD9D9D9),
                                  onSelected: (selected) {
                                    setState(() {
                                      selected
                                          ? selectedFactors.add(factor)
                                          : selectedFactors.remove(factor);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Add a note", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Write here...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6D2C),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (selectedMood == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select your mood.")),
                              );
                              return;
                            }
                            saveMoodCheckIn();
                          },
                          child: const Text(
                            "Save Mood Check-in",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/mood_tracker_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}