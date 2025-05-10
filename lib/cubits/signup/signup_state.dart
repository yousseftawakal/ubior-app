import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String? displayName;
  final String? email;
  final String? username;
  final String? password;
  final String? passwordConfirm;
  final String? photo;
  final String? bio;
  final String? country;
  final bool isLoading;
  final String? errorMessage;

  const SignupState({
    this.displayName,
    this.email,
    this.username,
    this.password,
    this.passwordConfirm,
    this.photo,
    this.bio,
    this.country,
    this.isLoading = false,
    this.errorMessage,
  });

  // Initial empty state
  factory SignupState.initial() => const SignupState();

  // Loading state
  factory SignupState.loading(SignupState currentState) => SignupState(
    displayName: currentState.displayName,
    email: currentState.email,
    username: currentState.username,
    password: currentState.password,
    passwordConfirm: currentState.passwordConfirm,
    photo: currentState.photo,
    bio: currentState.bio,
    country: currentState.country,
    isLoading: true,
  );

  // Error state
  factory SignupState.error(SignupState currentState, String message) =>
      SignupState(
        displayName: currentState.displayName,
        email: currentState.email,
        username: currentState.username,
        password: currentState.password,
        passwordConfirm: currentState.passwordConfirm,
        photo: currentState.photo,
        bio: currentState.bio,
        country: currentState.country,
        isLoading: false,
        errorMessage: message,
      );

  // Create a new state with updated values
  SignupState copyWith({
    String? displayName,
    String? email,
    String? username,
    String? password,
    String? passwordConfirm,
    String? photo,
    String? bio,
    String? country,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SignupState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      photo: photo ?? this.photo,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Check if required data is complete for signup
  bool get isRequiredDataComplete =>
      displayName != null &&
      email != null &&
      username != null &&
      password != null &&
      passwordConfirm != null;

  // Convert to API request format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': displayName,
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };

    // Add optional fields if they exist
    if (photo != null) data['photo'] = photo;
    if (bio != null) data['bio'] = bio;
    if (country != null) data['country'] = country;

    return data;
  }

  @override
  List<Object?> get props => [
    displayName,
    email,
    username,
    password,
    passwordConfirm,
    photo,
    bio,
    country,
    isLoading,
    errorMessage,
  ];
}
