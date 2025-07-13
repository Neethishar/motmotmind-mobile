import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationCalendarPage extends StatefulWidget {
  const MeditationCalendarPage({super.key});

  @override
  State<MeditationCalendarPage> createState() => _MeditationCalendarPageState();
}

class _MeditationCalendarPageState extends State<MeditationCalendarPage> {
  int completedDays = 0;

  @override
  void initState() {
    super.initState();
    loadCompletedDays();
  }

  Future<void> loadCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      completedDays = prefs.getInt('completedDays') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<int> days = List.generate(21, (index) => index + 1);
    final Set<int> completedDaysSet = Set.from(
      List.generate(completedDays, (i) => i + 1),
    );
    final int remaining = 21 - completedDays;

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/meditation_bg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Image.asset("assets/meditation.png", height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    "Meditation",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Track your emotions daily and gain insights to improve your mental wellbeing.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isCompleted = completedDaysSet.contains(day);

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFFFF6D2C)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isCompleted ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "$completedDays Days Completed • $remaining Days Remaining",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/today"),
                  child: Column(
                    children: [
                      Image.asset('assets/today_icon.png', height: 28),
                      const SizedBox(height: 4),
                      const Text("Today", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/mood_check_in"),
                  child: Column(
                    children: [
                      Image.asset('assets/mood_tracker.png', height: 28),
                      const SizedBox(height: 4),
                      const Text("Mood", style: TextStyle(fontSize: 12)),
                    ],
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
