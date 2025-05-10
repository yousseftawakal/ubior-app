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
  });

  // Create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      displayName: json['display_name'],
      bio: json['bio'],
      profileImageUrl: json['profile_image_url'],
      coverImageUrl: json['cover_image_url'],
      postsCount: json['posts_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      email: json['email'],
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
    };
  }
}
