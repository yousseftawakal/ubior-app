import 'package:flutter/material.dart';

/// A reusable card with a gradient background.
///
/// This widget creates a container with a vertical gradient and customizable properties.
class GradientCard extends StatelessWidget {
  /// The width of the card.
  final double width;

  /// The height of the card.
  final double height;

  /// The starting color of the gradient.
  final Color startColor;

  /// The ending color of the gradient.
  final Color endColor;

  /// The border radius of the card.
  final double borderRadius;

  /// Optional child widget to display inside the card.
  final Widget? child;

  /// Optional shadow color.
  final Color? shadowColor;

  /// Optional shadow blur radius.
  final double shadowBlurRadius;

  /// Optional shadow offset.
  final Offset shadowOffset;

  const GradientCard({
    super.key,
    this.width = 250,
    this.height = 250,
    this.startColor = Colors.white,
    this.endColor = Colors.black,
    this.borderRadius = 12,
    this.child,
    this.shadowColor,
    this.shadowBlurRadius = 10,
    this.shadowOffset = const Offset(0, 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [startColor, endColor],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            shadowColor != null
                ? [
                  BoxShadow(
                    color: shadowColor!.withAlpha(40),
                    blurRadius: shadowBlurRadius,
                    offset: shadowOffset,
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }
}
