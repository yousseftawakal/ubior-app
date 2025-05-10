import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/gradient_card.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    // Current step in the onboarding process (0-based)
    final int _currentStep = 1; // Second step

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
        actions: [
          // Skip button on the right
          TextButton(
            onPressed: () {
              // Navigate to the main app or next screen
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
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
                      "Discover Styles",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontFamily: "Italiana",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Explore trending outfits and find inspiration from fashion enthusiasts around the world.",
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
                  // Navigate to the next step
                  Navigator.pushNamed(context, AppRoutes.onboarding3);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
