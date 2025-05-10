import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';

class SignupBio extends StatefulWidget {
  const SignupBio({super.key});

  @override
  State<SignupBio> createState() => _SignupBioState();
}

class _SignupBioState extends State<SignupBio> {
  final TextEditingController _bioController = TextEditingController();
  final int _maxLength = 100;

  @override
  void initState() {
    super.initState();
    // Restore bio from cubit if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<SignupCubit>().state;
      if (state.bio != null) {
        _bioController.text = state.bio!;
        // Force rebuild to update character count
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  // Save bio and continue to location screen
  void _saveBioAndContinue() {
    final bio = _bioController.text.trim();
    if (bio.isNotEmpty) {
      context.read<SignupCubit>().saveBio(bio);
      // Just navigate to next screen without API call
      Navigator.pushNamed(context, AppRoutes.signupLocation);
    }
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
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: StepProgressIndicator(
            currentStep: 1,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 32),
                  Text(
                    "Tell us about yourself",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontFamily: "Italiana",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Share a little about yourself with the fashion community",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff9C7C65), fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bio",
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _bioController,
                    maxLength: _maxLength,
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText:
                          "I'm a fashion enthusiast with a passion for sustainable style and vintage finds...",
                      hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(10),
                      counterText: '', // Hide default counter
                    ),
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 12,
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Add details about your style preferences and fashion interests",
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${_bioController.text.length}/$_maxLength characters",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: AppTheme.dividerColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            "Back",
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  state.isLoading || _bioController.text.isEmpty
                                      ? null
                                      : _saveBioAndContinue,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: AppTheme.primaryColor,
                                disabledBackgroundColor:
                                    AppTheme.secondaryColor,
                              ),
                              child:
                                  state.isLoading
                                      ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
