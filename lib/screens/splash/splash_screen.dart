import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/auth/auth_state.dart';
import 'package:ubior/widgets/common/custom_snackbar.dart';

/// Splash screen shown on app startup while checking authentication
///
/// This screen displays a logo and loading indicator while determining
/// if the user is already logged in, then navigates to either the onboarding
/// screens (for new users) or the home screen (for logged in users).
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _authCheckCompleted = false;
  bool _minDisplayTimeCompleted = false;

  @override
  void initState() {
    super.initState();

    // Setup fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation
    _controller.forward();

    // Ensure minimum display time for splash screen
    _ensureMinimumDisplayTime();

    // Start auth check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Ensure splash screen shows for minimum time
  Future<void> _ensureMinimumDisplayTime() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _minDisplayTimeCompleted = true;
    });
    _navigateBasedOnState();
  }

  /// Check if user is authenticated and prepare for navigation
  Future<void> _checkAuthStatus() async {
    print('SplashScreen: Starting auth check');

    final authCubit = context.read<AuthCubit>();

    // Clear any previous state and start fresh
    if (authCubit.state.status != AuthStatus.initial) {
      print('SplashScreen: Resetting auth state for fresh check');
      // We can't emit from this class, so we'll just trigger a new check
    }

    // Trigger auth status check
    try {
      await authCubit.checkAuthStatus();
      print(
        'SplashScreen: Auth check completed with status: ${authCubit.state.status}',
      );
    } catch (e) {
      print('SplashScreen: Error during auth check: $e');
    }

    setState(() {
      _authCheckCompleted = true;
    });

    _navigateBasedOnState();
  }

  /// Navigate based on current conditions
  void _navigateBasedOnState() {
    // Only navigate when both minimum display time has passed
    // and authentication check has completed
    if (_authCheckCompleted && _minDisplayTimeCompleted && mounted) {
      final authCubit = context.read<AuthCubit>();
      final authStatus = authCubit.state.status;

      print('SplashScreen: Ready to navigate. Auth status: $authStatus');

      if (authStatus == AuthStatus.authenticated) {
        // User is logged in, go to home screen
        print('SplashScreen: User is authenticated, navigating to home');
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else if (authStatus == AuthStatus.error) {
        // Show error if authentication check failed
        print('SplashScreen: Auth error: ${authCubit.state.errorMessage}');
        CustomSnackbar.show(
          context: context,
          message: 'Authentication error: ${authCubit.state.errorMessage}',
          type: SnackBarType.error,
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding1);
      } else {
        // User is not logged in, start with onboarding
        print(
          'SplashScreen: User is not authenticated, navigating to onboarding',
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Listen for authentication state changes
        print('SplashScreen: Auth state changed to ${state.status}');
        if (_minDisplayTimeCompleted && !_authCheckCompleted) {
          setState(() {
            _authCheckCompleted = true;
          });
          _navigateBasedOnState();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset("assets/icons/logo.png", width: 120, height: 216),
                const SizedBox(height: 24),

                // App name
                Text(
                  "UBIÓR",
                  style: TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontFamily: "Italiana",
                    fontSize: 48,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 40),

                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
