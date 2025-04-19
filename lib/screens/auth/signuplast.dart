import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';

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
    return Scaffold(
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
          child: SizedBox(
            width: 140, // Fixed width container for better centering
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalSteps, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color:
                        index <= _currentStep
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Get values from controllers
                            final username = _usernameController.text;
                            final password = _passwordController.text;
                            final confirmPassword =
                                _confirmPasswordController.text;

                            // Validate inputs
                            if (username.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill in all fields"),
                                ),
                              );
                              return;
                            }

                            // Validate password match
                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords don't match"),
                                ),
                              );
                              return;
                            }

                            // TODO: Save user data and authenticate

                            // Print for debugging
                            print(
                              '$username account created with password: $password',
                            );

                            // After successful signup, navigate to onboarding
                            // When you create your onboarding screen, uncomment this:
                            // Navigator.pushReplacementNamed(context, AppRoutes.onboarding);

                            // For now, navigate to the home screen
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.home,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Create account",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
    );
  }
}
