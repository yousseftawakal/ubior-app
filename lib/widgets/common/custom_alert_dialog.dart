import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';

/// A custom styled AlertDialog that follows Ubior's design language
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool barrierDismissible;
  final IconData? icon;
  final Color? iconColor;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.message,
    this.content,
    required this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.barrierDismissible = true,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  /// Show the custom alert dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    required String primaryButtonText,
    VoidCallback? onPrimaryButtonPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonPressed,
    bool barrierDismissible = true,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => CustomAlertDialog(
            title: title,
            message: message,
            content: content,
            primaryButtonText: primaryButtonText,
            onPrimaryButtonPressed: onPrimaryButtonPressed,
            secondaryButtonText: secondaryButtonText,
            onSecondaryButtonPressed: onSecondaryButtonPressed,
            barrierDismissible: barrierDismissible,
            icon: icon,
            iconColor: iconColor,
          ),
    );
  }

  /// Show a loading dialog
  static Future<T?> showLoading<T>({
    required BuildContext context,
    required String message,
    bool barrierDismissible = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 20),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon (if provided)
          if (icon != null) ...[
            Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppTheme.primaryColor,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 10),

          // Message
          if (message != null) ...[
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            SizedBox(height: 14),
          ],

          // Custom content
          if (content != null) ...[content!, SizedBox(height: 14)],

          // Buttons
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Secondary button
              if (secondaryButtonText != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        onSecondaryButtonPressed ??
                        () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: AppTheme.dividerColor),
                    ),
                    child: Text(
                      secondaryButtonText!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),

              // Space between buttons
              if (secondaryButtonText != null) SizedBox(width: 10),

              // Primary button
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      onPrimaryButtonPressed ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    primaryButtonText,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
