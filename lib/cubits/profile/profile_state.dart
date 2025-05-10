import 'package:equatable/equatable.dart';
import 'package:ubior/models/user.dart';

/// Profile states
enum ProfileStatus { initial, loading, loaded, error }

/// State for the profile cubit
class ProfileState extends Equatable {
  final ProfileStatus status;
  final User? user;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Initial state when the profile screen is first opened
  factory ProfileState.initial() =>
      const ProfileState(status: ProfileStatus.initial);

  /// Loading state while fetching profile data
  factory ProfileState.loading() =>
      const ProfileState(status: ProfileStatus.loading);

  /// Loaded state with user profile data
  factory ProfileState.loaded(User user) =>
      ProfileState(status: ProfileStatus.loaded, user: user);

  /// Error state when profile data fetch fails
  factory ProfileState.error(String message) =>
      ProfileState(status: ProfileStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, user, errorMessage];

  /// Create a copy of this state with given fields replaced
  ProfileState copyWith({
    ProfileStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Helper to check if state is loading
  bool get isLoading => status == ProfileStatus.loading;
}
