import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart'; // Import routes
import '../../services/dummy_data.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/create_post_card.dart';
import '../../widgets/common/bottom_nav_bar.dart';

/// The main feed screen of the application
///
/// Displays a chronological feed of posts from other users
/// Has two tabs: "For You" (personalized content) and "Following" (content from followed users)
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  /// Index of the currently selected tab (0: "For You", 1: "Following")
  int _selectedTabIndex = 0;

  /// Current navigation index (0 represents the Feed tab in the bottom nav bar)
  int _currentNavIndex = 0;

  /// Handles navigation when a bottom navigation tab is tapped
  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        // Already on Feed Screen
        return;
      case 1:
        // Navigate to Search Screen
        Navigator.pushReplacementNamed(context, AppRoutes.search);
        break;
      case 2:
        // Handle create post - modal or navigate to create screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create post feature coming soon')),
        );
        break;
      case 3:
        // Handle create post - modal or navigate to create screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Create post feature coming soon')),
        );
      case 4:
        // Navigate to Profile screen
        Navigator.pushReplacementNamed(context, AppRoutes.profile);
        break;
      default:
        // Other screens not implemented yet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation to tab $index not implemented yet'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 122,
        title: Padding(
          padding: const EdgeInsets.only(top: 64.0, left: 24, bottom: 20),
          child: Image.asset('assets/images/logo.png', width: 88, height: 38),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 64.0, right: 24, bottom: 20),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom tab bar with animation for switching between "For You" and "Following"
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: 37,
                width: screenWidth - 48, // Adjust width based on screen size
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withAlpha(150),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Animated indicator that slides to show the selected tab
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      left: _selectedTabIndex == 0 ? 0 : (screenWidth - 48) / 2,
                      top: 0,
                      bottom: 0,
                      width: (screenWidth - 48) / 2,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    // Tab buttons row
                    Row(
                      children: [
                        // "For You" tab
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTabIndex = 0),
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _selectedTabIndex == 0
                                          ? Colors.white
                                          : AppTheme.textPrimaryColor,
                                ),
                                child: const Text('For you'),
                              ),
                            ),
                          ),
                        ),
                        // "Following" tab
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTabIndex = 1),
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      _selectedTabIndex == 1
                                          ? Colors.white
                                          : AppTheme.textPrimaryColor,
                                ),
                                child: const Text('Following'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Main feed content area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Create post card (allows users to create new posts)
                  CreatePostCard(user: DummyDataService.getCurrentUser()),
                  const SizedBox(height: 16),

                  // Display content based on selected tab
                  _selectedTabIndex == 0
                      ? _buildForYouContent()
                      : _buildFollowingContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  /// Builds the content for the "For You" tab
  ///
  /// Displays a personalized feed of posts from various users
  /// Currently uses dummy data for demonstration purposes
  Widget _buildForYouContent() {
    return Column(
      children: [
        ...DummyDataService.users
            .where((u) => u.id != DummyDataService.getCurrentUser().id)
            .map(
              (u) => Column(
                children: [
                  PostCard(
                    user: u,
                    timeAgo: '. 2 HOURS AGO',
                    imageUrl: 'assets/images/macdemarco.png',
                    tags: const ['Evening', 'Elegant', 'Date Night'],
                    likesCount: 5453,
                    isLiked: true,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
      ],
    );
  }

  /// Builds the content for the "Following" tab
  ///
  /// Displays posts only from users that the current user follows
  /// Shows an empty state message if the user isn't following anyone
  Widget _buildFollowingContent() {
    final user = DummyDataService.getCurrentUser();

    return user.followingCount == 0
        ? const Padding(
          padding: EdgeInsets.only(top: 48.0),
          child: Center(
            child: Text(
              'Follow people to see their posts here',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        )
        : Column(children: const []);
  }
}
