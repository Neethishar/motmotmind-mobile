import 'package:flutter/material.dart';

class DigitalDetoxScreen extends StatefulWidget {
  const DigitalDetoxScreen({super.key});

  @override
  State<DigitalDetoxScreen> createState() => _DigitalDetoxScreenState();
}

class _DigitalDetoxScreenState extends State<DigitalDetoxScreen> {
  String detoxDuration = "1 hour 30 minutes";
  String goal = "Stay offline for at least 1 hour";

  void navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// 🔹 Top Nav
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFF6D2C),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/notification_icon.png',
                          height: 24,
                        ),
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

              /// 🔹 Top Card
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/digital_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/digital.png', height: 50, width: 50),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Digital Detox",
                            style: TextStyle(
                              fontSize: 18,
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
                    GestureDetector(
                      onTap: () => navigateTo('/digital_detox_calendar'),
                      child: Image.asset('assets/calendar.png', height: 32),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 Detox Duration Field
              buildInputField("Detox Duration", detoxDuration),

              const SizedBox(height: 16),

              /// 🔹 Goal Field
              buildInputField("Goal", goal),

              const SizedBox(height: 32),

              /// 🔹 Done Today Button
              ElevatedButton(
                onPressed: () => navigateTo('/digital_detox_congratulations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D2C),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Done Today",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Quote
              const Text(
                "“Disconnect from the world to reconnect with yourself.”",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),

      /// 🔹 Bottom Nav
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(
              context,
              'assets/today_icon.png',
              'Today',
              '/today',
              true,
            ),
            _navButton(
              context,
              'assets/mood_tracker.png',
              'Mood',
              '/mood_check_in',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _navButton(
    BuildContext context,
    String iconPath,
    String label,
    String route,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFFFF6D2C) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
