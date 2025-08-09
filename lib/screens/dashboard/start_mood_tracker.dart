import 'package:flutter/material.dart';

class StartMoodTracker extends StatelessWidget {
  const StartMoodTracker({super.key});

  void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  Widget _navButton(
    BuildContext context,
    String iconPath,
    String label,
    String route,
  ) {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            ListTile(title: Text("Item 1")),
            ListTile(title: Text("Item 2")),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
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
                        icon: Image.asset(
                          'assets/notification_icon.png',
                          height: 24,
                        ),
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
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/start_screen.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/mood_tracker.png", height: 80),
                        const SizedBox(height: 16),
                        const Text(
                          "Mood Tracker",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "This is a 21-day challenge designed to help you track and improve your mood.\nWould you like to begin now?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB0B8C1),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/calendar");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6D2C),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text("Start Challenge"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navButton(
                    context,
                    'assets/today_icon.png',
                    "Today",
                    "/today",
                  ),
                  _navButton(
                    context,
                    'assets/tracker_icon.png',
                    "Tracker",
                    "/tracker",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
