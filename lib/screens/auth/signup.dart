import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for the form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displaynameController = TextEditingController();

  // Current step in the signup process (0-based)
  final int _currentStep = 0; // First step

  // Total number of steps
  final int _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    // Restore values from Cubit if they exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<SignupCubit>().state;
      if (state.displayName != null) {
        _displaynameController.text = state.displayName!;
      }
      if (state.email != null) {
        _emailController.text = state.email!;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _displaynameController.dispose();
    super.dispose();
  }

  // Save form data and proceed to next screen
  void _proceedToNextScreen() {
    // Get values from controllers
    final email = _emailController.text.trim();
    final displayName = _displaynameController.text.trim();

    // Get the signup cubit and validate data
    final signupCubit = context.read<SignupCubit>();
    if (signupCubit.validateFirstScreen(
      displayName: displayName,
      email: email,
    )) {
      // Save data to Cubit
      signupCubit.saveFirstScreenData(displayName: displayName, email: email);

      // Navigate to the next step
      Navigator.pushNamed(context, AppRoutes.signupLast);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        // Show error messages if any
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          // Clear the error after showing
          context.read<SignupCubit>().clearError();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          // Back button
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
          ),
          // Step indicator in the center - fixed centering
          titleSpacing: 0,
          title: Center(
            child: StepProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              containerWidth: 140,
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
                          "Join the fashion community and share your style",
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
                          "Display Name ",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _displaynameController,
                          decoration: InputDecoration(
                            hintText: "Your Name",
                            hintStyle: TextStyle(
                              color: AppTheme.textHintColor,
                              fontSize: 12,
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Email",
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "your-email@example.com",
                            hintStyle: TextStyle(
                              color: AppTheme.textHintColor,
                              fontSize: 12,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                                        : _proceedToNextScreen,
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
                                          "Continue",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
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
        // Terms and conditions at the very bottom of the screen
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 34),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "By signing up, you agree to our ",
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
              Text(
                " and ",
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Privacy Policy
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
