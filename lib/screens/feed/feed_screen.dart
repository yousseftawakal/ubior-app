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
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', width: 88, height: 38),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Animated Custom Tab Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 37,
              width: 392,
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
                    left:
                        _selectedTabIndex == 0
                            ? 0
                            : MediaQuery.of(context).size.width / 2 - 16,
                    top: 0,
                    bottom: 0,
                    width: MediaQuery.of(context).size.width / 2 - 16,
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

          // Feed content
          Expanded(
            child:
                _selectedTabIndex == 0
                    ? const ForYouFeed()
                    : const FollowingFeed(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class ForYouFeed extends StatelessWidget {
  const ForYouFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyDataService.getCurrentUser();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Create post card
        CreatePostCard(user: user),
        const SizedBox(height: 16),

        // Posts
        ...DummyDataService.users
            .where((u) => u.id != user.id)
            .map(
              (poster) => Column(
                children: [
                  PostCard(
                    user: poster,
                    timeAgo: '2 HOURS AGO',
                    imageUrl: 'https://example.com/post-image.jpg',
                    tags: const ['Evening', 'Elegant', 'Date Night'],
                    likesCount: 5453,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
      ],
    );
  }
}

class FollowingFeed extends StatelessWidget {
  const FollowingFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DummyDataService.getCurrentUser();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Create post card
        CreatePostCard(user: user),
        const SizedBox(height: 16),

        // Message when not following anyone or no posts
        if (user.followingCount == 0)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 48.0),
              child: Text(
                'Follow people to see their posts here',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }
}
