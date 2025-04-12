import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../config/theme.dart';

class CreatePostCard extends StatelessWidget {
  final User user;

  const CreatePostCard({super.key, required this.user});

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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User prompt
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:
                    user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                child:
                    user.profileImageUrl == null
                        ? Text(
                          user.displayName[0],
                          style: const TextStyle(fontSize: 16),
                        )
                        : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Share your style',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'What are you wearing today?',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Attach'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimaryColor,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_on),
                  label: const Text('Studio'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textPrimaryColor,
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
