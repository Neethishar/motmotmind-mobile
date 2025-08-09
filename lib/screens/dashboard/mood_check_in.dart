import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:test_app/utils/config.dart';

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
    'Work',
    'Friends',
    'Exercise',
    'Family',
    'Hobbies',
    'Sleep',
    'Food',
    'Health',
    'Social Media',
    'Weather',
  ];

  Future<void> saveMoodCheckIn() async {
    final url = Uri.parse('$baseUrl/mood');
    final moodEmoji = moodEmojis.firstWhere(
      (m) => m['label'] == selectedMood,
      orElse: () => {'emoji': ''},
    )['emoji'];

    try {
      final timestamp = DateTime.now().toIso8601String();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': '123',
          'moodLabel': selectedMood,
          'moodIcon': moodEmoji,
          'reason': selectedFactors,
          'day': DateTime.now().day,
          'note': _noteController.text,
          'timestamp': timestamp,
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 201) {
        Navigator.pushNamed(context, '/congratulations');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Network Error")));
    }
  }

  String getCurrentDateTimeFormatted() {
    final now = DateTime.now();
    return DateFormat('MMM dd, yyyy – hh:mm a').format(now);
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ allows body to resize when keyboard opens
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/notification_icon.png',
                          height: 24,
                        ),
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

              /// Mood Prompt Card
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/mood_tracker.png', height: 60),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "How are you feeling?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text("Take a moment to check in with yourself"),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigateTo(context, '/calendar'),
                          child: Image.asset('assets/calendar.png', height: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Now: ${getCurrentDateTimeFormatted()}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              /// Mood Selector
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mood Selector",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: moodEmojis.map((mood) {
                        final label = mood['label']!;
                        final isSelected = selectedMood == label;
                        return GestureDetector(
                          onTap: () => setState(() => selectedMood = label),
                          child: Column(
                            children: [
                              Text(
                                mood['emoji']!,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: isSelected ? Colors.orange : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.orange : Colors.black,
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

              /// Mood Factors
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What influenced your mood?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: moodFactors.map((factor) {
                        final isSelected = selectedFactors.contains(factor);
                        return ChoiceChip(
                          label: Text(factor),
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

              /// Notes
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add a note",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: TextField(
                        controller: _noteController,
                        expands: true,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText: 'Write here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// Save Button
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
                        const SnackBar(
                          content: Text("Please select your mood."),
                        ),
                      );
                      return;
                    }
                    saveMoodCheckIn();
                  },
                  child: const Text(
                    "Save Mood Check-in",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // ✅ extra space so button isn't covered by keyboard
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
