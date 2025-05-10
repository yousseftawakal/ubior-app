import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/cubits/profile/profile_state.dart';
import 'package:ubior/models/user.dart';
import 'package:ubior/services/api_service.dart';

/// Cubit for managing profile screen data
class ProfileCubit extends Cubit<ProfileState> {
  final ApiService _apiService;

  /// Constructor
  ProfileCubit({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(ProfileState.initial());

  /// Fetch the current user's profile
  Future<void> fetchUserProfile() async {
    emit(ProfileState.loading());

    try {
      print('ProfileCubit: Fetching user profile');
      final response = await _apiService.getUserProfile();
      print('ProfileCubit: Got profile response: $response');

      // Debug the structure of the response
      print('ProfileCubit: Response type: ${response.runtimeType}');
      print('ProfileCubit: Response keys: ${response.keys.toList()}');

      // Try to extract user data from different response structures
      Map<String, dynamic>? userData;

      // Check for the API structure shown in the screenshot: { status, data: { user: {...} } }
      if (response.containsKey('status') &&
          response['status'] == 'success' &&
          response.containsKey('data') &&
          response['data'] is Map) {
        print('ProfileCubit: Found standard success response structure');
        var data = response['data'] as Map<String, dynamic>;

        if (data.containsKey('user') && data['user'] is Map) {
          print('ProfileCubit: Found user data in data.user');
          userData = data['user'] as Map<String, dynamic>;
        }
      }
      // Fall back to older parsing logic
      else if (response.containsKey('user') && response['user'] != null) {
        // Standard structure: { user: {...} }
        print('ProfileCubit: User data exists in standard location');
        userData = response['user'] as Map<String, dynamic>;
      } else if (response.containsKey('data') && response['data'] != null) {
        // Alternative structure: { data: { user: {...} } }
        print('ProfileCubit: Response contains data field');
        var data = response['data'];
        if (data is Map && data.containsKey('user')) {
          print('ProfileCubit: User data found in data field');
          userData = data['user'] as Map<String, dynamic>;
        } else if (data is Map) {
          // Maybe the data itself is the user object
          print('ProfileCubit: Trying to use data field as user object');
          userData = data as Map<String, dynamic>;
        }
      } else if (response.keys.isNotEmpty) {
        // Last resort - maybe the response itself is the user object
        print('ProfileCubit: Trying to use response as user object');
        userData = response;
      }

      if (userData != null) {
        try {
          print('ProfileCubit: Creating User from userData: $userData');
          final user = User.fromJson(userData);
          print(
            'ProfileCubit: Created user object: ${user.displayName}, emitting loaded state',
          );
          emit(ProfileState.loaded(user));
        } catch (e) {
          print('ProfileCubit: Error creating User from JSON: $e');
          emit(ProfileState.error('Failed to parse user data'));
        }
      } else {
        print('ProfileCubit: No user data in response');
        emit(ProfileState.error('Failed to load profile data'));
      }
    } catch (e) {
      print('ProfileCubit: Error occurred: $e');

      // Special handling for authentication errors
      if (e.toString().contains('Not authenticated')) {
        print('ProfileCubit: Authentication error - user needs to login');
        emit(ProfileState.error('Please login to view your profile'));
      } else {
        emit(ProfileState.error(e.toString()));
      }
    }
  }

  /// Refresh the profile data
  Future<void> refreshProfile() async {
    if (state.isLoading) return;
    await fetchUserProfile();
  }

  /// Update user profile data
  Future<void> updateUserProfile({
    String? displayName,
    String? username,
    String? email,
    String? bio,
    String? country,
    bool? isPrivate,
  }) async {
    // Don't update if already loading
    if (state.isLoading) return;

    // Create map of data to update (only include non-null values)
    final Map<String, dynamic> updateData = {};

    if (displayName != null) updateData['name'] = displayName;
    if (username != null) updateData['username'] = username;
    if (email != null) updateData['email'] = email;
    if (bio != null) updateData['bio'] = bio;
    if (country != null) updateData['country'] = country;

    // Don't make API call if no data to update
    if (updateData.isEmpty) return;

    // Set loading state
    emit(ProfileState.loading());

    try {
      print('ProfileCubit: Updating user profile with data: $updateData');

      // Call API service to update profile
      final response = await _apiService.updateUserProfile(updateData);
      print('ProfileCubit: Profile update response: $response');

      // After successful update, refresh the profile to get latest data
      await fetchUserProfile();
    } catch (e) {
      print('ProfileCubit: Error updating profile: $e');
      emit(ProfileState.error(e.toString()));
    }
  }

  /// Update user profile picture
  Future<void> updateProfilePicture(String imagePath) async {
    // Implementation for updating profile picture
    // This would typically involve uploading the image to a server
    // For now, just print a message
    print('ProfileCubit: Updating profile picture with image: $imagePath');
    emit(ProfileState.error('Profile picture update not implemented yet'));
  }

  /// Update user cover image
  Future<void> updateCoverImage(String imagePath) async {
    // Implementation for updating cover image
    // This would typically involve uploading the image to a server
    // For now, just print a message
    print('ProfileCubit: Updating cover image with image: $imagePath');
    emit(ProfileState.error('Cover image update not implemented yet'));
  }
}
