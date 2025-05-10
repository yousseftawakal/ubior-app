import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/widgets/settings/settings_card.dart';
import 'package:ubior/widgets/settings/settings_form_field.dart';
import 'package:ubior/widgets/settings/settings_save_button.dart';

class PasswordSection extends StatefulWidget {
  final VoidCallback onSave;

  const PasswordSection({Key? key, required this.onSave}) : super(key: key);

  @override
  State<PasswordSection> createState() => _PasswordSectionState();
}

class _PasswordSectionState extends State<PasswordSection> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Password',
      icon: Icons.lock_outline,
      description: 'Update your password to keep your account secure',
      actionButton: SettingsSaveButton(
        onPressed: widget.onSave,
        label: 'Change Password',
        icon: Icons.lock_outline,
      ),
      children: [
        // Current Password
        SettingsFormField(
          label: 'Current Password',
          controller: _currentPasswordController,
          obscureText: !_showCurrentPassword,
          suffix: IconButton(
            icon: Icon(
              _showCurrentPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showCurrentPassword = !_showCurrentPassword;
              });
            },
          ),
        ),

        // New Password
        SettingsFormField(
          label: 'New Password',
          controller: _newPasswordController,
          obscureText: !_showNewPassword,
          suffix: IconButton(
            icon: Icon(
              _showNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showNewPassword = !_showNewPassword;
              });
            },
          ),
        ),

        // Confirm New Password
        SettingsFormField(
          label: 'Confirm New Password',
          controller: _confirmPasswordController,
          obscureText: !_showConfirmPassword,
          suffix: IconButton(
            icon: Icon(
              _showConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showConfirmPassword = !_showConfirmPassword;
              });
            },
          ),
        ),
      ],
    );
  }
}
