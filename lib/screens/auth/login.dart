import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/auth/auth_state.dart';
import 'package:ubior/screens/feed/feed_screen.dart';
import 'package:ubior/cubits/profile/profile_cubit.dart';
import 'package:ubior/widgets/common/custom_alert_dialog.dart';
import 'package:ubior/widgets/common/custom_snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers for the form fields
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable to track password visibility
  bool _obscurePassword = true;

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Navigate to home screen
  void _navigateToHome() {
    // Direct navigation without routes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FeedScreen()),
        );
      }
    });
  }

  // Handle login
  Future<void> _login() async {
    final authCubit = context.read<AuthCubit>();

    // Show loading indicator
    CustomAlertDialog.showLoading(context: context, message: 'Signing in...');

    try {
      await authCubit.login(
        _identifierController.text.trim(),
        _passwordController.text,
      );

      // Check if the login was successful based on the current state
      if (authCubit.state.status == AuthStatus.authenticated) {
        print('Login was successful, navigating to home');

        // Pop the loading dialog
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Make sure profile cubit is notified
        try {
          final profileCubit = context.read<ProfileCubit>();
          print('Login: Telling profile cubit to refresh data');
          profileCubit.refreshProfile();
        } catch (e) {
          print('Login: Error refreshing profile: $e');
        }

        // Show success message
        CustomSnackbar.show(
          context: context,
          message: 'Successfully logged in',
          type: SnackBarType.success,
        );

        // Navigate to home screen using simpler method
        _navigateToHome();
      } else {
        // Pop the loading dialog if there was an error
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show error message
        if (authCubit.state.errorMessage != null) {
          CustomSnackbar.show(
            context: context,
            message: authCubit.state.errorMessage!,
            type: SnackBarType.error,
          );
        }

        print('Login failed: ${authCubit.state.errorMessage}');
      }
    } catch (e) {
      print('Login error: $e');
      // Pop the loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      CustomSnackbar.show(
        context: context,
        message: 'Login error: ${e.toString()}',
        type: SnackBarType.error,
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 70, scrolledUnderElevation: 0),
      // Use SingleChildScrollView to handle keyboard overflow
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          print(
            'listenWhen: previous=${previous.status}, current=${current.status}',
          );
          return previous.status != current.status;
        },
        listener: (context, state) {
          // Handle authentication state changes
          print('Auth state changed: ${state.status}');

          if (state.status == AuthStatus.authenticated) {
            print('User authenticated in listener, navigating to home');
            // Show success message
            CustomSnackbar.show(
              context: context,
              message: 'Successfully logged in',
              type: SnackBarType.success,
            );

            // Use direct navigation
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => FeedScreen()),
            );
          } else if (state.errorMessage != null) {
            // Show error message using CustomSnackbar
            CustomSnackbar.show(
              context: context,
              message: state.errorMessage!,
              type: SnackBarType.error,
            );
          }
        },
        buildWhen: (previous, current) {
          print(
            'buildWhen: previous=${previous.status}, current=${current.status}',
          );
          return true; // Always rebuild for now
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 36),
                            child: Image.asset(
                              "assets/icons/logo.png",
                              width: 60,
                              height: 108,
                            ),
                          ),
                          SizedBox(height: 36),
                          Text(
                            "Welcome to UBIÓR",
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontFamily: "Italiana",
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            "Sign in to continue your fashion journey",
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email or Username",
                            style: TextStyle(
                              color: AppTheme.textPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _identifierController,
                            decoration: InputDecoration(
                              hintText: "Enter your email or username",
                              hintStyle: TextStyle(
                                color: AppTheme.textHintColor,
                                fontSize: 12,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                  color: AppTheme.textPrimaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Handle forgot password
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: TextStyle(
                                color: AppTheme.textHintColor,
                                fontSize: 12,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  size: 16,
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.textHintColor,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            obscureText: _obscurePassword,
                            maxLines: 1,
                          ),
                          if (state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.errorColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppTheme.errorColor,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.errorMessage!,
                                        style: TextStyle(
                                          color: AppTheme.errorColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child:
                                  state.isLoading
                                      ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        "Sign In",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to signup screen
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.signup,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // Terms and conditions at the very bottom of the screen
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 34),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "By signing in, you agree to our ",
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Terms of Service
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "Terms of Service",
                style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
