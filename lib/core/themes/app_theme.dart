import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFF7F7F5);
  static const Color card = Color(0xFFFFFFFF);

  static const Color ink = Color(0xFF181C1A);
  static const Color muted = Color(0xFF9A9B98);

  static const Color primary = Color(0xFF4D8073);
  static const Color divider = Color(0xFFE7E7E3);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodyLarge: TextStyle(
          color: ink,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: ink,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: ink,
      elevation: 0,
    ),
  );
}
