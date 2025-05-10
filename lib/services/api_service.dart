import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ubior/services/token_storage.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  late Dio _dio;
  final String baseUrl = 'https://ubior-api.vercel.app/api/v1';
  final TokenStorage _tokenStorage = TokenStorage();
  CookieJar? _cookieJar;
  bool _cookieManagerInitialized = false;

  // For storing auth token in memory (fallback)
  String? _authToken;

  // Getter for checking if user is authenticated
  bool get isAuthenticated => _authToken != null;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Enable cookies for browser-like cookie handling
        receiveDataWhenStatusError: true,
        validateStatus:
            (status) =>
                true, // Accept all status codes for proper error handling
      ),
    );

    // Add cookie management
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // We don't add the token in the header anymore as it's handled by cookies
          print('ApiService: Sending request to ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Check for Set-Cookie header and log it
          if (response.headers.map.containsKey('set-cookie')) {
            print('ApiService: Received cookies from server');
            List<String>? cookies = response.headers.map['set-cookie'];
            if (cookies != null) {
              for (var cookie in cookies) {
                if (cookie.contains('jwt=')) {
                  print('ApiService: JWT cookie received');
                }
              }
            }
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Unauthorized - clear token
            print('ApiService: 401 Unauthorized response');
            _clearToken();
          }
          return handler.next(error);
        },
      ),
    );

    // Add logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    // Initialize cookie manager and token from storage
    _initCookieManager();
    _loadTokenFromStorage();
  }

  // Initialize cookie manager
  Future<void> _initCookieManager() async {
    if (!_cookieManagerInitialized) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final cookiePath = "${appDocDir.path}/.cookies/";
        print('ApiService: Setting up persistent cookie jar at $cookiePath');

        _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

        _dio.interceptors.add(CookieManager(_cookieJar!));
        _cookieManagerInitialized = true;
        print('ApiService: Cookie manager initialized');
      } catch (e) {
        print('ApiService: Failed to initialize persistent cookie jar: $e');

        // Fallback to non-persistent cookie jar
        _cookieJar = CookieJar();
        _dio.interceptors.add(CookieManager(_cookieJar!));
        _cookieManagerInitialized = true;
        print('ApiService: Using in-memory cookie jar as fallback');
      }
    }
  }

  // Load token from secure storage on initialization
  Future<void> _loadTokenFromStorage() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      print(
        'ApiService: Loaded token from storage: ${token.substring(0, 10)}...',
      );
      _authToken = token;
    } else {
      print('ApiService: No token found in storage');
    }
  }

  // Set auth token and save to storage
  Future<void> _saveToken(String token) async {
    print('ApiService: Saving token to storage: ${token.substring(0, 10)}...');
    _authToken = token;
    await _tokenStorage.saveToken(token);
  }

  // Clear auth token from memory and storage
  Future<void> _clearToken() async {
    _authToken = null;
    await _tokenStorage.deleteToken();
  }

  // Signup method
  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    try {
      print(
        'ApiService: Sending signup request with data: ${userData.toString()}',
      );

      final response = await _dio.post('/users/signup', data: userData);

      // Store token if returned from API
      if (response.data['token'] != null) {
        await _saveToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      // Handle specific error cases
      if (e.response?.statusCode == 409) {
        throw Exception('User already exists with this email or username');
      }
      throw _handleError(e);
    }
  }

  // Login method
  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      print('ApiService: Sending login request with identifier: $identifier');

      // Make sure cookie jar is initialized
      if (!_cookieManagerInitialized) {
        await _initCookieManager();
      }

      final response = await _dio.post(
        '/users/login',
        data: {'identifier': identifier, 'password': password},
        options: Options(
          // This will ensure cookies are managed properly
          contentType: 'application/json',
          followRedirects: true,
          validateStatus:
              (status) =>
                  true, // Accept all status codes for proper error handling
        ),
      );

      print('ApiService: Login response received: ${response.statusCode}');
      print('ApiService: Response data: ${response.data}');

      // Check if login was successful
      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.data is Map && response.data['message'] != null) {
          throw Exception(response.data['message']);
        } else {
          throw Exception('Login failed: ${response.statusCode}');
        }
      }

      // Print cookie information if available
      if (response.headers.map.containsKey('set-cookie')) {
        print('ApiService: Received auth cookies from login');
        // The cookies are automatically handled by the cookie manager
      }

      // Handle different response structures
      Map<String, dynamic> responseData;

      if (response.data is Map<String, dynamic>) {
        responseData = response.data;
      } else if (response.data is String) {
        // Try to parse the response as JSON if it's a string
        try {
          responseData = json.decode(response.data);
          print('ApiService: Parsed string response to JSON');
        } catch (e) {
          print('ApiService: Failed to parse string response: $e');
          responseData = {'message': 'Invalid response format'};
        }
      } else {
        // Handle unexpected response type
        print(
          'ApiService: Unexpected response type: ${response.data.runtimeType}',
        );
        responseData = {'message': 'Unexpected response format'};
      }

      // Store token if returned from API (as a backup even if cookies are used)
      if (responseData.containsKey('token') && responseData['token'] != null) {
        print('ApiService: Token found in response - storing as backup');
        await _saveToken(responseData['token']);
      } else {
        print(
          'ApiService: No token in response, relying on cookies for authentication',
        );
      }

      return responseData;
    } on DioException catch (e) {
      print('ApiService: DioException during login: ${e.type}');
      print('ApiService: Error message: ${e.message}');
      print('ApiService: Response status: ${e.response?.statusCode}');
      print('ApiService: Response data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      }
      throw _handleError(e);
    } catch (e) {
      print('ApiService: Unexpected error during login: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Call the logout endpoint to clear cookies on the server
      final response = await _dio.get('/users/logout');

      print('ApiService: Logout response: ${response.statusCode}');

      // Clear cookies locally
      if (_cookieJar != null && _cookieJar is PersistCookieJar) {
        final uri = Uri.parse(baseUrl);
        (_cookieJar as PersistCookieJar).deleteAll();
        print('ApiService: Cleared all cookies locally');
      }

      // Clear token as backup measure
      await _clearToken();

      print('ApiService: User logged out successfully');
    } catch (e) {
      print('ApiService: Error during logout: $e');
      // Still clear cookies and token locally even if server request fails
      if (_cookieJar != null && _cookieJar is PersistCookieJar) {
        (_cookieJar as PersistCookieJar).deleteAll();
      }
      await _clearToken();
    }
  }

  // Check authentication status
  Future<Map<String, dynamic>> checkAuthStatus() async {
    try {
      // Make sure cookie jar is initialized
      if (!_cookieManagerInitialized) {
        await _initCookieManager();
      }

      // Ensure cookies are properly loaded
      await _ensureCookiesLoaded();

      // The cookies will be sent automatically with this request
      final response = await _dio.get('/users/authStatus');

      if (response.statusCode == 401) {
        throw Exception('Not authenticated');
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Not authenticated');
      }
      throw _handleError(e);
    }
  }

  // Ensure cookies are properly loaded and available
  Future<void> _ensureCookiesLoaded() async {
    if (_cookieJar == null) {
      print('ApiService: Cookie jar is null, initializing');
      await _initCookieManager();
      return;
    }

    try {
      if (_cookieJar is PersistCookieJar) {
        print('ApiService: Ensuring persistent cookies are loaded');
        // Load cookies from storage if using persistent jar
        final uri = Uri.parse(baseUrl);
        final cookies = await (_cookieJar as PersistCookieJar).loadForRequest(
          uri,
        );

        print('ApiService: Loaded ${cookies.length} cookies');

        // Check if we have an auth token cookie
        bool hasAuthCookie = cookies.any(
          (cookie) =>
              cookie.name == 'jwt' ||
              cookie.name.toLowerCase().contains('auth') ||
              cookie.name.toLowerCase().contains('token'),
        );

        if (hasAuthCookie) {
          print('ApiService: Found auth cookie');
        } else {
          print('ApiService: No auth cookie found');
        }
      } else {
        print('ApiService: Using in-memory cookie jar');
      }
    } catch (e) {
      print('ApiService: Error ensuring cookies: $e');
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      print('ApiService: Getting user profile using cookie authentication');

      // Make sure cookie jar is initialized
      if (!_cookieManagerInitialized) {
        await _initCookieManager();
      }

      // Ensure cookies are properly loaded
      await _ensureCookiesLoaded();

      // With cookie auth, the cookies will be sent automatically with the request
      final response = await _dio.get(
        '/users/me',
        options: Options(
          // Ensure cookies are sent with the request
          followRedirects: true,
          validateStatus:
              (status) => true, // Accept all status codes for proper handling
        ),
      );

      print('ApiService: User profile response code: ${response.statusCode}');

      // Print raw response data for debugging
      if (response.data is Map) {
        print(
          'ApiService: Response data keys: ${(response.data as Map).keys.toList()}',
        );
      } else {
        print('ApiService: Response data type: ${response.data.runtimeType}');
      }

      print('ApiService: Response data: ${response.data}');

      // Handle error responses
      if (response.statusCode == 401) {
        print('ApiService: Not authenticated (401)');
        throw Exception('Not authenticated');
      }

      // Process the response to handle different data structures
      Map<String, dynamic> responseData;

      if (response.data is Map<String, dynamic>) {
        responseData = response.data;

        // Check for the nested structure as shown in the screenshot
        if (responseData.containsKey('status') &&
            responseData.containsKey('data') &&
            responseData['data'] is Map) {
          print(
            'ApiService: Found standard API response structure with status and data',
          );

          if (responseData['data'] is Map &&
              responseData['data'].containsKey('user')) {
            print('ApiService: Found user data in data.user');
            // Return the complete response for flexible handling
            return responseData;
          }
        }
      } else if (response.data is String) {
        // Try to parse the response as JSON if it's a string
        try {
          responseData = json.decode(response.data);
          print('ApiService: Parsed string response to JSON');
        } catch (e) {
          print('ApiService: Failed to parse string response: $e');
          responseData = {'message': 'Invalid response format'};
        }
      } else {
        // Handle unexpected response type
        print(
          'ApiService: Unexpected response type: ${response.data.runtimeType}',
        );
        responseData = {'message': 'Unexpected response format'};
      }

      return responseData;
    } on DioException catch (e) {
      print('ApiService: DioException during get profile: ${e.type}');
      print('ApiService: Error message: ${e.message}');
      print('ApiService: Response status: ${e.response?.statusCode}');
      print('ApiService: Response data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw _handleError(e);
    } catch (e) {
      print('ApiService: Unexpected error getting user profile: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      print('ApiService: Updating user profile with data: $userData');

      // Make sure cookie jar is initialized
      if (!_cookieManagerInitialized) {
        await _initCookieManager();
      }

      // Send PATCH request to the correct updateMe endpoint
      final response = await _dio.patch(
        '/users/updateMe',
        data: userData,
        options: Options(
          followRedirects: true,
          validateStatus: (status) => true,
        ),
      );

      print('ApiService: Update profile response: ${response.statusCode}');
      print('ApiService: Update profile response data: ${response.data}');

      // Handle error responses
      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.data is Map && response.data['message'] != null) {
          throw Exception(response.data['message']);
        } else {
          throw Exception('Failed to update profile: ${response.statusCode}');
        }
      }

      // Process the response
      Map<String, dynamic> responseData;
      if (response.data is Map<String, dynamic>) {
        responseData = response.data;
      } else if (response.data is String) {
        try {
          responseData = json.decode(response.data);
        } catch (e) {
          responseData = {'message': 'Invalid response format'};
        }
      } else {
        responseData = {'message': 'Unexpected response format'};
      }

      return responseData;
    } on DioException catch (e) {
      print('ApiService: DioException updating profile: ${e.type}');
      print('ApiService: Error message: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw _handleError(e);
    } catch (e) {
      print('ApiService: Unexpected error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Delete user account
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      print('ApiService: Deleting user account');

      // Make sure cookie jar is initialized
      if (!_cookieManagerInitialized) {
        await _initCookieManager();
      }

      // Print headers for debugging cookie authentication
      final cookies = await _cookieJar?.loadForRequest(
        Uri.parse('$baseUrl/users/deleteMe'),
      );
      print('ApiService: Cookies being sent with delete request: $cookies');

      // First try the standard endpoint with DELETE method
      try {
        print('ApiService: Trying primary endpoint - DELETE /users/deleteMe');

        // Send DELETE request to the deleteMe endpoint
        final response = await _dio.delete(
          '/users/deleteMe',
          options: Options(
            followRedirects: true,
            validateStatus: (status) => true,
            headers: {
              // Add authorization header as fallback if cookies aren't working
              if (_authToken != null) 'Authorization': 'Bearer $_authToken',
            },
          ),
        );

        print(
          'ApiService: Delete account primary response status: ${response.statusCode}',
        );
        print(
          'ApiService: Delete account primary response headers: ${response.headers}',
        );
        print(
          'ApiService: Delete account primary response data: ${response.data}',
        );

        // If successful, process and return
        if (response.statusCode == 200 || response.statusCode == 204) {
          print('ApiService: Primary endpoint delete successful');
          // Process successful response
          await _handleSuccessfulDeletion();

          // Return response
          return _processDeleteResponse(response);
        }

        // If we get here, the primary endpoint didn't work - try alternatives
        print(
          'ApiService: Primary endpoint failed with status ${response.statusCode}, trying alternatives...',
        );
      } catch (e) {
        print('ApiService: Error with primary endpoint: $e');
        // Continue to try alternative endpoints
      }

      // Try alternative endpoint 1: POST method with action parameter
      try {
        print(
          'ApiService: Trying alternative endpoint 1 - POST /users/account with action=delete',
        );

        final altResponse1 = await _dio.post(
          '/users/account',
          data: {'action': 'delete'},
          options: Options(
            followRedirects: true,
            validateStatus: (status) => true,
            headers: {
              if (_authToken != null) 'Authorization': 'Bearer $_authToken',
            },
          ),
        );

        print(
          'ApiService: Alternative 1 response status: ${altResponse1.statusCode}',
        );
        print('ApiService: Alternative 1 response data: ${altResponse1.data}');

        if (altResponse1.statusCode == 200 || altResponse1.statusCode == 204) {
          print('ApiService: Alternative 1 endpoint delete successful');
          await _handleSuccessfulDeletion();
          return _processDeleteResponse(altResponse1);
        }
      } catch (e) {
        print('ApiService: Error with alternative endpoint 1: $e');
      }

      // Try alternative endpoint 2: PATCH method with active=false
      try {
        print(
          'ApiService: Trying alternative endpoint 2 - PATCH /users/me with active=false',
        );

        final altResponse2 = await _dio.patch(
          '/users/me',
          data: {'active': false},
          options: Options(
            followRedirects: true,
            validateStatus: (status) => true,
            headers: {
              if (_authToken != null) 'Authorization': 'Bearer $_authToken',
            },
          ),
        );

        print(
          'ApiService: Alternative 2 response status: ${altResponse2.statusCode}',
        );
        print('ApiService: Alternative 2 response data: ${altResponse2.data}');

        if (altResponse2.statusCode == 200) {
          print('ApiService: Alternative 2 endpoint deactivation successful');
          await _handleSuccessfulDeletion();
          return {'message': 'Account deactivated successfully'};
        }
      } catch (e) {
        print('ApiService: Error with alternative endpoint 2: $e');
      }

      // All attempts failed, throw exception with detailed error
      throw Exception(
        'Failed to delete account: All deletion methods failed. Please contact support.',
      );
    } on DioException catch (e) {
      print('ApiService: DioException deleting account: ${e.type}');
      print('ApiService: Error message: ${e.message}');
      print('ApiService: Error response status: ${e.response?.statusCode}');
      print('ApiService: Error response data: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception('You do not have permission to delete this account.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Account not found or already deleted.');
      }

      throw _handleError(e);
    } catch (e) {
      print('ApiService: Unexpected error deleting account: $e');
      throw Exception('Failed to delete account: $e');
    }
  }

  // Helper method to handle successful account deletion
  Future<void> _handleSuccessfulDeletion() async {
    // Clear token and cookies after successful deletion
    await _clearToken();

    // Clear cookies if cookie jar is available
    if (_cookieManagerInitialized && _cookieJar != null) {
      await _cookieJar!.deleteAll();
      print('ApiService: Cleared all cookies after account deletion');
    }
  }

  // Helper method to process delete response
  Map<String, dynamic> _processDeleteResponse(Response response) {
    // Process the response
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String && response.data.isNotEmpty) {
      try {
        return json.decode(response.data);
      } catch (e) {
        return {'message': 'Account deleted successfully'};
      }
    } else {
      // For 204 No Content or empty responses
      return {'message': 'Account deleted successfully'};
    }
  }

  // Helper method to standardize error handling
  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception(
        'Connection timeout. Please check your internet connection.',
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection');
    }

    // Handle server errors
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    if (statusCode != null) {
      String message = 'Server error: $statusCode';
      if (responseData is Map && responseData['message'] != null) {
        message = responseData['message'];
      }
      return Exception(message);
    }

    return Exception('An error occurred: ${e.message}');
  }
}
