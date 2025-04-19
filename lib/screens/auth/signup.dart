import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for the form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displaynameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _displaynameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Get values from controllers
                            final email = _emailController.text;
                            final displayname = _displaynameController.text;

                            // TODO: Implement login logic
                            print('Login with: $email / $displayname');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Continue",
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
                            "Already have an account? ",
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle sign up
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
