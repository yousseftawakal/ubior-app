import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/profile/profile_cubit.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/services/api_service.dart';
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
    // Create shared instances that will be reused by Cubits
    final apiService = ApiService();
    final authCubit = AuthCubit(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(
          value: authCubit,
        ), // Removed initial check since splash screen will do it
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(apiService: apiService),
        ),
        BlocProvider<SignupCubit>(
          create:
              (_) => SignupCubit(apiService: apiService, authCubit: authCubit),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Hide the debug banner
        title: 'Ubior', // App title displayed in task switchers
        theme: AppTheme.lightTheme.copyWith(
          // Apply custom theme with additional snackbar theming
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.primaryColor,
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
          ),
          dialogTheme: DialogTheme(
            backgroundColor: AppTheme.surfaceColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        routes: AppRoutes.getRoutes(), // Set up navigation routes
        initialRoute:
            AppRoutes.splash, // Start with splash screen to check auth status
      ),
    );
  }
}
