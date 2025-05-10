import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/cubits/auth/auth_state.dart';
import 'package:ubior/models/user.dart';
import 'package:ubior/services/api_service.dart';
import 'package:ubior/services/token_storage.dart';

/// Cubit for handling authentication logic
class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService;
  final TokenStorage _tokenStorage;

  /// Constructor
  AuthCubit({ApiService? apiService, TokenStorage? tokenStorage})
    : _apiService = apiService ?? ApiService(),
      _tokenStorage = tokenStorage ?? TokenStorage(),
      super(AuthState.initial());

  /// Initialize the auth state
  /// Checks if there's a stored token and validates it
  Future<void> checkAuthStatus() async {
    print('AuthCubit: Checking authentication status');
    emit(AuthState.loading());

    try {
      // First check if we have a token stored
      final hasToken = await _tokenStorage.hasToken();
      print('AuthCubit: Has stored token: $hasToken');

      if (!hasToken) {
        // Check if we have cookies that might authenticate us even without a token
        print('AuthCubit: No token found, checking if we have valid cookies');

        try {
          // Try to validate our session with the server
          final response = await _apiService.checkAuthStatus();
          print('AuthCubit: Auth check response: $response');

          if (response['user'] != null) {
            print('AuthCubit: Valid session found via cookies');
            final user = User.fromJson(response['user']);
            emit(AuthState.authenticated(user));
            return;
          } else {
            print('AuthCubit: No valid session found');
            emit(AuthState.unauthenticated());
            return;
          }
        } catch (e) {
          // Error checking auth status, probably not authenticated
          print('AuthCubit: Error checking auth status: $e');
          emit(AuthState.unauthenticated());
          return;
        }
      }

      // If we have a token, validate it
      try {
        print('AuthCubit: Validating stored token');
        // Validate the token with the backend
        final response = await _apiService.checkAuthStatus();

        if (response['user'] != null) {
          print('AuthCubit: Token validated successfully');
          final user = User.fromJson(response['user']);
          emit(AuthState.authenticated(user));
        } else {
          // Token is invalid or expired
          print('AuthCubit: Token is invalid or expired');
          await _apiService.logout();
          emit(AuthState.unauthenticated());
        }
      } catch (e) {
        // Error validating token
        print('AuthCubit: Error validating token: $e');
        await _apiService.logout();
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      print('AuthCubit: Error in auth check process: $e');
      emit(AuthState.error(e.toString()));
    }
  }

  /// Login with email or username
  Future<void> login(String identifier, String password) async {
    if (!_validateLoginForm(identifier, password)) {
      return;
    }

    emit(AuthState.loading());
    print('Login: Emitted loading state');

    try {
      final response = await _apiService.login(identifier, password);
      print('Login: Got response from API: $response');

      // Debug the structure of the response
      print('Login: Response type: ${response.runtimeType}');
      print('Login: Response keys: ${response.keys.toList()}');

      // Check if we got a token at least
      bool hasToken =
          response.containsKey('token') && response['token'] != null;
      if (hasToken) {
        print('Login: Token found, authentication should be successful');
        print('Login: Token value: ${response['token'].substring(0, 10)}...');

        // Verify token is saved and loaded properly
        final token = await _tokenStorage.getToken();
        print(
          'Login: Token from storage after login: ${token != null ? token.substring(0, 10) + '...' : 'NULL'}',
        );
      }

      // Try to extract user data from different response structures
      Map<String, dynamic>? userData;

      if (response.containsKey('user') && response['user'] != null) {
        // Standard structure: { user: {...} }
        print('Login: User data exists in standard location');
        userData = response['user'] as Map<String, dynamic>;
      } else if (response.containsKey('data') && response['data'] != null) {
        // Alternative structure: { data: { user: {...} } }
        print('Login: Response contains data field');
        var data = response['data'];
        if (data is Map && data.containsKey('user')) {
          print('Login: User data found in data field');
          userData = data['user'] as Map<String, dynamic>;
        } else if (data is Map) {
          // Maybe the data itself is the user object
          print('Login: Trying to use data field as user object');
          userData = data as Map<String, dynamic>;
        }
      } else if (response.keys.isNotEmpty) {
        // Last resort - maybe the response itself is the user object
        print('Login: Trying to use response as user object');
        userData = response;
      }

      User? user;

      if (userData != null) {
        // Make sure user data has the required fields
        if (userData.containsKey('id') && userData.containsKey('username')) {
          print('Login: Valid user data found, creating user object');
          user = User.fromJson(userData);
        } else {
          print('Login: User data is missing required fields');
          print('Login: Available fields: ${userData.keys.toList()}');
        }
      } else {
        print('Login: No user data found in any expected location');
      }

      // If we couldn't extract a user but we have a token, create a temporary user
      if (user == null && hasToken) {
        print('Login: Creating a temporary user since we have a token');
        user = User(
          id: 'temp_user_id',
          username: identifier,
          displayName: 'User',
          email: identifier.contains('@') ? identifier : null,
        );
      }

      if (user != null) {
        print('Login: User object created, emitting authenticated state');
        print('Login: Current state before authentication: ${state.status}');

        // Emit authenticated state
        emit(AuthState.authenticated(user));

        // Debug to ensure state changed
        print('Login: State after authentication: ${state.status}');
        print('Login: User authenticated: ${user.displayName}');
      } else {
        print('Login: Full response for debugging: $response');

        if (response.containsKey('message')) {
          print('Login: Message in response: ${response['message']}');
          emit(AuthState.error(response['message']));
        } else {
          emit(AuthState.error('Failed to login. Please try again.'));
        }
      }
    } catch (e) {
      print('Login: Error occurred: $e');
      emit(AuthState.error(e.toString()));
    }
  }

  /// Validate login form data
  bool _validateLoginForm(String identifier, String password) {
    if (identifier.isEmpty) {
      emit(AuthState.error('Please enter your email or username'));
      return false;
    }

    if (password.isEmpty) {
      emit(AuthState.error('Please enter your password'));
      return false;
    }

    if (password.length < 8) {
      emit(AuthState.error('Password must be at least 8 characters'));
      return false;
    }

    return true;
  }

  /// Register a new user
  Future<void> signup(Map<String, dynamic> userData) async {
    if (!_validateSignupForm(userData)) {
      return;
    }

    emit(AuthState.loading());

    try {
      final response = await _apiService.signup(userData);

      if (response['user'] != null) {
        final user = User.fromJson(response['user']);
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.error('Failed to create account. Please try again.'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Validate signup form data
  bool _validateSignupForm(Map<String, dynamic> userData) {
    if (userData['username']?.isEmpty ?? true) {
      emit(AuthState.error('Please enter a username'));
      return false;
    }

    if (userData['email']?.isEmpty ?? true) {
      emit(AuthState.error('Please enter your email'));
      return false;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(userData['email'])) {
      emit(AuthState.error('Please enter a valid email'));
      return false;
    }

    if (userData['password']?.isEmpty ?? true) {
      emit(AuthState.error('Please enter your password'));
      return false;
    }

    if ((userData['password']?.length ?? 0) < 8) {
      emit(AuthState.error('Password must be at least 8 characters'));
      return false;
    }

    if (userData['passwordConfirm'] != userData['password']) {
      emit(AuthState.error('Passwords do not match'));
      return false;
    }

    return true;
  }

  /// Logout the current user
  Future<void> logout() async {
    emit(AuthState.loading());

    try {
      await _apiService.logout();
      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  /// Delete the current user's account
  Future<void> deleteAccount() async {
    emit(AuthState.loading());
    print('AuthCubit: Attempting to delete account');

    try {
      // Call the API to delete the account
      final response = await _apiService.deleteAccount();
      print('AuthCubit: Delete account API response received: $response');

      // Always log the user out after a delete attempt, even if there was an error
      await _apiService.logout();

      // Set state to unauthenticated
      emit(AuthState.unauthenticated());

      print('AuthCubit: Account deleted successfully');
    } catch (e) {
      print('AuthCubit: Error deleting account: $e');

      // Extract the error message from the exception
      String errorMessage = 'Failed to delete account';
      if (e is Exception) {
        // Extract message from exception
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      // Even on error, we should log the user out for security
      try {
        print('AuthCubit: Logging out after delete error');
        await _apiService.logout();
      } catch (logoutError) {
        print(
          'AuthCubit: Error during logout after delete error: $logoutError',
        );
      }

      // Emit error but user should still be logged out
      print('AuthCubit: Emitting unauthenticatedWithError: $errorMessage');
      emit(AuthState.unauthenticatedWithError(errorMessage));
    }
  }

  /// Show error message
  void showError(String message) {
    emit(AuthState.error(message));
  }

  /// Clear any error messages in the state
  void clearError() {
    if (state.errorMessage != null) {
      emit(
        state.copyWith(
          errorMessage: null,
          status:
              state.user != null
                  ? AuthStatus.authenticated
                  : AuthStatus.unauthenticated,
        ),
      );
    }
  }
}
