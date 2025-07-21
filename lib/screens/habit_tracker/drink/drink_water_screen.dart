// Updated DrinkWaterScreen with improved logic for tracking 4 logs per day

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DrinkWaterScreen extends StatefulWidget {
  const DrinkWaterScreen({super.key});

  @override
  State<DrinkWaterScreen> createState() => _DrinkWaterScreenState();
}

class _DrinkWaterScreenState extends State<DrinkWaterScreen> {
  List<DrinkEntry> _entries = [];
  int savedLogsCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeEntries();
    _loadSavedLog();
  }

  void _initializeEntries() {
    _entries = [
      DrinkEntry("250 ml", "8 am"),
      DrinkEntry("250 ml", "11 am"),
      DrinkEntry("250 ml", "2 pm"),
      DrinkEntry("250 ml", "5 pm"),
    ];
  }

  Future<void> _loadSavedLog() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savedData = prefs.getStringList('drinkWaterLogs_$today');

    if (savedData != null) {
      for (int i = 0; i < _entries.length && i < savedData.length; i++) {
        _entries[i].checked = savedData[i] == 'true';
      }
    }

    setState(() {
      savedLogsCount = _entries.where((e) => e.checked).length;
    });
  }

  Future<void> _saveLog() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final completed = _entries.where((e) => e.checked).length;

    if (completed == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⛔ Please check at least one entry.")),
      );
      return;
    }

    final logStatus = _entries.map((e) => e.checked.toString()).toList();
    await prefs.setStringList('drinkWaterLogs_$today', logStatus);

    if (completed == 4) {
      int completedDays = prefs.getInt('drinkWaterCompletedDays') ?? 0;
      await prefs.setInt('drinkWaterCompletedDays', completedDays + 1);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Log saved successfully.")),
    );

    setState(() {
      savedLogsCount = completed;
    });

    if (completed == 4) {
      Navigator.pushNamed(context, "/drink_water_congratulations");
    }
  }

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
    return Row(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: buildCommonAppBar(context),
      drawer: const Drawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: buildCommonBottomNav(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/drink_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/drink.png', height: 50),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Drink Water",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Log ${savedLogsCount + 1} of 4 – Stay Hydrated!",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/drink_water_calendar"),
                    child: Image.asset('assets/calendar.png', height: 30),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Image.asset('assets/water.png', height: 100),
            const SizedBox(height: 8),
            const Text(
              "Stay hydrated with timely reminders to drink water and maintain your well-being.",
              style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ..._entries.asMap().entries.map(
              (entry) => CheckboxListTile(
                title: Text(
                  "${entry.value.amount} — ${entry.value.time}",
                  style: const TextStyle(color: Color(0xFF333333)),
                ),
                value: entry.value.checked,
                onChanged: (value) {
                  setState(() {
                    _entries[entry.key].checked = value ?? false;
                    savedLogsCount = _entries.where((e) => e.checked).length;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D2C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save Log",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrinkEntry {
  final String amount;
  final String time;
  bool checked;

  DrinkEntry(this.amount, this.time, {this.checked = false});
}
