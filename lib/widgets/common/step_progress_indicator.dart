import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';

/// A horizontal step progress indicator widget.
///
/// This widget displays a row of step indicators, highlighting the current step.
/// Used primarily in onboarding and multi-step forms.
class StepProgressIndicator extends StatelessWidget {
  /// The current step (0-based index).
  final int currentStep;

  /// The total number of steps.
  final int totalSteps;

  /// The width of each step indicator.
  final double stepWidth;

  /// The height of each step indicator.
  final double stepHeight;

  /// The color of the active steps.
  final Color activeColor;

  /// The color of the inactive steps.
  final Color inactiveColor;

  /// The border radius of each step indicator.
  final double borderRadius;

  /// Horizontal spacing between step indicators.
  final double horizontalSpacing;

  /// Width of the container holding the steps.
  final double? containerWidth;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepWidth = 60,
    this.stepHeight = 8,
    this.activeColor = const Color(0xff6B5347),
    this.inactiveColor = const Color(0xffD5C8B7),
    this.borderRadius = 4,
    this.horizontalSpacing = 4,
    this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: containerWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(totalSteps, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalSpacing),
            width: stepWidth,
            height: stepHeight,
            decoration: BoxDecoration(
              color: index <= currentStep ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          );
        }),
      ),
    );
  }
}
