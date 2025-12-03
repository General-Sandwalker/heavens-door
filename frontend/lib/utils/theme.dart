import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JoJoTheme {
  // JoJo Color Palette inspired by various Stands and characters
  static const Color standPurple = Color(0xFF9B59B6); // Heaven's Door Purple
  static const Color goldenWind = Color(0xFFFFD700); // Golden Experience
  static const Color starPlatinum = Color(0xFF4A90E2); // Star Platinum Blue
  static const Color emeraldGreen = Color(0xFF2ECC71); // Hierophant Green
  static const Color killerQueen = Color(0xFFE91E63); // Killer Queen Pink
  static const Color menacing = Color(
    0xFF8B0000,
  ); // Dark Red for Menacing effect
  static const Color dio = Color(0xFF1A1A1A); // DIO Dark
  static const Color joestar = Color(0xFF0077BE); // Joestar Blue

  // Neutral colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color cardBackground = Colors.white;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: standPurple,
      secondary: goldenWind,
      tertiary: starPlatinum,
      surface: cardBackground,
      error: menacing,
    ),
    scaffoldBackgroundColor: lightBackground,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: standPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, color: textPrimary),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, color: textSecondary),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: standPurple.withOpacity(0.2),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: standPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: standPurple,
        side: const BorderSide(color: standPurple, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: textSecondary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: standPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: menacing, width: 2),
      ),
      labelStyle: GoogleFonts.roboto(color: textSecondary),
      hintStyle: GoogleFonts.roboto(color: textSecondary),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: goldenWind,
      foregroundColor: textPrimary,
      elevation: 6,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: standPurple, size: 24),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: standPurple.withOpacity(0.1),
      labelStyle: GoogleFonts.roboto(
        color: standPurple,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardBackground,
      selectedItemColor: standPurple,
      unselectedItemColor: textSecondary,
      selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.roboto(),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: standPurple,
      secondary: goldenWind,
      tertiary: starPlatinum,
      surface: dio,
      error: menacing,
    ),
    scaffoldBackgroundColor: darkBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: dio,
      foregroundColor: goldenWind,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: goldenWind,
        letterSpacing: 1.5,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, color: textSecondary),
    ),

    cardTheme: CardThemeData(
      color: dio,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // Custom Gradients
  static const LinearGradient standGradient = LinearGradient(
    colors: [standPurple, starPlatinum],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldenGradient = LinearGradient(
    colors: [goldenWind, Color(0xFFFFA500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dioGradient = LinearGradient(
    colors: [dio, menacing],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
