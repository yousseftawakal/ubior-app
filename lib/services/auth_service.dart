import 'package:flutter/foundation.dart';
import 'package:ubior/models/api_response.dart';
import 'package:ubior/models/user.dart';
import 'package:ubior/services/api_service.dart';

class AuthService with ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Set current user
  void _setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Check if user is already logged in on app start
  Future<bool> checkAuthStatus() async {
    _setLoading(true);
    try {
      final response = await _apiService.checkAuthStatus();

      if (response['user'] != null) {
        _setCurrentUser(User.fromJson(response['user']));
        return true;
      } else {
        await _apiService.logout();
        _setCurrentUser(null);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setCurrentUser(null);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register a new user
  Future<ApiResponse<User>> signup(
    String username,
    String email,
    String password,
  ) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.signup({
        'username': username,
        'email': email,
        'password': password,
        'passwordConfirm': password,
      });

      if (response['user'] != null) {
        final user = User.fromJson(response['user']);
        _setCurrentUser(user);
        return ApiResponse.success(data: user, message: 'Signup successful');
      } else {
        throw Exception('Failed to create user account');
      }
    } catch (e) {
      _setError(e.toString());
      return ApiResponse.error(message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Login an existing user
  Future<ApiResponse<User>> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await _apiService.login(email, password);

      if (response['user'] != null) {
        final user = User.fromJson(response['user']);
        _setCurrentUser(user);
        return ApiResponse.success(data: user, message: 'Login successful');
      } else {
        throw Exception('Failed to log in');
      }
    } catch (e) {
      _setError(e.toString());
      return ApiResponse.error(message: e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Logout the current user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _apiService.logout();
      _setCurrentUser(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
