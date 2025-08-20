import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/sleep_service.dart';

class SleepBy10Screen extends StatefulWidget {
  const SleepBy10Screen({super.key});

  @override
  State<SleepBy10Screen> createState() => _SleepBy10ScreenState();
}

class _SleepBy10ScreenState extends State<SleepBy10Screen> {
  bool isSaving = false;

  String get currentTime => DateFormat('hh:mm a').format(DateTime.now());

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  Future<void> handleDoneToday() async {
    setState(() => isSaving = true);

    final success = await SleepService.saveSleepEntry();
    final completedDays = await SleepService.getCompletedDays();

    setState(() => isSaving = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(
        context,
        '/sleep_congratulations',
        arguments: completedDays,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ You've already marked today as completed."),
        ),
      );
    }
  }

  Widget _bottomNavItem(
    String icon,
    String label,
    String route, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => navigateTo(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, height: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFFFF6D2C) : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6D2C)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Top Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/sleep_bg.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/sleep.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Sleep by 10PM",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Stay consistent for better sleep habits.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => navigateTo('/sleep_by_10_calendar'),
                    child: Image.asset('assets/calendar.png', height: 24),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// 🔹 Bedtime Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bedtime Logged",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(currentTime, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Goal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text("Sleep before 10:00 PM", style: TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 32),

            /// 🔹 Quote
            const Text(
              "“Early to bed and early to rise makes a person healthy, wealthy, and wise.”\n– Benjamin Franklin",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),

            const SizedBox(height: 32),

            /// 🔹 Done Today Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : handleDoneToday,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D2C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isSaving ? "Saving..." : "Done Today",
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

      /// 🔹 Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomNavItem(
              'assets/today_icon.png',
              'Today',
              '/today',
              isSelected: true,
            ),
            _bottomNavItem(
              'assets/mood_tracker.png',
              'Mood',
              '/mood_check_in',
              isSelected: false,
            ),
          ],
        ),
      ),
    );
  }
}
