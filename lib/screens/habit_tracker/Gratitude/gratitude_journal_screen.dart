import 'package:flutter/material.dart';

class GratitudeJournalScreen extends StatelessWidget {
  const GratitudeJournalScreen({super.key});

  AppBar buildCommonAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget buildCommonBottomNav(BuildContext context, {int selectedIndex = 0}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
                Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 12,
                    color: selectedIndex == 0 ? Color(0xFFFF6D2C) : Colors.grey,
                  ),
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
                Text(
                  "Mood",
                  style: TextStyle(
                    fontSize: 12,
                    color: selectedIndex == 1 ? Color(0xFFFF6D2C) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: buildCommonAppBar(context),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Card
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/gratitude_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset('assets/gratitude.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gratitude Journal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Day 1 of 21 – How are you feeling today?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      "/gratitude_journal_calendar",
                    ),
                    child: Image.asset(
                      'assets/calendar.png',
                      height: 32,
                      width: 32,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Friday, Jul 12, 2025",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            const Text(
              "Today, I’m grateful for\nthe sunshine.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 20),

            /// ➕ Add new gratitude entry
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/gratitude_write"),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD62C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Gratitude History",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),

            /// No `.toList()` used here — spread directly
            ...[
              {"text": "I had a peaceful morning.", "date": "Jul 11"},
              {"text": "My family and friends are supportive", "date": "Jul 10"},
              {"text": "Finished a major task early.", "date": "Jul 9"},
              {"text": "Enjoyed a walk in nature.", "date": "Jul 8"},
            ].map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item["text"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      Text(
                        item["date"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: buildCommonBottomNav(context, selectedIndex: 0),
    );
  }
}
