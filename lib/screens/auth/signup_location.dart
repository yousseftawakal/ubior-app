import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/config/routes.dart';
import 'package:ubior/widgets/common/step_progress_indicator.dart';
import 'package:ubior/cubits/signup/signup_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';

class SignupLocation extends StatefulWidget {
  const SignupLocation({super.key});

  @override
  State<SignupLocation> createState() => _SignupLocationState();
}

class _SignupLocationState extends State<SignupLocation> {
  String? _selectedLocation;

  // List of major cities/countries for the dropdown
  final List<String> _locations = [
    'United States',
    'United Kingdom',
    'France',
    'Japan',
    'Australia',
    'UAE',
    'Singapore',
    'Canada',
    'Germany',
    'India',
    'Brazil',
    'Egypt',
    'South Korea',
    'Netherlands',
    'Thailand',
  ];

  @override
  void initState() {
    super.initState();
    // Restore country from cubit if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<SignupCubit>().state;
      if (state.country != null) {
        setState(() {
          _selectedLocation = state.country;
        });
      }
    });
  }

  // Save location and complete signup
  void _saveLocationAndComplete() async {
    if (_selectedLocation != null) {
      final signupCubit = context.read<SignupCubit>();

      // Save the country data
      signupCubit.saveCountry(_selectedLocation!);

      // Submit the signup to API
      final success = await signupCubit.submitSignup();

      if (success && mounted) {
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
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
            currentStep: 2,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Text(
                  "Where are you located?",
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
                  "We'll personalize your experience based on your location",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff9C7C65), fontSize: 16),
                ),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Country",
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    isDense: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppTheme.textHintColor,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: Color(0xffB0957D),
                        size: 18,
                      ),
                      hintText: "Select your country",
                      hintStyle: TextStyle(
                        color: Color(0xffB0957D),
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.dividerColor),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                    ),
                    items:
                        _locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(
                              location,
                              style: TextStyle(
                                color: AppTheme.textPrimaryColor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffF9F6EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Why we need this",
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Your location helps us show you relevant content, and local fashion trends. We'll never share your precise location without permission.",
                        style: TextStyle(
                          color: Color(0xff9C7C65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                                state.isLoading || _selectedLocation == null
                                    ? null
                                    : _saveLocationAndComplete,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: AppTheme.primaryColor,
                              disabledBackgroundColor: AppTheme.secondaryColor,
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
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Get started",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
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
    );
  }
}
