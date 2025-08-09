import 'package:flutter/material.dart';
import '../../services/mood_service.dart';

import 'mood_storage.dart'; // ✅ Assuming this exists

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  String? selectedMood;
  String? selectedMoodIcon;
  final TextEditingController reasonController = TextEditingController();

  final List<Map<String, String>> moods = [
    {'icon': 'assets/Happy.png', 'label': 'Happy'},
    {'icon': 'assets/Excited.png', 'label': 'Excited'},
    {'icon': 'assets/Calm.png', 'label': 'Calm'},
    {'icon': 'assets/Annoyed.png', 'label': 'Annoyed'},
    {'icon': 'assets/Depressed.png', 'label': 'Depressed'},
  ];

  Future<void> saveMoodAndNavigate() async {
    if (selectedMood != null && selectedMoodIcon != null) {
      await MoodStorage.saveMood(1, selectedMoodIcon!);

      try {
        await sendMood(
          userId: 'user123', // Replace with dynamic user ID if available
          moodLabel: selectedMood!,
          moodIcon: selectedMoodIcon!,
          reason: reasonController.text,
          day: 1, // Replace with dynamic day if needed
        );
      } catch (e) {
        debugPrint('❌ Error sending mood to server: $e');
      }

      if (!mounted) return;
      Navigator.pushNamed(context, '/congratulations');
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset('assets/notification_icon.png', height: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset('assets/reward_icon.png', height: 24),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/mood_tracker_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/mood_tracker.png", height: 80),
                        const SizedBox(height: 8),
                        const Text(
                          "Mood Tracker",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Day 1 of 21 – How are you feeling today?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Mood Selector
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mood Selector",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Select the emotion that best describes your mood right now:",
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: moods.map((mood) {
                          final isSelected = selectedMood == mood['label'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMood = mood['label'];
                                selectedMoodIcon = mood['icon'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? const Color(
                                              0xFFFFA726,
                                            ).withAlpha(77)
                                          : null,
                                      border: isSelected
                                          ? Border.all(
                                              color: Colors.orange,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                    child: Image.asset(
                                      mood['icon']!,
                                      height: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    mood['label']!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (selectedMood != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        "You selected: $selectedMood",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reason input
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Would you like to share why you feel this way?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Your thoughts...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedMoodIcon != null
                      ? saveMoodAndNavigate
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D2C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Save Mood",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
