import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingBookCalendarScreen extends StatefulWidget {
  const ReadingBookCalendarScreen({super.key});

  @override
  State<ReadingBookCalendarScreen> createState() =>
      _ReadingBookCalendarScreenState();
}

class _ReadingBookCalendarScreenState extends State<ReadingBookCalendarScreen> {
  List<int> completedDays = [];
  late int daysInMonth;
  late int startWeekday;
  late DateTime today;
  late String monthKey;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    monthKey = DateFormat('yyyy-MM').format(today);
    daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);
    startWeekday = DateTime(today.year, today.month, 1).weekday;
    loadCompletedDays();
  }

  Future<void> loadCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final completedList =
        prefs.getStringList('reading_completed_$monthKey') ?? [];
    setState(() {
      completedDays = completedList.map(int.parse).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String monthYear = DateFormat('MMMM yyyy').format(today);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFF6D2C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔶 Top Card
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/reading_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/reading.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reading Habit Tracker",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Stay consistent with your daily reading.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 📅 Month Title
            Text(
              monthYear,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            /// 🗓️ Day Labels
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

            /// 📆 Calendar Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daysInMonth + startWeekday - 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                if (index < startWeekday - 1) {
                  return const SizedBox(); // Empty slot before the 1st
                }

                final day = index - (startWeekday - 2);
                final isCompleted = completedDays.contains(day);
                final isToday = day == today.day;

                Color bgColor = Colors.grey.withAlpha(30);
                Color textColor = const Color(0xFF333333);

                if (isCompleted) {
                  bgColor = const Color(0xFFFF6D2C).withAlpha(80);
                  textColor = const Color(0xFFFF6D2C);
                } else if (isToday) {
                  bgColor = const Color(0xFFFF6D2C);
                  textColor = Colors.white;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      /// 🔻 Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/today"),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/today_icon.png', height: 28),
                  const SizedBox(height: 4),
                  const Text(
                    "Today",
                    style: TextStyle(fontSize: 12, color: Color(0xFFFF6D2C)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/mood_check_in"),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/mood_tracker.png', height: 28),
                  const SizedBox(height: 4),
                  const Text(
                    "Mood",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
