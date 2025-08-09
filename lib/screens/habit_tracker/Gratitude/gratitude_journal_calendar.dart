import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GratitudeJournalCalendar extends StatefulWidget {
  const GratitudeJournalCalendar({super.key});

  @override
  State<GratitudeJournalCalendar> createState() =>
      _GratitudeJournalCalendarState();
}

class _GratitudeJournalCalendarState extends State<GratitudeJournalCalendar> {
  List<int> completedDays = [];
  late DateTime today;
  late int daysInMonth;
  late int startWeekday;
  late String monthKey;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    daysInMonth = DateUtils.getDaysInMonth(today.year, today.month);
    startWeekday = DateTime(today.year, today.month, 1).weekday % 7;
    monthKey = DateFormat('yyyy-MM').format(today);
    loadCompletedDays();
  }

  Future<void> loadCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList =
        prefs.getStringList('gratitude_completed_$monthKey') ?? [];
    setState(() {
      completedDays = savedList.map(int.parse).toList();
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6D2C)),
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
                  image: AssetImage('assets/gratitude_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/gratitude.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gratitude Journal Tracker",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Build your habit with daily reflection.",
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

            const SizedBox(height: 8),

            /// 📆 Calendar Grid
            buildCalendarGrid(),
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

  /// 👇 Inline monthly calendar builder
  Widget buildCalendarGrid() {
    final totalCells = daysInMonth + startWeekday;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (colIndex) {
            final cellIndex = rowIndex * 7 + colIndex;
            final dayNum = cellIndex - startWeekday + 1;

            if (cellIndex < startWeekday || dayNum > daysInMonth) {
              return const SizedBox(width: 40, height: 40);
            }

            final isCompleted = completedDays.contains(dayNum);
            final isToday = dayNum == today.day;

            Color bgColor = isCompleted
                ? const Color(0xFFFF6D2C).withAlpha(51) // 20% opacity
                : Colors.grey.withAlpha(25); // ~10% opacity

            Color textColor = isCompleted
                ? const Color(0xFFFF6D2C)
                : const Color(0xFF333333);

            if (isToday) {
              bgColor = const Color(0xFFFF6D2C);
              textColor = Colors.white;
            }

            return Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "$dayNum",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
            );
          }),
        );
      }),
    );
  }
}
