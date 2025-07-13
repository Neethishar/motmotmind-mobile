import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DrinkWaterCalendarScreen extends StatefulWidget {
  const DrinkWaterCalendarScreen({super.key});

  @override
  State<DrinkWaterCalendarScreen> createState() => _DrinkWaterCalendarScreenState();
}

class _DrinkWaterCalendarScreenState extends State<DrinkWaterCalendarScreen> {
  List<int> completedDays = [];
  int todayDay = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('drinkWaterLastDate');
    final count = prefs.getInt('drinkWaterCompletedDays') ?? 0;

    todayDay = DateTime.now().difference(DateTime(2024, 1, 1)).inDays % 21 + 1;

    if (savedDate != null) {
      DateFormat('yyyy-MM-dd').parse(savedDate); // Parsed but unused (now removed)
      completedDays = List.generate(count, (i) => i + 1);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            /// Header Card
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/drink_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/drink.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Drink Water",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Track your 21-day hydration habit",
                          style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                  ),
                  Image.asset('assets/calendar.png', height: 32, width: 32),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Track your water intake for 21 days.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 25,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index >= 21) return const SizedBox.shrink();

                final dayNumber = index + 1;
                final isCompleted = completedDays.contains(dayNumber);
                final isToday = dayNumber == todayDay;

                Color bgColor = Colors.grey.withAlpha(30);
                Color textColor = const Color(0xFF333333);

                if (isCompleted) {
                  bgColor = const Color(0xFFFF6D2C).withAlpha(50);
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
                    "$dayNumber",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12),
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
                  const Text("Today", style: TextStyle(fontSize: 12, color: Color(0xFFFF6D2C))),
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
                  const Text("Mood", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
