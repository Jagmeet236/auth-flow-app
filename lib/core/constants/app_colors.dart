import 'package:flutter/material.dart';

class AppColors {
  // Core / Branding Colors
  static const Color primary = Colors.blue; // modern soft blue
  static const Color primaryLight = Color.fromARGB(255, 204, 220, 247);
  static const Color primaryDark = Color(0xFF003366);
  static const Color accent = Color(0xFFE6E6FA); // lavender

  // Background Colors
  static const Color scaffoldLight = Colors.white;
  static const Color scaffoldDark = Colors.black;

  static const Color cardLight = Color(0xFFF7F7FB); // textfield fill
  static const Color cardDark = Color(0xFF1C1C1C);

  // Text Colors
  static const Color textPrimaryLight = Colors.black;
  static const Color textSecondaryLight = Colors.black54;

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white54;

  // Input / Border / States
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Colors.white24;

  static const Color textFieldFocus = primary;
  static const Color error = Color(0xFFE53935);

  // Button Colors
  static const Color buttonTextLight = Colors.white;
  static const Color buttonTextDark = Colors.black;
  static const Color lightBackgroundColor = Colors.white;
  static const Color darkBackgroundColor = Colors.black;

  // Misc
  static const Color link = primaryLight;
}
