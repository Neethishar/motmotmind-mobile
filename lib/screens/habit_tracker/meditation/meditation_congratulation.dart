import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationCongratulationsPage extends StatefulWidget {
  const MeditationCongratulationsPage({super.key});

  @override
  State<MeditationCongratulationsPage> createState() =>
      _MeditationCongratulationsPageState();
}

class _MeditationCongratulationsPageState
    extends State<MeditationCongratulationsPage> {
  int completedDays = 0;

  @override
  void initState() {
    super.initState();
    loadCompletedDay();
  }

  Future<void> loadCompletedDay() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays = prefs.getInt('completedDays') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// 🎉 Top Congrats Image Background
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/congrats.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset('assets/meditation.png', height: 60, width: 60),
                  const SizedBox(height: 20),
                  Text(
                    "Meditation Day $completedDays Complete",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "“Well done on completing Day $completedDays!”",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Stay mindful for the next ${21 - completedDays} days!",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// 🔘 Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/meditation_calendar");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF666666),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Back to Calendar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/today");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6D2C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Back to Today",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
