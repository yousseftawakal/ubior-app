import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/auth/auth_state.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';

class Signuplast extends StatefulWidget {
  const Signuplast({super.key});

  @override
  State<Signuplast> createState() => _SignuplastState();
}

class _SignuplastState extends State<Signuplast> {
  // Controllers for the form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Current step in the signup process (0-based)
  final int _currentStep = 1; // Last step

  // Total number of steps
  final int _totalSteps = 2;

  // State variable to track password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Restore values from Cubit if they exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<SignupCubit>().state;
      if (state.username != null) {
        _usernameController.text = state.username!;
      }
      if (state.password != null) {
        _passwordController.text = state.password!;
      }
      if (state.passwordConfirm != null) {
        _confirmPasswordController.text = state.passwordConfirm!;
      }
    });
  }

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Toggle confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  // Complete signup info and move to optional steps without API call yet
  void _completeSignupInfo() async {
    // Get values from controllers
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Get the signup cubit
    final signupCubit = context.read<SignupCubit>();

    // Validate second screen data
    if (signupCubit.validateSecondScreen(
      username: username,
      password: password,
      passwordConfirm: confirmPassword,
    )) {
      // Save data to cubit
      signupCubit.saveSecondScreenData(
        username: username,
        password: password,
        passwordConfirm: confirmPassword,
      );

      // Check if required data is complete
      final infoComplete = await signupCubit.completeRequiredInfo();

      if (infoComplete && mounted) {
        // Navigate to optional photo step (without API call yet)
        Navigator.pushReplacementNamed(context, AppRoutes.signupPhoto);
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to Signup Cubit for errors and loading states
        BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              context.read<SignupCubit>().clearError();
            }
          },
        ),
        // Listen to Auth Cubit for successful authentication
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              // Navigate to optional photo step after successful authentication
              Navigator.pushReplacementNamed(context, AppRoutes.signupPhoto);
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          // Back button
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // Step indicator in the center - fixed centering
          titleSpacing: 0,
          title: Center(
            child: StepProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              containerWidth: 140,
              stepHeight: 12,
              borderRadius: 6,
            ),
          ),
          centerTitle: true,
          actions: [
            // Add invisible action to balance the back button
            SizedBox(width: 48),
          ],
          scrolledUnderElevation: 0,
        ),
        // Use SingleChildScrollView to handle keyboard overflow
        body: SingleChildScrollView(
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
                          "Create your account",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontFamily: "Italiana",
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          "Just a few more details to get started",
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
                          "Username",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Your Name",
                            hintStyle: TextStyle(
                              color: AppTheme.textHintColor,
                              fontSize: 12,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Password",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Create a strong password",
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
                        const SizedBox(height: 20),
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: "Confirm your password",
                            hintStyle: TextStyle(
                              color: AppTheme.textHintColor,
                              fontSize: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                size: 16,
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppTheme.textHintColor,
                              ),
                              onPressed: _toggleConfirmPasswordVisibility,
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    state.isLoading
                                        ? null
                                        : _completeSignupInfo,
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
                                          "Create Account",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate back to login screen
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Sign in",
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
        ),
      ),
    );
  }
}
