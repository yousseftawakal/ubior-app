import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignupPhoto extends StatefulWidget {
  const SignupPhoto({super.key});

  @override
  State<SignupPhoto> createState() => _SignupPhotoState();
}

class _SignupPhotoState extends State<SignupPhoto> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });

      // Save photo path to Cubit
      context.read<SignupCubit>().savePhoto(image.path);
    }
  }

  void _continueToNextStep() {
    // Navigate to bio screen regardless of whether a photo was selected
    Navigator.pushNamed(context, AppRoutes.signupBio);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<SignupCubit>().clearError();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: StepProgressIndicator(
            currentStep: 0,
            totalSteps: 3,
            containerWidth: 204,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Submit the signup when user skips
                final signupCubit = context.read<SignupCubit>();
                final success = await signupCubit.submitSignup();

                if (success && mounted) {
                  // Navigate to home screen after successful signup
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                }
              },
              child: Text(
                "Skip for now",
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Add a Photo",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontFamily: "Italiana",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Choose a profile picture that represents you",
                    style: TextStyle(color: Color(0xff9C7C65), fontSize: 16),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.shadowColor,
                        shape: BoxShape.circle,
                        image:
                            _selectedImage != null
                                ? DecorationImage(
                                  image: FileImage(File(_selectedImage!.path)),
                                  fit: BoxFit.cover,
                                )
                                : null,
                      ),
                      child:
                          _selectedImage == null
                              ? Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: AppTheme.primaryColor,
                              )
                              : null,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAttachCard(
                          icon: Icons.photo_camera_outlined,
                          title: 'Camera',
                          description: 'Take a new photo',
                          onTap:
                              () {}, // Empty onTap since we're not implementing camera
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildAttachCard(
                          icon: Icons.photo_outlined,
                          title: 'Gallery',
                          description: 'Choose from photos',
                          onTap: _pickFromGallery,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continueToNextStep,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 143,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE6DFD3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFF1EDE7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, size: 24, color: Color(0xFFA3826E)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF59463D),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: TextStyle(color: Color(0xFFA3826E), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
