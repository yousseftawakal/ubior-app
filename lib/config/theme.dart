import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryColor = Color(0xFF826555); // Warm brown
  static const Color secondaryColor = Color(0xFFF3EEE5); // Light beige
  static const Color accentColor = Color(0xFFD9CBB0); // Medium beige
  static const Color backgroundColor = Color(0xFFF7F5F1); // Off-white
  // Text colors
  static const Color textPrimaryColor = Color(0xFF5C4B3B); // Dark brown
  static const Color textSecondaryColor = Color(0xFF8B7967); // Medium brown

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: textPrimaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: textPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: textPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: textPrimaryColor),
      bodyMedium: TextStyle(color: textPrimaryColor),
    ),
  );
}
