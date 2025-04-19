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
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.secondaryColor,
                  backgroundImage:
                      user.profileImageUrl != null
                          ? AssetImage(user.profileImageUrl!)
                          : null,
                  child:
                      user.profileImageUrl == null
                          ? Text(
                            user.displayName[0],
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                // Text prompt
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share your style',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What are you wearing today?',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, thickness: 1, color: AppTheme.dividerColor),

          // Bottom section with buttons
          Container(
            height: 84,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left button (Attach)
                _buildActionButton(
                  context,
                  label: 'Attach',
                  icon: FontAwesomeIcons.paperclip,
                  onTap: () {
                    // Handle attach action
                  },
                ),

                // Vertical divider
                Container(height: 90, width: 1, color: AppTheme.dividerColor),

                // Right button (Studio)
                _buildActionButton(
                  context,
                  icon: Icons.table_chart_rounded,
                  label: 'Studio',
                  onTap: () {
                    // Handle studio action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
