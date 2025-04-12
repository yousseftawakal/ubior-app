import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/dummy_data.dart';
import '../../widgets/feed/post_card.dart';
import '../../widgets/feed/create_post_card.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTabIndex = 0;
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // In a real app, we would navigate to different screens
    // For now, just showing a message
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigation to tab $index not implemented yet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Animated Custom Tab Bar
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
                    // Animated Selection Indicator
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
                    // Tab Options
                    Row(
                      children: [
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

            // Create post card and content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Create post card
                  CreatePostCard(user: DummyDataService.getCurrentUser()),
                  const SizedBox(height: 16),

                  // Feed content based on selected tab
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

  Widget _buildForYouContent() {
    return Column(
      children: [
        ...DummyDataService.users
            .where((u) => u.id != DummyDataService.getCurrentUser().id)
            .map(
              (poster) => Column(
                children: [
                  PostCard(
                    user: poster,
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
