import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationCardScreen extends StatefulWidget {
  const MeditationCardScreen({super.key});

  @override
  State<MeditationCardScreen> createState() => _MeditationCardScreenState();
}

class _MeditationCardScreenState extends State<MeditationCardScreen> {
  bool isStarted = false;
  bool isFinished = false;
  int elapsedSeconds = 0;
  Stopwatch? stopwatch;
  late final String currentTime;
  int completedDays = 0;
  String timeStatusMessage = "";

  @override
  void initState() {
    super.initState();
    currentTime = DateFormat('hh:mm a').format(DateTime.now());
    loadMeditationData();
  }

  Future<void> loadMeditationData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('lastMeditationDate');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastDate != null && lastDate == today) {
      setState(() {
        isFinished = true;
      });
    }

    setState(() {
      completedDays = prefs.getInt('completedDays') ?? 0;
    });
  }

  void startMeditation() {
    setState(() {
      isStarted = true;
      elapsedSeconds = 0;
      timeStatusMessage = "";
    });

    stopwatch = Stopwatch()..start();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || stopwatch == null || !stopwatch!.isRunning) return false;

      setState(() {
        elapsedSeconds = stopwatch!.elapsed.inSeconds;

        if (elapsedSeconds >= 300) {
          timeStatusMessage = "⏱️ Max time reached (5 min)";
        } else if (elapsedSeconds < 120) {
          timeStatusMessage = "⏳ You need minimum 2 min to finish";
        } else {
          timeStatusMessage = "✅ You can now finish";
        }
      });

      return true;
    });
  }

  Future<void> finishMeditation() async {
    if (elapsedSeconds < 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⏳ Please meditate for at least 2 minutes."),
        ),
      );
      return;
    }

    stopwatch?.stop();
    final duration = stopwatch?.elapsed.inSeconds ?? elapsedSeconds;
    final startTime = DateTime.now().subtract(Duration(seconds: duration));
    final endTime = DateTime.now();

    setState(() {
      isStarted = false;
      elapsedSeconds = duration;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5002/api/meditation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': 'asta_black',
          'duration': duration,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        debugPrint('✅ Meditation saved');

        final prefs = await SharedPreferences.getInstance();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await prefs.setString('lastMeditationDate', today);
        await prefs.setInt('completedDays', completedDays + 1);

        if (mounted) {
          Navigator.pushNamed(context, '/meditation_congratulation');
        }
      } else {
        debugPrint('❌ Failed to save meditation: ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error saving meditation: $e');
    }
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
            Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/meditation_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/meditation.png', height: 48, width: 48),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "How are you feeling now today?",
                      style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/meditation_calendar");
                    },
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
            Image.asset('assets/meditation_timer.png', height: 180),
            const SizedBox(height: 24),

            Text(
              formatTime(elapsedSeconds),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              timeStatusMessage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Time of Day",
              style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 4),
            Text(
              currentTime,
              style: const TextStyle(fontSize: 18, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 30),

            if (!isStarted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: startMeditation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF666666),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            if (isStarted || elapsedSeconds >= 120)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: finishMeditation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D2C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Finish",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
