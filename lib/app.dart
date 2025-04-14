import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

/// Root application widget that sets up the MaterialApp with theme and routes
///
/// This is the entry point for the application UI and configures:
/// - Application theme (colors, typography, component styles)
/// - Navigation routes
/// - Initial route (home screen)
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'Ubior', // App title displayed in task switchers
      theme: AppTheme.lightTheme, // Apply our custom theme
      routes: AppRoutes.getRoutes(), // Set up navigation routes
      initialRoute: AppRoutes.home, // Start with the home/feed screen
    );
  }
}
