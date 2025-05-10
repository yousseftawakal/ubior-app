import 'package:flutter/material.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/services/api_service.dart';
import 'package:ubior/widgets/common/bottom_card_alert.dart';
import 'package:ubior/widgets/common/custom_alert_dialog.dart';
import 'package:ubior/widgets/common/custom_snackbar.dart';
import 'package:ubior/widgets/settings/settings_card.dart';

class DangerZoneSection extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final ApiService _apiService = ApiService();

  DangerZoneSection({
    Key? key,
    required this.onLogout,
    required this.onDeleteAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Danger Zone',
      icon: Icons.warning_amber_rounded,
      description: 'Permanent actions that affect your account',
      iconColor: Colors.red,
      titleColor: Colors.red,
      children: [
        // Delete Account
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Permanently delete your account and all of your content',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _showDeleteAccountBottomCard(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Delete Account"),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Logout Button
        InkWell(
          onTap: () {
            _showLogoutBottomCard(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red, size: 24),
                SizedBox(width: 12),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountBottomCard(BuildContext context) {
    // Add a text controller for the confirmation text
    final TextEditingController confirmController = TextEditingController();
    bool isConfirmEnabled = false;

    // Build the confirmation text field
    Widget confirmationContent = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This action is permanent and cannot be undone. All your data will be permanently deleted.",
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
            SizedBox(height: 16),
            Text(
              "Please type 'delete' to confirm:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type 'delete'",
                hintStyle: TextStyle(color: AppTheme.textHintColor),
              ),
              onChanged: (value) {
                setState(() {
                  isConfirmEnabled = value.toLowerCase() == 'delete';
                });
              },
            ),
            SizedBox(height: 8),
            if (!isConfirmEnabled && confirmController.text.isNotEmpty)
              Text(
                "Please type 'delete' exactly to confirm",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
          ],
        );
      },
    );

    // Show the bottom card
    BottomCardAlert.show(
      context: context,
      title: "Delete Account",
      content: confirmationContent,
      primaryButtonText: "Delete My Account",
      onPrimaryButtonPressed: () async {
        if (confirmController.text.toLowerCase() == 'delete') {
          Navigator.pop(context); // Close the bottom card

          // Show loading dialog
          CustomAlertDialog.showLoading(
            context: context,
            message: 'Deleting account...',
          );

          // Test the API directly
          try {
            print('Testing direct API call to delete account');
            await _apiService.deleteAccount();

            // Close loading dialog
            Navigator.of(context).pop();

            // Show success dialog
            BottomCardAlert.show(
              context: context,
              title: 'Success',
              message: 'Account deleted successfully.',
              primaryButtonText: 'OK',
              onPrimaryButtonPressed: () {
                Navigator.pop(context);
                onDeleteAccount(); // Call the provided callback
              },
            );
          } catch (e) {
            // Close loading dialog
            Navigator.of(context).pop();

            // Show error dialog
            BottomCardAlert.show(
              context: context,
              title: 'Error',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Failed to delete account:'),
                  SizedBox(height: 8),
                  Text(e.toString(), style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  Text(
                    'This could be due to:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('• Authentication issues'),
                  Text('• Network connection problems'),
                  Text('• Server-side restrictions'),
                ],
              ),
              primaryButtonText: 'OK',
            );
          }
        }
      },
      secondaryButtonText: "Cancel",
    );
  }

  void _showLogoutBottomCard(BuildContext context) {
    BottomCardAlert.show(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      primaryButtonText: 'Logout',
      onPrimaryButtonPressed: () {
        Navigator.pop(context);

        // Show success message
        CustomSnackbar.show(
          context: context,
          message: 'Successfully logged out',
          type: SnackBarType.success,
        );

        onLogout();
      },
      secondaryButtonText: 'Cancel',
    );
  }
}
