import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviZaTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.openSansTextTheme().apply(
        bodyColor: Colors.black,  // Adjust text color for better visibility
        displayColor: Colors.black,
      ),
      appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 117, 208, 247)),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF13B9FF),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.openSansTextTheme().apply(
        bodyColor: Colors.white,  // Adjust text color for better visibility
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 16, 46, 59),
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF13B9FF),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData toggleTheme(ThemeData currentTheme) {
    return currentTheme == light ? dark : light;
  }
}
