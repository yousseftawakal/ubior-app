import 'package:equatable/equatable.dart';
import 'package:ubior/models/user.dart';

/// Authentication states
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// The state for the auth cubit
class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Initial state when the app starts
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  /// Loading state during authentication operations
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  /// Authenticated state when the user is logged in
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  /// Unauthenticated state when the user is not logged in
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Unauthenticated state with an error message
  factory AuthState.unauthenticatedWithError(String message) =>
      AuthState(status: AuthStatus.unauthenticated, errorMessage: message);

  /// Error state when authentication operations fail
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);

  @override
  List<Object?> get props => [status, user, errorMessage];

  /// Create a copy of this state with the given fields replaced
  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Helper method to check if the state is in loading status
  bool get isLoading => status == AuthStatus.loading;

  /// Helper method to check if the state is in authenticated status
  bool get isAuthenticated => status == AuthStatus.authenticated;
}
