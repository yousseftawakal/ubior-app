import 'package:flutter/material.dart';
import '../screens/feed/feed_screen.dart';

class AppRoutes {
  // Route names
  static const String home = '/';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String studio = '/studio';

  // We'll define the actual routes later when we have screens implemented
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const FeedScreen(),
      profile: (context) => const Placeholder(),
      search: (context) => const Placeholder(),
      studio: (context) => const Placeholder(),
    };
  }
}
