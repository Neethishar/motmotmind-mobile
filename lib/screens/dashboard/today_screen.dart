import 'package:flutter/material.dart';

class TodayScreen extends StatefulWidget {
  final String username;

  const TodayScreen({super.key, required this.username});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late String username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey('username')) {
      username = args['username'];
    } else {
      username = widget.username;
    }
  }

  void navigateTo(String routeName) {
    if (!mounted) return;
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mediaPadding = MediaQuery.of(context).padding;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: const Drawer(child: Center(child: Text("Drawer Menu"))),
      bottomNavigationBar: _buildBottomNav(),
      body: Padding(
        // Use MediaQuery padding to avoid unsafe areas (status bar, notch, etc)
        padding: EdgeInsets.only(
          top: mediaPadding.top,
          left: 16,
          right: 16,
          bottom: mediaPadding.bottom,
        ),
        child: Column(
          children: [
            // Expanded to fill vertical space and allow ListView to scroll
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildGreeting(username),
                  const SizedBox(height: 30),
                  _buildMoodCard(screenWidth),
                  const SizedBox(height: 30),
                  const Text(
                    "Today's Habits",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildHabitCards(screenWidth),
                  const SizedBox(height: 100), // Padding before nav bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Image.asset('assets/notification_icon.png', height: 24),
                onPressed: () => navigateTo('/notifications'),
              ),
              IconButton(
                icon: Image.asset('assets/reward_icon.png', height: 24),
                onPressed: () => navigateTo('/rewards'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(String name) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/profile.png'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening, $name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Today, I choose joy and contentment\nover stress and worry.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodCard(double screenWidth) {
    return Center(
      child: Container(
        width: screenWidth * 0.90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage("assets/mood_tracker_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Image.asset("assets/mood_tracker.png", height: 50),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Mood Check-In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Take a moment to reflect on your feelings",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6D2C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => navigateTo('/mood_check_in'),
              child: const Text("Check in Mood"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHabitCards(double screenWidth) {
    final habits = [
      {
        "label": "Meditation",
        "bg": "assets/meditation_bg.png",
        "icon": "assets/meditation.png",
        "route": "/meditation_card",
      },
      {
        "label": "Reading Books",
        "bg": "assets/reading_bg.png",
        "icon": "assets/reading.png",
        "route": "/reading_books",
      },
      {
        "label": "Gratitude Journal",
        "bg": "assets/gratitude_bg.png",
        "icon": "assets/gratitude.png",
        "route": "/gratitude_journal",
      },
      {
        "label": "Drink Water",
        "bg": "assets/drink_bg.png",
        "icon": "assets/drink.png",
        "route": "/drink_water",
      },
      {
        "label": "Sleep by 10PM",
        "bg": "assets/sleep_bg.png",
        "icon": "assets/sleep.png",
        "route": "/sleep_by_10",
      },
      {
        "label": "Digital Detox",
        "bg": "assets/digital_bg.png",
        "icon": "assets/digital.png",
        "route": "/digital_detox",
      },
    ];

    return habits.map((habit) {
      return GestureDetector(
        onTap: () => navigateTo(habit['route']!),
        child: Container(
          width: screenWidth * 0.90,
          height: 90,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(habit['bg']!),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(habit['icon']!, height: 24),
                const SizedBox(width: 8),
                Text(
                  habit['label']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(
            'assets/today_icon.png',
            "Today",
            "/today",
            isSelected: true,
          ),
          _navButton(
            'assets/mood_tracker.png',
            "Mood",
            "/mood_check_in",
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _navButton(
    String iconPath,
    String label,
    String route, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => navigateTo(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFFFF6D2C)
                  : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
