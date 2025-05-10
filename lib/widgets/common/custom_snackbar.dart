import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';

/// A custom styled SnackBar that integrates with Ubior's design language
class CustomSnackbar {
  /// Shows a custom snackbar with improved styling
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final SnackBar snackBar = _buildSnackBar(
      message: message,
      type: type,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );

    // Hide any currently showing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the new snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar _buildSnackBar({
    required String message,
    required SnackBarType type,
    required Duration duration,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    // Define type-specific properties
    final Color backgroundColor;
    final IconData iconData;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppTheme.successColor;
        iconData = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = AppTheme.errorColor;
        iconData = Icons.error_outline;
        break;
      case SnackBarType.warning:
        backgroundColor = AppTheme.warningColor;
        iconData = Icons.warning_amber_outlined;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = AppTheme.infoColor;
        iconData = Icons.info_outline;
        break;
    }

    return SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration,
      action:
          actionLabel != null && onAction != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
              : null,
    );
  }

  /// Shows a loading snackbar with a progress indicator
  static void showLoading({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 30),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: duration,
    );

    // Hide any currently showing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show the loading snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Enum for SnackBar types
enum SnackBarType { info, success, error, warning }
