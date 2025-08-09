import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mood_storage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<int> completedDays = [];
  late int daysInMonth;
  late int startWeekday;
  late DateTime today;
  late String monthKey;
  Map<int, String> moodIcons = {};

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    monthKey = DateFormat('yyyy-MM').format(today);
    daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);
    startWeekday = DateTime(today.year, today.month, 1).weekday;
    loadMoodData();
  }

  Future<void> loadMoodData() async {
    final moods = await MoodStorage.loadMoods();
    setState(() {
      moodIcons = moods;
      completedDays = moods.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String monthYear = DateFormat('MMMM yyyy').format(today);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            /// Header Card
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
                  const Text(
                    "Mood Tracker",
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

            /// Month label
            Text(
              monthYear,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Day labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("Sun", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Mon", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tue", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Wed", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Thu", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Fri", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Sat", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            /// Calendar Grid
            Expanded(
              child: GridView.builder(
                itemCount: daysInMonth + startWeekday - 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index < startWeekday - 1) return const SizedBox();

                  final day = index - (startWeekday - 2);
                  final isToday = day == today.day;
                  final isCompleted = completedDays.contains(day);
                  final moodIcon = moodIcons[day];

                  Color bgColor = Colors.grey.withAlpha(30);
                  Color textColor = const Color(0xFF333333);

                  if (isCompleted) {
                    bgColor = const Color(0xFFFF6D2C).withAlpha(80);
                    textColor = const Color(0xFFFF6D2C);
                  } else if (isToday) {
                    bgColor = const Color(0xFFFF6D2C);
                    textColor = Colors.white;
                  }

                  return GestureDetector(
                    onTap: isToday
                        ? () => Navigator.pushNamed(context, '/challenge')
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$day",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
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
              ),
            ),

            /// Bottom Navigation
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
