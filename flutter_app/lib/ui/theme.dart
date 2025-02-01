import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviZaTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF0F2D35),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF00E676), // Vibrant green from the logo
        primary: Color(0xFF00E676),
        secondary: Color(0xFF0F2D35), // Dark blue shade
      ),
      scaffoldBackgroundColor: Colors.white,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00E676),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF0A1E26),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Color(0xFF00E676),
        primary: Color(0xFF00E676),
        secondary: Color(0xFF0A1E26),
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00E676),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData toggleTheme(ThemeData currentTheme) {
    return currentTheme == light ? dark : light;
  }
}
