import 'package:flutter/material.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/signuplast.dart';
import '../screens/profile/profile.dart';

/// Centralized route configuration for the application
///
/// This class defines all the named routes used for navigation
/// and provides a method to get the route builder map used by MaterialApp.
class AppRoutes {
  // Route names - use these constants throughout the app to avoid typos

  /// Home/Feed screen route - the main landing screen
  static const String home = '/';

  /// User profile screen route
  static const String profile = '/profile';

  /// Search screen route for finding users, outfits, and items
  static const String search = '/search';

  /// Studio/wardrobe management screen route
  static const String studio = '/studio';

  /// Login screen route
  static const String login = '/login';

  /// Signup first step screen route
  static const String signup = '/signup';

  /// Signup last step screen route
  static const String signupLast = '/signup/last';

  /// Onboarding screen route - shown after signup
  static const String onboarding = '/onboarding';

  /// Returns a map of route names to their builder functions
  ///
  /// Used by MaterialApp to define the available routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const FeedScreen(),
      profile: (context) => const Profile(),
      search: (context) => const SearchScreen(),
      studio: (context) => const Placeholder(), // Not implemented yet
      login: (context) => const Login(),
      signup: (context) => const Signup(),
      signupLast: (context) => const Signuplast(),
      // Onboarding screens will be added when you create them
      // onboarding: (context) => const OnboardingScreen(),
    };
  }
}
