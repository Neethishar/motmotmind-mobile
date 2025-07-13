import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/reading_service.dart';

class ReadingBooksScreen extends StatefulWidget {
  const ReadingBooksScreen({super.key});

  @override
  State<ReadingBooksScreen> createState() => _ReadingBooksScreenState();
}

class _ReadingBooksScreenState extends State<ReadingBooksScreen> {
  bool hasStartedReading = false;
  int completedDays = 0;
  bool alreadyReadToday = false;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final count = await ReadingService.getCompletedDays();
    final lastDate = await ReadingService.getLastReadingDate();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setState(() {
      completedDays = count;
      alreadyReadToday = lastDate == today;
    });
  }

  Future<void> handleReadingComplete() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await ReadingService.setLastReadingDate(today);
    final updatedCount = await ReadingService.incrementCompletedDays();
    setState(() {
      completedDays = updatedCount;
      alreadyReadToday = true;
    });
    if (mounted) {
      Navigator.pushNamed(
        context,
        "/reading_congrats",
        arguments: updatedCount,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFFF6D2C)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Top Banner Card
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reading Books",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Day $completedDays of 21 – How are you feeling today?",
                          style: const TextStyle(
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
                      "/reading_book_calendar",
                      arguments: completedDays,
                    ),
                    child: Image.asset(
                      'assets/calendar.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Image.asset('assets/readingbook.png', height: 180),
            const SizedBox(height: 24),

            const Text(
              "Read the book",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Read 10 pages",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              '"A reader lives a thousand lives before he dies." – George R.R. Martin',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: alreadyReadToday ? null : handleReadingComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: alreadyReadToday
                      ? const Color(0xFFFF62DC) // After completion
                      : const Color(0xFF666666), // Before clicking
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  alreadyReadToday ? "Completed for Today" : "Mark as Read",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /// ✅ Bottom Navigation Bar
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
