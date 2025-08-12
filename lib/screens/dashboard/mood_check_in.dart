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

  static const List<Map<String, String>> moodEmojis = [
    {'emoji': '😍', 'label': 'Happy'},
    {'emoji': '😜', 'label': 'Excited'},
    {'emoji': '🙂', 'label': 'Calm'},
    {'emoji': '😏', 'label': 'Annoyed'},
    {'emoji': '😔', 'label': 'Depressed'},
  ];

  static const List<String> moodFactors = [
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

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> saveMoodCheckIn() async {
    final moodEmoji = moodEmojis.firstWhere(
      (m) => m['label'] == selectedMood,
      orElse: () => {'emoji': ''},
    )['emoji'];

    final now = DateTime.now();
    final url = Uri.parse('$baseUrl/mood');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': '123',
          'moodLabel': selectedMood,
          'moodIcon': moodEmoji,
          'reason': selectedFactors,
          'day': now.day,
          'note': _noteController.text.trim(),
          'timestamp': now.toIso8601String(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        Navigator.pushNamed(context, '/congratulations');
      } else {
        _showSnackBar("Error: ${response.body}");
      }
    } catch (_) {
      if (mounted) _showSnackBar("Network Error");
    }
  }

  String _formattedNow() {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ---------- UI ----------
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Row(
          children: [
            IconButton(
              icon: Image.asset('assets/notification_icon.png', height: 24),
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
            ),
            IconButton(
              icon: Image.asset('assets/reward_icon.png', height: 24),
              onPressed: () => Navigator.pushNamed(context, '/rewards'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _moodPromptCard() {
    return _card(
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text("Take a moment to check in with yourself"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/calendar'),
                child: Image.asset('assets/calendar.png', height: 30),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Now: ${_formattedNow()}",
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _moodSelectorCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mood Selector",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
    );
  }

  Widget _moodFactorsCard() {
    return _card(
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
                selectedColor: const Color(0xFFFFE0B2),
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
    );
  }

  Widget _notesCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add a note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            minLines: 5,
            maxLines: 8,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Write here...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF6D2C),
        onPressed: () {
          if (selectedMood == null) {
            _showSnackBar("Please select your mood.");
            return;
          }
          saveMoodCheckIn();
        },
        label: const Text(
          "Save Mood Check-in",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ----------- Bottom Navigation Bar -----------
  Widget _bottomNavBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(
            iconPath: 'assets/today_icon.png',
            label: "Today",
            route: "/today",
          ),
          _navButton(
            iconPath: 'assets/mood_tracker.png',
            label: "Mood",
            route: "/mood_check_in",
          ),
        ],
      ),
    );
  }

  Widget _navButton({
    required String iconPath,
    required String label,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 24), // No color change
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54, // Same color for all
              fontWeight: FontWeight.normal, // No bold for selected
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Card wrapper
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: _floatingSaveButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 20),
                _moodPromptCard(),
                _moodSelectorCard(),
                _moodFactorsCard(),
                _notesCard(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
