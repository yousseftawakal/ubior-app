import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../config/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreatePostCard extends StatelessWidget {
  final User user;

  const CreatePostCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User prompt section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null,
                  child:
                      user.profileImageUrl == null
                          ? Text(
                            user.displayName[0],
                            style: const TextStyle(fontSize: 20),
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share your style',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What are you wearing today?',
                        style: TextStyle(
                          color: Colors.brown[300],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, thickness: 1, color: Color(0xFFE6DFD3)),

          // Bottom section with buttons and vertical divider - simplified approach
          Expanded(
            child: Row(
              children: [
                // Left button (Attach)
                Expanded(
                  child: Center(
                    child: _buildCircularButton(
                      context,
                      label: 'Attach',
                      icon: FontAwesomeIcons.paperclip,
                      onTap: () {},
                    ),
                  ),
                ),

                // Vertical divider
                Container(
                  height: double.infinity,
                  width: 1,
                  color: Color(0xFFE6DFD3),
                ),

                // Right button (Studio)
                Expanded(
                  child: Center(
                    child: _buildCircularButton(
                      context,
                      icon: Icons.table_chart_rounded,
                      label: 'Studio',
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.brown[400], size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: AppTheme.textPrimaryColor, fontSize: 14),
        ),
      ],
    );
  }
}
