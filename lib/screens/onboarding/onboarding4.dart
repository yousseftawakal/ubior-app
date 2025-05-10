import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/gradient_card.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';

class Onboarding4 extends StatelessWidget {
  const Onboarding4({super.key});

  @override
  Widget build(BuildContext context) {
    // Current step in the onboarding process (0-based)
    final int _currentStep = 3; // Fourth/final step

    // Total number of steps
    final int _totalSteps = 4;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: StepProgressIndicator(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          containerWidth: 300,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card with gradient instead of placeholder
                    GradientCard(shadowColor: Colors.black),
                    SizedBox(height: 36),
                    Text(
                      "Share Your Style",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: "Italiana",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Show off your unique fashion sense and connect with others who share your taste.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff9C7C65), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the login screen to get started
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            SizedBox(height: 34),
          ],
        ),
      ),
    );
  }
}
