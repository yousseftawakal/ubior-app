import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ubior',
      theme: AppTheme.lightTheme,
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.home,
    );
  }
}
