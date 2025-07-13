// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ✅ Use your local IP and backend route path
const String baseUrl = "http://10.0.2.2:5001/api/auth";

/// 🔐 Sign In
Future<void> signIn(String email, String password, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/signin"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    debugPrint("🔵 Raw response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("✅ Login successful");
        Navigator.pushNamed(context, '/today');
      } else {
        debugPrint("❌ Login failed: ${data['message'] ?? 'Unknown error'}");
        _showSnackBar(context, data['message'] ?? "Login failed");
      }
    } else {
      debugPrint("❌ Unexpected status: ${response.statusCode}");
      _showSnackBar(context, "Unexpected server response");
    }
  } catch (e) {
    debugPrint("❌ Login error: $e");
    _showSnackBar(context, "Login error. Check your internet or server.");
  }
}

/// 🔐 Sign Up
Future<void> signUp(
  String name,
  String email,
  String password,
  BuildContext context,
) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    debugPrint("🔵 Raw response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("✅ Signup successful");
        Navigator.pushNamed(context, '/otp_verification', arguments: email);
      } else {
        debugPrint("❌ Signup failed: ${data['message'] ?? 'Unknown error'}");
        _showSnackBar(context, data['message'] ?? "Signup failed");
      }
    } else {
      debugPrint("❌ Unexpected status: ${response.statusCode}");
      _showSnackBar(context, "Unexpected server response");
    }
  } catch (e) {
    debugPrint("❌ Signup error: $e");
    _showSnackBar(context, "Signup error. Check your internet or server.");
  }
}

/// 🔐 Verify OTP
Future<void> verifyOtp(String email, String otp, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    debugPrint("🔵 Raw response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("✅ OTP Verified");
        Navigator.pushNamed(context, '/today');
      } else {
        debugPrint("❌ OTP failed: ${data['message'] ?? 'Unknown error'}");
        _showSnackBar(context, data['message'] ?? "OTP verification failed");
      }
    } else {
      debugPrint("❌ Unexpected status: ${response.statusCode}");
      _showSnackBar(context, "Unexpected server response");
    }
  } catch (e) {
    debugPrint("❌ OTP error: $e");
    _showSnackBar(context, "OTP verification error. Try again.");
  }
}

/// 🔁 Resend OTP
Future<void> resendOtp(String email) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/resend-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    debugPrint("🔵 Raw response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 400) {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        debugPrint("✅ OTP Resent");
      } else {
        debugPrint("❌ Resend failed: ${data['message'] ?? 'Unknown error'}");
      }
    } else {
      debugPrint("❌ Unexpected status: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("❌ Resend error: $e");
  }
}

/// 🔔 Helper: Show SnackBar
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
  );
}
