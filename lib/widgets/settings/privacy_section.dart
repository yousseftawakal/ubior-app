import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/widgets/common/custom_alert_dialog.dart';
import 'package:ubior/widgets/common/custom_snackbar.dart';
import 'package:ubior/widgets/settings/settings_card.dart';

class PrivacySection extends StatelessWidget {
  final bool privateAccount;
  final ValueChanged<bool> onPrivacyChanged;

  const PrivacySection({
    Key? key,
    required this.privateAccount,
    required this.onPrivacyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Profile Privacy',
      icon: Icons.shield_outlined,
      description: 'Control who can see your profile and content',
      iconColor: AppTheme.primaryColor,
      titleColor: AppTheme.textPrimaryColor,
      children: [
        // Private Account Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Private Account',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Switch(
              value: privateAccount,
              onChanged: (value) {
                // Show confirmation dialog
                _showPrivacyConfirmationDialog(context, value);
              },
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),

        // Description of private account
        Text(
          'When your account is private, only people you approve can see your photos and videos.',
          style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
        ),
      ],
    );
  }

  void _showPrivacyConfirmationDialog(BuildContext context, bool newValue) {
    CustomAlertDialog.show(
      context: context,
      title: newValue ? 'Make Account Private?' : 'Make Account Public?',
      message:
          newValue
              ? 'When your account is private, only people you approve can see your posts and profile information.'
              : 'Making your account public will allow anyone to see your posts and profile information.',
      primaryButtonText: 'Confirm',
      icon: Icons.shield_outlined,
      iconColor: AppTheme.primaryColor,
      onPrimaryButtonPressed: () {
        // Update the privacy setting
        onPrivacyChanged(newValue);

        // Close dialog
        Navigator.pop(context);

        // Show success message
        CustomSnackbar.show(
          context: context,
          message:
              newValue ? 'Account is now private' : 'Account is now public',
          type: SnackBarType.success,
        );
      },
      secondaryButtonText: 'Cancel',
    );
  }
}
