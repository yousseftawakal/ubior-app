import 'package:flutter/material.dart';

/// Central theme configuration for the application
///
/// This class defines the app's color palette, typography, and component styling
/// to ensure a consistent visual identity throughout the app.
class AppTheme {
  // Brand colors - the core color palette of the application

  /// Primary color - Deep warm brown
  static const Color primaryColor = Color(0xFF826555);

  /// Primary variant - Darker brown
  static const Color primaryVariantColor = Color(0xFF5C4B3B);

  /// Secondary color - Light beige
  static const Color secondaryColor = Color(0xFFF3EEE5);

  /// Accent color - Medium beige
  static const Color accentColor = Color(0xFFD9CBB0);

  /// Light accent - Warm light beige
  static const Color lightAccentColor = Color(0xFFA3826E);

  /// Background color - Off-white
  static const Color backgroundColor = Color(0xFFF9F7F4);

  /// Surface color - Pure white for cards and dialogs
  static const Color surfaceColor = Colors.white;

  // Text colors

  /// Primary text color - Dark brown for headings and important text
  static const Color textPrimaryColor = Color(0xFF5C4B3B);

  /// Secondary text color - Medium brown for body text
  static const Color textSecondaryColor = Color(0xFF9C7C65);

  /// Hint text color - Light brown for placeholders and hints
  static const Color textHintColor = Color(0xFF71717A);

  // Status colors

  /// Error color - Warm red
  static const Color errorColor = Color(0xFFE57373);

  /// Success color - Earthy green
  static const Color successColor = Color(0xFF81C784);

  /// Warning color - Warm amber
  static const Color warningColor = Color(0xFFFFD54F);

  /// Info color - Muted blue
  static const Color infoColor = Color(0xFF64B5F6);

  // Utility colors

  /// Divider color - Light beige for subtle separators
  static const Color dividerColor = Color(0xFFEAE0D5);

  /// Shadow color - Semi-transparent brown for shadows
  static const Color shadowColor = Color(0x1A5C4B3B);

  /// The light theme configuration used throughout the app
  ///
  /// Incorporates Material 3 design principles with our custom color palette
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryVariantColor,
      onPrimaryContainer: Colors.white,
      secondary: secondaryColor,
      onSecondary: textPrimaryColor,
      secondaryContainer: accentColor,
      onSecondaryContainer: textPrimaryColor,
      tertiary: lightAccentColor,
      onTertiary: Colors.white,
      tertiaryContainer: accentColor,
      onTertiaryContainer: textPrimaryColor,
      error: errorColor,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: surfaceColor,
      onSurface: textPrimaryColor,
      onSurfaceVariant: textSecondaryColor,
      outline: dividerColor,
      outlineVariant: textHintColor,
      shadow: shadowColor,
      scrim: Colors.black.withAlpha(1),
      inverseSurface: textPrimaryColor,
      onInverseSurface: Colors.white,
      inversePrimary: accentColor,
      surfaceTint: primaryColor.withAlpha(5),
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
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
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceColor,
      filled: true,
      hintStyle: TextStyle(color: textHintColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1),
  );
}
