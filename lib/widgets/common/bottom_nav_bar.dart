import 'package:flutter/material.dart';
import '../../config/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
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
            _buildNavItem(0, Icons.home_outlined, Icons.home, size: 24),
            _buildNavItem(1, Icons.search_outlined, Icons.search, size: 24),
            _buildNavItem(
              2,
              Icons.add_circle,
              Icons.add_circle,
              size: 48,
              alwaysUseActiveColor: true,
            ),
            _buildNavItem(
              3,
              Icons.table_chart_rounded,
              Icons.table_chart_rounded,
              size: 24,
            ),
            _buildNavItem(4, Icons.person, Icons.person, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon, {
    double size = 24,
    bool alwaysUseActiveColor = false,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          isSelected ? activeIcon : icon,
          size: size,
          color:
              isSelected || alwaysUseActiveColor
                  ? AppTheme.primaryColor
                  : const Color(0xFFC2AD98),
        ),
      ),
    );
  }
}
