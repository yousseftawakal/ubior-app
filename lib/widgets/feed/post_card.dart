import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../config/theme.dart';

class PostCard extends StatelessWidget {
  final User user;
  final String timeAgo;
  final String imageUrl;
  final List<String> tags;
  final int likesCount;
  final bool isLiked;

  const PostCard({
    super.key,
    required this.user,
    required this.timeAgo,
    required this.imageUrl,
    required this.tags,
    required this.likesCount,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and post time
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      user.profileImageUrl != null
                          ? AssetImage(user.profileImageUrl!)
                          : null,
                  child:
                      user.profileImageUrl == null
                          ? Text(
                            user.displayName[0],
                            style: const TextStyle(fontSize: 16),
                          )
                          : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    timeAgo,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                const Spacer(),
                Icon(Icons.person_add_alt_1_rounded, color: Colors.grey[600]),
              ],
            ),
          ),
          // Post image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          // Tags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children:
                  tags
                      .map(
                        (tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 12),
                          ),
                          padding: EdgeInsets.zero,
                          backgroundColor: AppTheme.secondaryColor,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
            ),
          ),

          // Actions and likes count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.share, size: 20),
                    const Spacer(),
                    const Icon(Icons.bookmark_border, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$likesCount likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
