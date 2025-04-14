import 'package:flutter/material.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/search/search_screen.dart';

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

  /// Returns a map of route names to their builder functions
  ///
  /// Used by MaterialApp to define the available routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const FeedScreen(),
      profile: (context) => const Placeholder(), // Not implemented yet
      search: (context) => const SearchScreen(),
      studio: (context) => const Placeholder(), // Not implemented yet
    };
  }
}
