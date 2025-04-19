import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';

/// Bottom navigation bar component used throughout the app
/// Provides consistent navigation between main app sections:
/// - Home/Feed
/// - Search
/// - Create (add new content)
/// - Studio (wardrobe management)
/// - Profile
class BottomNavBar extends StatelessWidget {
  /// The currently selected tab index
  final int currentIndex;

  /// Callback function triggered when a tab is tapped
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF9F7F4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home/Feed tab
            _buildNavItem(
              context,
              0,
              Icons.home,
              Icons.home,
              AppRoutes.home,
              size: 24,
            ),
            // Search tab
            _buildNavItem(
              context,
              1,
              Icons.search_outlined,
              Icons.search,
              AppRoutes.search,
              size: 24,
            ),
            // Create/Add tab (center, larger button)
            _buildNavItem(
              context,
              2,
              Icons.add_circle_rounded,
              Icons.add_circle_rounded,
              '',
              size: 48,
              alwaysUseActiveColor: true,
            ),
            // Studio/Wardrobe tab
            _buildNavItem(
              context,
              3,
              Icons.table_chart_rounded,
              Icons.table_chart_rounded,
              AppRoutes.studio,
              size: 24,
            ),
            // Profile tab
            _buildNavItem(
              context,
              4,
              Icons.person_outline,
              Icons.person,
              AppRoutes.profile,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual navigation item/tab
  ///
  /// Parameters:
  /// - context: The build context
  /// - index: The index of this navigation item
  /// - icon: The icon to display when the item is not selected
  /// - activeIcon: The icon to display when the item is selected
  /// - route: The route to navigate to when this item is tapped
  /// - size: The size of the icon
  /// - alwaysUseActiveColor: Whether to always use the active color (useful for special items like the add button)
  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    String route, {
    double size = 24,
    bool alwaysUseActiveColor = false,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        if (index == 2) {
          // Special case for add button - doesn't navigate, just triggers callback
          onTap(index);
        } else if (route.isNotEmpty) {
          // Navigate to the specified route and update the selected index
          Navigator.of(context).pushReplacementNamed(route);
          onTap(index);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          isSelected ? activeIcon : icon,
          size: size,
          color:
              isSelected || alwaysUseActiveColor
                  ? AppTheme
                      .primaryColor // Active/selected color
                  : const Color(0xFFC2AD98), // Inactive color
        ),
      ),
    );
  }
}
