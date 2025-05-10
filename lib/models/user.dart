class User {
  final String id;
  final String username;
  final String displayName;
  final String? bio;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final String? email;
  final bool? isPrivate;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.bio,
    this.profileImageUrl,
    this.coverImageUrl,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.email,
    this.isPrivate,
  });

  // Create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    print('Creating User from JSON: $json');

    // Helper to get values that might have different field names
    T? getField<T>(List<String> possibleFields) {
      for (var field in possibleFields) {
        if (json.containsKey(field) && json[field] != null) {
          print('Found field $field with value: ${json[field]}');
          return json[field] as T;
        }
      }
      print('No matching field found for options: $possibleFields');
      return null;
    }

    // Special handling for photo field which might be a filename
    String? getProfileImage() {
      // First try standard profile image fields
      String? photo = getField<String>([
        'profile_image_url',
        'profileImageUrl',
        'avatar',
        'profilePicture',
        'profile_picture',
        'photo',
      ]);

      print('Profile image original value: $photo');

      // If it's 'default.png' or a simple filename, it might need the base URL prepended
      if (photo != null &&
          (photo == 'default.png' || !photo.startsWith('http'))) {
        String fullUrl = 'https://ubior-api.vercel.app/images/profiles/$photo';
        print('Converting profile image path to full URL: $fullUrl');
        return fullUrl;
      }
      return photo;
    }

    // Parse numbers that might come as strings or integers
    int parseCount(dynamic value) {
      print('Parsing count value: $value (${value?.runtimeType})');
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('Error parsing count: $e');
          return 0;
        }
      }
      return 0;
    }

    // Parse boolean that might come as string, integer, or boolean
    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return null;
    }

    String id =
        getField<String>(['id', '_id', 'userId', 'user_id']) ?? 'unknown';
    print('ID: $id');

    String username =
        getField<String>(['username', 'userName', 'user_name']) ?? 'unknown';
    print('Username: $username');

    String displayName =
        getField<String>([
          'display_name',
          'displayName',
          'name',
          'fullName',
          'full_name',
        ]) ??
        username ??
        'Unknown User';
    print('Display name: $displayName');

    String? bio = getField<String>(['bio', 'biography', 'about']);
    print('Bio: $bio');

    String? profileImageUrl = getProfileImage();
    print('Profile image URL: $profileImageUrl');

    String? coverImageUrl = getField<String>([
      'cover_image_url',
      'coverImageUrl',
      'coverImage',
      'cover_image',
    ]);
    print('Cover image URL: $coverImageUrl');

    int postsCount = parseCount(
      getField([
        'posts_count',
        'postsCount',
        'postCount',
        'post_count',
        'postsCount',
      ]),
    );
    print('Posts count: $postsCount');

    int followersCount = parseCount(
      getField([
        'followers_count',
        'followersCount',
        'followerCount',
        'follower_count',
        'followersCount',
      ]),
    );
    print('Followers count: $followersCount');

    int followingCount = parseCount(
      getField([
        'following_count',
        'followingCount',
        'followedCount',
        'followed_count',
        'followingCount',
      ]),
    );
    print('Following count: $followingCount');

    String? email = getField<String>([
      'email',
      'emailAddress',
      'email_address',
    ]);
    print('Email: $email');

    bool? isPrivate = parseBool(
      getField(['is_private', 'isPrivate', 'private', 'private_account']),
    );
    print('Is private: $isPrivate');

    print('Creating User object with above values');
    return User(
      id: id,
      username: username,
      displayName: displayName,
      bio: bio,
      profileImageUrl: profileImageUrl,
      coverImageUrl: coverImageUrl,
      postsCount: postsCount,
      followersCount: followersCount,
      followingCount: followingCount,
      email: email,
      isPrivate: isPrivate,
    );
  }

  // Convert User to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'cover_image_url': coverImageUrl,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'email': email,
      'is_private': isPrivate,
    };
  }
}
