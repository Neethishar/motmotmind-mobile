import 'package:flutter/material.dart';

class DigitalDetoxCalendarScreen extends StatelessWidget {
  const DigitalDetoxCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    /// Simulate data (replace with real logic later)
    final today = DateTime.now().day;
    final completedDays = [1, 2, 4, 5, 7, 10, 15];

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
            /// Top Digital Detox Card
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('/Users/neethisharmas/Desktop/mobile_test_app/assets/drink_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    '/Users/neethisharmas/Desktop/mobile_test_app/assets/digital.png',
                    height: 48,
                    width: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Digital Detox",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Day 2 of 21 – How are you feeling today?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/calendar.png',
                    height: 32,
                    width: 32,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Digital detox icon + description
            Image.asset('/Users/neethisharmas/Desktop/mobile_test_app/assets/digital.png', height: 100),
            const SizedBox(height: 8),
            const Text(
              "Take regular breaks from your devices and enjoy mindful moments.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Track your digital detox for 21 days.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 25, // 21 + 4 filler
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index >= 21) {
                  return const SizedBox.shrink();
                }

                final dayNumber = index + 1;
                bool isCompleted = completedDays.contains(dayNumber);
                bool isToday = dayNumber == today;

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
