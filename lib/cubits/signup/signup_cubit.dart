import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/cubits/auth/auth_cubit.dart';
import 'package:ubior/cubits/signup/signup_state.dart';
import 'package:ubior/services/api_service.dart';

class SignupCubit extends Cubit<SignupState> {
  final ApiService _apiService;
  final AuthCubit _authCubit;

  SignupCubit({required ApiService apiService, required AuthCubit authCubit})
    : _apiService = apiService,
      _authCubit = authCubit,
      super(SignupState.initial());

  // Save first screen data
  void saveFirstScreenData({
    required String displayName,
    required String email,
  }) {
    emit(state.copyWith(displayName: displayName, email: email));
  }

  // Save second screen data
  void saveSecondScreenData({
    required String username,
    required String password,
    required String passwordConfirm,
  }) {
    emit(
      state.copyWith(
        username: username,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );
  }

  // Save optional profile photo
  void savePhoto(String photo) {
    emit(state.copyWith(photo: photo));
  }

  // Save optional bio
  void saveBio(String bio) {
    emit(state.copyWith(bio: bio));
  }

  // Save optional country
  void saveCountry(String country) {
    emit(state.copyWith(country: country));
  }

  // Validate first screen data
  bool validateFirstScreen({
    required String displayName,
    required String email,
  }) {
    if (displayName.isEmpty) {
      emit(SignupState.error(state, 'Please enter your display name'));
      return false;
    }

    if (email.isEmpty) {
      emit(SignupState.error(state, 'Please enter your email'));
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emit(SignupState.error(state, 'Please enter a valid email address'));
      return false;
    }

    return true;
  }

  // Validate second screen data
  bool validateSecondScreen({
    required String username,
    required String password,
    required String passwordConfirm,
  }) {
    if (username.isEmpty) {
      emit(SignupState.error(state, 'Please enter a username'));
      return false;
    }

    if (password.isEmpty) {
      emit(SignupState.error(state, 'Please enter a password'));
      return false;
    }

    if (password.length < 8) {
      emit(
        SignupState.error(state, 'Password must be at least 8 characters long'),
      );
      return false;
    }

    if (passwordConfirm.isEmpty) {
      emit(SignupState.error(state, 'Please confirm your password'));
      return false;
    }

    if (password != passwordConfirm) {
      emit(SignupState.error(state, 'Passwords do not match'));
      return false;
    }

    return true;
  }

  // Complete required signup information (don't submit yet)
  Future<bool> completeRequiredInfo() async {
    if (!state.isRequiredDataComplete) {
      emit(
        SignupState.error(
          state,
          'Required information is missing. Please complete all steps.',
        ),
      );
      return false;
    }
    return true;
  }

  // Submit signup with required data (will be called when user clicks "Skip" or finishes optional screens)
  Future<bool> submitSignup() async {
    if (!state.isRequiredDataComplete) {
      emit(
        SignupState.error(
          state,
          'Required information is missing. Please complete all steps.',
        ),
      );
      return false;
    }

    // Start loading
    emit(SignupState.loading(state));

    try {
      // Create and send the full signup payload
      final userData = state.toJson();
      await _authCubit.signup(userData);

      // Reset the signup state when successful
      emit(SignupState.initial());
      return true;
    } catch (e) {
      emit(SignupState.error(state, e.toString()));
      return false;
    }
  }

  // Clear error message
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // Reset all data
  void reset() {
    emit(SignupState.initial());
  }
}
