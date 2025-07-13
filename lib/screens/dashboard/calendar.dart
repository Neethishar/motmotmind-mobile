import 'package:flutter/material.dart';
import 'mood_storage.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> days = List.generate(29, (index) => index + 1);

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
                  image: AssetImage("assets/mood_tracker_bg.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Image.asset("assets/mood_tracker.png", height: 80),
                  const SizedBox(height: 16),
                  const Text("Mood Tracker", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              child: FutureBuilder<Map<int, String>>(
                future: MoodStorage.loadMoods(),
                builder: (context, snapshot) {
                  final moods = snapshot.data ?? {};
                  return GridView.builder(
                    itemCount: days.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isToday = day == 1;
                      final isBuffer = index >= 21;
                      final moodIcon = moods[day];

                      return GestureDetector(
                        onTap: isToday ? () => Navigator.pushNamed(context, '/challenge') : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isToday
                                ? const Color(0xFFFF6D2C)
                                : isBuffer
                                    ? Colors.grey.shade300
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day.toString(),
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (moodIcon != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Image.asset(moodIcon, height: 20),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            const Text("Track your mood for 21 days, with 4 buffer days if needed."),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/restart.png", height: 20),
                const SizedBox(width: 8),
                const Text("You can restart your tracker anytime you like."),
              ],
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
                  onTap: () => Navigator.pushNamed(context, "/tracker"),
                  child: Column(
                    children: [
                      Image.asset('assets/tracker_icon.png', height: 28),
                      const SizedBox(height: 4),
                      const Text("Tracker", style: TextStyle(fontSize: 12)),
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
