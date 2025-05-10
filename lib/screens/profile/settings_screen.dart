import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/cubits/profile/profile_cubit.dart';
import 'package:ubior/cubits/profile/profile_state.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/auth/auth_state.dart';
import 'package:ubior/models/user.dart';
import 'package:ubior/widgets/common/bottom_nav_bar.dart';
import 'package:ubior/widgets/common/custom_alert_dialog.dart';
import 'package:ubior/widgets/common/custom_snackbar.dart';
import 'package:ubior/widgets/settings/danger_zone_section.dart';
import 'package:ubior/widgets/settings/password_section.dart';
import 'package:ubior/widgets/settings/privacy_section.dart';
import 'package:ubior/widgets/settings/profile_info_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _selectedCountry;
  bool _privateAccount = false;

  // Track if form is dirty (has changes)
  bool _formDirty = false;

  @override
  void initState() {
    super.initState();
    // Explicitly fetch user profile data when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('SettingsScreen: Initializing and fetching user profile');
      context.read<ProfileCubit>().fetchUserProfile();
    });
  }

  // Populate form fields with user data
  void _populateFormFields(User user) {
    _nameController.text = user.displayName;
    _usernameController.text = user.username;
    _emailController.text = user.email ?? '';
    _bioController.text = user.bio ?? '';

    // Set country if available in user data
    final userData = user.toJson();
    if (userData.containsKey('country') && userData['country'] != null) {
      _selectedCountry = userData['country'];
    }

    // Set privacy setting
    _privateAccount = user.isPrivate ?? false;

    // Mark form as clean after populating
    _formDirty = false;
  }

  // Save just profile information changes
  void _saveProfileInfo() {
    print('SettingsScreen: Saving profile information changes');

    final profileCubit = context.read<ProfileCubit>();

    // Update only profile information fields
    profileCubit.updateUserProfile(
      displayName: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      bio: _bioController.text,
      country: _selectedCountry,
    );
  }

  // Save just privacy settings
  void _savePrivacySettings(bool isPrivate) {
    print('SettingsScreen: Saving privacy settings');

    final profileCubit = context.read<ProfileCubit>();

    // Update only privacy settings
    profileCubit.updateUserProfile(isPrivate: isPrivate);
  }

  // Save password changes
  void _savePassword() {
    print('SettingsScreen: Saving password changes');

    // This would call a different API endpoint for password changes
    // For now, just show a success message
    CustomSnackbar.show(
      context: context,
      message: 'Password changed successfully',
      type: SnackBarType.success,
    );
  }

  // Handle logout
  void _handleLogout() {
    print('SettingsScreen: Handling logout');

    // Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  // Handle delete account
  void _handleDeleteAccount() {
    print('SettingsScreen: Handling delete account');

    // Show loading indicator
    CustomSnackbar.showLoading(
      context: context,
      message: 'Deleting account...',
    );

    // Use AuthCubit to delete the account and handle navigation in the BlocListener
    context.read<AuthCubit>().deleteAccount();
  }

  // Mark form as dirty when any field changes
  void _markFormDirty() {
    setState(() {
      _formDirty = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        print('SettingsScreen: Auth state changed to ${authState.status}');

        // Only handle non-loading states for delete account process
        if (!authState.isLoading) {
          // Check for errors during deletion
          if (authState.status == AuthStatus.unauthenticated &&
              authState.errorMessage != null) {
            // Clear loading snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // Show error message
            CustomSnackbar.show(
              context: context,
              message: 'Error: ${authState.errorMessage}',
              type: SnackBarType.error,
              duration: Duration(seconds: 5),
            );
          }

          // If user is now unauthenticated (after successful deletion)
          if (authState.status == AuthStatus.unauthenticated &&
              authState.errorMessage == null) {
            // Clear loading snackbar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            // Show success message
            CustomSnackbar.show(
              context: context,
              message: 'Account deleted successfully',
              type: SnackBarType.success,
            );

            // Navigate to login screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          print('SettingsScreen: Profile state changed to ${state.status}');

          // When profile is loaded, update form fields
          if (state.status == ProfileStatus.loaded && state.user != null) {
            print(
              'SettingsScreen: Populating form fields with user data: ${state.user!.displayName}',
            );
            _populateFormFields(state.user!);
          }

          // Show error if update fails
          if (state.status == ProfileStatus.error) {
            print('SettingsScreen: Error - ${state.errorMessage}');
            CustomSnackbar.show(
              context: context,
              message: 'Error: ${state.errorMessage}',
              type: SnackBarType.error,
            );
          }

          // Show success message if profile was updated successfully
          if (state.status == ProfileStatus.loaded && _formDirty == false) {
            CustomSnackbar.show(
              context: context,
              message: 'Profile updated successfully',
              type: SnackBarType.success,
            );
          }
        },
        builder: (context, state) {
          // Show loading indicator while fetching or updating profile data
          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Account Settings'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If no user data is available, show error
          if (state.user == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Account Settings'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load user data'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<ProfileCubit>().refreshProfile(),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // If we get this far, we have user data - build the settings UI
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              toolbarHeight: 90,
              title: Text(
                'Account Settings',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Information Section
                  ProfileInfoSection(
                    nameController: _nameController,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    bioController: _bioController,
                    selectedCountry: _selectedCountry,
                    onCountryChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                        _formDirty = true;
                      });
                    },
                    onSave: _saveProfileInfo,
                    onFieldChanged: (_) => _markFormDirty(),
                  ),

                  // Privacy Settings Section
                  PrivacySection(
                    privateAccount: _privateAccount,
                    onPrivacyChanged: (value) {
                      setState(() {
                        _privateAccount = value;
                      });
                      _savePrivacySettings(value);
                    },
                  ),

                  // Password Section
                  PasswordSection(onSave: _savePassword),

                  // Danger Zone Section
                  DangerZoneSection(
                    onLogout: _handleLogout,
                    onDeleteAccount: _handleDeleteAccount,
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: 4, // Profile tab
              onTap: (index) {
                if (index == 4) {
                  // Already on profile tab, just go back to profile
                  Navigator.pop(context);
                } else {
                  // Navigate to other tabs
                  switch (index) {
                    case 0:
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                      break;
                    case 1:
                      Navigator.pushReplacementNamed(context, AppRoutes.search);
                      break;
                    case 2:
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.createPost,
                      );
                      break;
                    case 3:
                      Navigator.pushReplacementNamed(context, AppRoutes.studio);
                      break;
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
