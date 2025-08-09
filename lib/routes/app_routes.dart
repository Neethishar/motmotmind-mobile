import 'package:flutter/material.dart';

// Onboarding
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/log_in_screen.dart';
import '../screens/onboarding/sign_up_screen.dart';
import '../screens/onboarding/verification_screen.dart';

// Dashboard
import '../screens/dashboard/today_screen.dart';
import '../screens/dashboard/start_mood_tracker.dart';
import '../screens/dashboard/calendar.dart';
import '../screens/dashboard/challenge.dart';
import '../screens/dashboard/congratulations.dart' as dashboard;
import '../screens/dashboard/mood_check_in.dart';

// Meditation Habit Tracker
import '../screens/habit_tracker/meditation/meditation_card_screen.dart'
    as meditation;
import '../screens/habit_tracker/meditation/meditation_congratulation.dart';
import '../screens/habit_tracker/meditation/meditation_calendar_page.dart';

// Drink Water Habit Tracker
import '../screens/habit_tracker/drink/drink_water_screen.dart';
import '../screens/habit_tracker/drink/drink_water_calendar.dart';
import '../screens/habit_tracker/drink/drink_water_congratulations.dart';

// Sleep Habit Tracker
import '../screens/habit_tracker/sleep/sleep_by_10_screen.dart';
import '../screens/habit_tracker/sleep/sleep_by_10_calendar.dart';
import '../screens/habit_tracker/sleep/sleep_congratulations.dart';

// Digital Detox Habit Tracker
import '../screens/habit_tracker/detox/digital_detox_screen.dart';
import '../screens/habit_tracker/detox/digital_detox_calendar.dart';
import '../screens/habit_tracker/detox/digital_detox_congratulations.dart';

// Reading Habit Tracker
import '../screens/habit_tracker/Reading/reading_books_screen.dart';
import '../screens/habit_tracker/Reading/reading_book_calendar.dart';
import '../screens/habit_tracker/Reading/reading_congratulations_screen.dart';

// Gratitude Habit Tracker
import '../screens/habit_tracker/Gratitude/gratitude_journal_screen.dart';
import '../screens/habit_tracker/Gratitude/gratitude_write_screen.dart';
import '../screens/habit_tracker/Gratitude/gratitude_journal_calendar.dart';
import '../screens/habit_tracker/Gratitude/gratitude_congratulations_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // ✅ Onboarding
  '/splash': (context) => const SplashScreen(),
  '/sign_in': (context) => const SignInScreen(),
  '/sign_up': (context) => const SignUpScreen(),
  '/otp_verification': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) return VerificationScreen(email: args);
    return const SignInScreen();
  },

  // ✅ Dashboard
  '/today': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('username')) {
      return TodayScreen(username: args['username']);
    }
    return TodayScreen(username: 'Guest');
  },
  '/start_mood_tracker': (context) => const StartMoodTracker(),
  '/calendar': (context) => const CalendarPage(),
  '/challenge': (context) => const ChallengePage(),
  '/congratulations': (context) => const dashboard.CongratulationsPage(),
  '/mood_check_in': (context) => const MoodCheckInScreen(),

  // ✅ Meditation
  '/meditation_card': (context) => const meditation.MeditationCardScreen(),
  '/meditation_congratulation': (context) =>
      const MeditationCongratulationsPage(),
  '/meditation_calendar': (context) => const MeditationCalendarPage(),

  // ✅ Drink Water
  '/drink_water': (context) => const DrinkWaterScreen(),
  '/drink_water_calendar': (context) => const DrinkWaterCalendarScreen(),
  '/drink_water_congratulations': (context) =>
      const DrinkWaterCongratulationsPage(),

  // ✅ Sleep by 10
  '/sleep_by_10': (context) => const SleepBy10Screen(),
  '/sleep_by_10_calendar': (context) => const SleepBy10CalendarScreen(),
  '/sleep_congratulations': (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      return SleepBy10CongratulationsScreen(completedDays: args);
    }
    return const Scaffold(
      body: Center(child: Text("Missing 'completedDays' argument")),
    );
  },

  // ✅ Digital Detox
  '/digital_detox': (context) => const DigitalDetoxScreen(),
  '/digital_detox_calendar': (context) => const DigitalDetoxCalendarScreen(),
  '/digital_detox_congratulations': (context) =>
      const DigitalDetoxCongratulationsPage(),

  // ✅ Reading Books
  '/reading_books': (context) => const ReadingBooksScreen(),
  '/reading_book_calendar': (context) => const ReadingBookCalendarScreen(),
  '/reading_congrats': (context) => const ReadingCongratulationsScreen(),

  // ✅ Gratitude Journal
  // Gratitude Habit Tracker
  '/gratitude_journal': (context) => const GratitudeJournalScreen(),
  '/gratitude_write': (context) => const GratitudeWriteScreen(),
  '/gratitude_journal_calendar': (context) => const GratitudeJournalCalendar(),
  '/gratitude_congratulations': (context) =>
      const GratitudeCongratulationsScreen(),
};
