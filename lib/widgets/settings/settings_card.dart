import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final List<Widget> children;
  final Widget? actionButton;
  final Color iconColor;
  final Color titleColor;

  const SettingsCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.description,
    required this.children,
    this.actionButton,
    this.iconColor = const Color(0xFF6B5347), // AppTheme.primaryColor
    this.titleColor = const Color(0xFF333333), // AppTheme.textPrimaryColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.dividerColor.withAlpha(128)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  SizedBox(width: 9),
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),

              // Content
              ...children,

              // Action button if provided
              if (actionButton != null)
                Align(alignment: Alignment.centerRight, child: actionButton),
            ],
          ),
        ),
      ),
    );
  }
}
