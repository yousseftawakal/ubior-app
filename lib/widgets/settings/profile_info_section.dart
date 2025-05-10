import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/widgets/settings/settings_card.dart';
import 'package:ubior/widgets/settings/settings_form_field.dart';
import 'package:ubior/widgets/settings/settings_save_button.dart';

class ProfileInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final String? selectedCountry;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onSave;
  final ValueChanged<String> onFieldChanged;

  const ProfileInfoSection({
    Key? key,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.bioController,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.onSave,
    required this.onFieldChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Profile Information',
      icon: Icons.person_outline,
      description: 'Update your personal information and public profile',
      actionButton: SettingsSaveButton(
        onPressed: onSave,
        label: 'Save Changes',
      ),
      children: [
        // Display Name
        SettingsFormField(
          label: 'Display Name',
          controller: nameController,
          onChanged: onFieldChanged,
        ),

        // Username
        SettingsFormField(
          label: 'Username',
          controller: usernameController,
          onChanged: onFieldChanged,
          prefix: Icon(
            Icons.alternate_email,
            color: AppTheme.textSecondaryColor,
            size: 24,
          ),
        ),

        // Email
        SettingsFormField(
          label: 'Email',
          controller: emailController,
          onChanged: onFieldChanged,
          prefix: Icon(
            Icons.email_outlined,
            color: AppTheme.textSecondaryColor,
            size: 24,
          ),
        ),

        // Bio
        SettingsFormField(
          label: 'Bio',
          controller: bioController,
          onChanged: onFieldChanged,
          maxLines: 4,
        ),

        // Country Selection
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCountry,
              onChanged: onCountryChanged,
              items: [
                DropdownMenuItem(value: null, child: Text('Select Country')),
                DropdownMenuItem(
                  value: 'United States',
                  child: Text('United States'),
                ),
                DropdownMenuItem(
                  value: 'United Kingdom',
                  child: Text('United Kingdom'),
                ),
                DropdownMenuItem(value: 'Canada', child: Text('Canada')),
                DropdownMenuItem(value: 'Australia', child: Text('Australia')),
                DropdownMenuItem(value: 'Germany', child: Text('Germany')),
                DropdownMenuItem(value: 'France', child: Text('France')),
                DropdownMenuItem(value: 'Japan', child: Text('Japan')),
                DropdownMenuItem(value: 'China', child: Text('China')),
                DropdownMenuItem(value: 'India', child: Text('India')),
                DropdownMenuItem(value: 'Egypt', child: Text('Egypt')),
                DropdownMenuItem(value: 'Brazil', child: Text('Brazil')),
              ],
              style: TextStyle(fontSize: 12, color: AppTheme.textPrimaryColor),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.dividerColor),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}
