import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// A reusable widget to display search results in a consistent format
///
/// Used to present various types of search results (users, outfits, wardrobe items)
/// with a standardized appearance while allowing customization for different content types.
/// The widget provides a container with proper styling, spacing, and layout for search results.
class SearchResultItem extends StatelessWidget {
  /// The primary text displayed in the search result (e.g., user name, outfit name)
  final String title;

  /// Optional secondary text displayed below the title (e.g., username, category)
  final String? subtitle;

  /// Icon to display when no custom leading widget is provided
  final IconData icon;

  /// Optional color for the default icon
  final Color? iconColor;

  /// Callback function triggered when the item is tapped
  final VoidCallback onTap;

  /// Optional custom widget to display at the start/left of the item
  /// If provided, replaces the default icon container
  final Widget? leading;

  /// Optional custom widget to display at the end/right of the item
  /// Useful for displaying thumbnails, status indicators, etc.
  final Widget? trailing;

  const SearchResultItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    required this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
          child: ListTile(
            leading:
                leading ??
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withAlpha(150),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor ?? AppTheme.primaryColor),
                ),
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5C4B3B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle:
                subtitle != null
                    ? Text(
                      subtitle!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    )
                    : null,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
