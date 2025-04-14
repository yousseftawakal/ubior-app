import 'package:flutter/material.dart';

/// Central theme configuration for the application
///
/// This class defines the app's color palette, typography, and component styling
/// to ensure a consistent visual identity throughout the app.
class AppTheme {
  // Brand colors - the core color palette of the application

  /// Primary brand color - warm brown used for primary elements
  static const Color primaryColor = Color(0xFF826555);

  /// Secondary brand color - light beige used for backgrounds and secondary elements
  static const Color secondaryColor = Color(0xFFF3EEE5);

  /// Accent color - medium beige used for highlights and accent elements
  static const Color accentColor = Color(0xFFD9CBB0);

  /// Background color - off-white used for screen backgrounds
  static const Color backgroundColor = Color(0xFFF7F5F1);

  // Text colors for typography

  /// Primary text color - dark brown used for headings and important text
  static const Color textPrimaryColor = Color(0xFF5C4B3B);

  /// Secondary text color - medium brown used for less prominent text
  static const Color textSecondaryColor = Color(0xFF8B7967);

  /// The light theme configuration used throughout the app
  ///
  /// Incorporates Material 3 design principles with our custom color palette
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
