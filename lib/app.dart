import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ubior',
      theme: AppTheme.lightTheme,
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.home,
    );
  }
}
