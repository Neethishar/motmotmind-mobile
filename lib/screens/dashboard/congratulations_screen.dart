// lib/screens/dashboard/congratulations_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';

class CongratulationsScreen extends StatelessWidget {
  final Map<String, int> moodStats = {
    'Happy': 8,
    'Excited': 4,
    'Calm': 5,
    'Annoyed': 2,
    'Depressed': 2,
  };

  final Map<String, String> moodIcons = {
    'Happy': 'assets/Happy.png',
    'Excited': 'assets/Excited.png',
    'Calm': 'assets/Calm.png',
    'Annoyed': 'assets/Annoyed.png',
    'Depressed': 'assets/Depressed.png',
  };

  CongratulationsScreen({super.key});

  void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _navButton(BuildContext context, String iconPath, String label, String route) {
    return GestureDetector(
      onTap: () => navigateTo(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mostCommonMood = moodStats.entries.reduce((a, b) => a.value > b.value ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/profile.png', height: 72),
                    const SizedBox(height: 12),
                    const Text(
                      "Asta Black",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _drawerMenuItem(context, 'assets/Rewards.png', 'Rewards', '/rewards'),
              _drawerMenuItem(context, 'assets/Refer Friends.png', 'Refer Friends', '/refer'),
              _drawerMenuItem(context, 'assets/Leaderboard.png', 'Leaderboard', '/leaderboard'),
              _drawerMenuItem(context, 'assets/App Settings.png', 'App Settings', '/settings'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _drawerMenuItem(context, 'assets/Logout.png', 'Logout', '/sign_in'),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top nav bar (menu, notification, reward)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  // const Text(
                  //   "Congratulations!",
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  // ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/notification_icon.png', height: 24),
                        onPressed: () => navigateTo(context, '/notifications'),
                      ),
                      IconButton(
                        icon: Image.asset('assets/reward_icon.png', height: 24),
                        onPressed: () => navigateTo(context, '/rewards'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Expanded content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/mood_tracker_bg.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            child: Column(
                              children: [
                                Image.asset('assets/mood_tracker.png', height: 80),
                                const SizedBox(height: 12),
                                const Text(
                                  "You’ve completed the 21-Day\nMood tracker Challenge!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Great job showing up every day! Here’s what your mood journey looks like.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  children: [
                                    Image.asset('assets/reward_icon.png', height: 40),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "25 Coins",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF6D2C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(left: 0, top: 0, child: Image.asset("assets/celebration 1.png", height: 60)),
                          Positioned(right: 0, top: 0, child: Image.asset("assets/celebration 2.png", height: 60)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bar Chart Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moodStats.entries.map((e) => '${e.key} ×${e.value}').join('   '),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 10,
                                  barTouchData: BarTouchData(enabled: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, _) {
                                          final index = value.toInt();
                                          if (index < moodStats.keys.length) {
                                            final mood = moodStats.keys.elementAt(index);
                                            return Column(
                                              children: [
                                                Image.asset(moodIcons[mood]!, height: 24),
                                                Text(mood, style: const TextStyle(fontSize: 10)),
                                              ],
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: moodStats.entries.toList().asMap().entries.map(
                                    (entry) {
                                      final moodCount = entry.value.value;
                                      return BarChartGroupData(
                                        x: entry.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY: moodCount.toDouble(),
                                            width: 18,
                                            gradient: LinearGradient(colors: [
                                              Colors.orange.shade400,
                                              Colors.deepOrange.shade400,
                                            ]),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Mood summary
                      Text(
                        "Most common mood: ${mostCommonMood.key} (${mostCommonMood.value} days)",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      // Share button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Share.share(
                              'I just completed the 21-Day Mood Tracker Challenge! 🎉\n'
                              'My most common mood was ${mostCommonMood.key} for ${mostCommonMood.value} days!',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6D2C),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Share Your Progress", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bottom Nav Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navButton(context, 'assets/today_icon.png', "Today", "/today"),
                  _navButton(context, 'assets/tracker_icon.png', "Tracker", "/tracker"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerMenuItem(BuildContext context, String iconPath, String label, String route) {
    return ListTile(
      leading: Image.asset(iconPath, height: 28),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () => navigateTo(context, route),
    );
  }
}
