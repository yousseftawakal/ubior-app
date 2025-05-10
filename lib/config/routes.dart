import 'package:flutter/material.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/signuplast.dart';
import '../screens/auth/signup_photo.dart';
import '../screens/auth/signup_bio.dart';
import '../screens/auth/signup_location.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/create_post/create_post_screen.dart';
import '../screens/studio/studio_screen.dart';
import '../screens/profile/profile.dart';
import '../screens/profile/settings_screen.dart';
import '../screens/onboarding/onboarding1.dart';
import '../screens/onboarding/onboarding2.dart';
import '../screens/onboarding/onboarding3.dart';
import '../screens/onboarding/onboarding4.dart';
import '../screens/splash/splash_screen.dart';

/// Centralized route configuration for the application
///
/// This class defines all the named routes used for navigation
/// and provides a method to get the route builder map used by MaterialApp.
class AppRoutes {
  // Route names - use these constants throughout the app to avoid typos

  /// Splash screen route - initial route when app starts
  static const String splash = '/';

  /// Home/Feed screen route - the main landing screen
  static const String home = '/home';

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
  static const String signupLast = '/signup-last';

  /// Signup photo screen route
  static const String signupPhoto = '/signup/photo';

  /// Signup bio screen route
  static const String signupBio = '/signup/bio';

  /// Signup location screen route
  static const String signupLocation = '/signup/location';

  /// Create post screen route
  static const String createPost = '/create-post';

  /// Onboarding screen routes
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String onboarding3 = '/onboarding3';
  static const String onboarding4 = '/onboarding4';

  /// Settings screen route
  static const String settings = '/settings';

  /// Returns a map of route names to their builder functions
  ///
  /// Used by MaterialApp to define the available routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const Login(),
      signup: (context) => const Signup(),
      signupLast: (context) => const Signuplast(),
      signupPhoto: (context) => const SignupPhoto(),
      signupBio: (context) => const SignupBio(),
      signupLocation: (context) => const SignupLocation(),
      home: (context) => const FeedScreen(),
      search: (context) => const SearchScreen(),
      createPost: (context) => const CreatePostScreen(),
      studio: (context) => const StudioScreen(),
      profile: (context) => const Profile(),
      onboarding1: (context) => const Onboarding1(),
      onboarding2: (context) => const Onboarding2(),
      onboarding3: (context) => const Onboarding3(),
      onboarding4: (context) => const Onboarding4(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
