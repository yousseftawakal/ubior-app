import 'package:flutter/material.dart';
import 'package:ubior/config/theme.dart';
import '../../models/user.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../config/routes.dart';
import 'settings_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Mock user data for Thom Yorke
  final User _user = User(
    id: 'user123',
    username: 'iloverediohead',
    displayName: 'Thom Yorke',
    bio: 'It wears mewo',
    profileImageUrl: 'assets/images/thomyorke.png',
    coverImageUrl: 'assets/images/profile_background.jpg',
    postsCount: 420,
    followersCount: 8500,
    followingCount: 36,
  );

  final int _currentNavIndex = 4; // Index for Profile in bottom nav bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: AppTheme.textPrimaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover photo
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Cover image
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Camera icon for cover photo
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 37,
                    height: 37,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF6B5347),
                        size: 20,
                      ),
                      onPressed: () {},
                      constraints: BoxConstraints.tightFor(
                        width: 20,
                        height: 20,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // Profile picture
                Positioned(
                  bottom: -40,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 126,
                          backgroundImage: AssetImage(
                            'assets/images/thomyorke.png',
                          ),
                        ),
                      ),

                      // Camera icon for profile picture
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.dividerColor,
                              width: 2,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                            onPressed: () {},
                            constraints: BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Space for profile picture overflow
            SizedBox(height: 45),

            // User info
            Center(
              child: Text(
                _user.displayName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ),
            SizedBox(height: 3),
            Center(
              child: Text(
                '@${_user.username}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                _user.bio ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: _buildStat(_user.postsCount.toString(), 'Posts'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _buildStat(
                        '${(_user.followersCount / 1000).toStringAsFixed(1)}k',
                        'Followers',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: _buildStat(
                        _user.followingCount.toString(),
                        'Following',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelStyle: TextStyle(fontSize: 16),
                    dividerColor: AppTheme.dividerColor,
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: AppTheme.textSecondaryColor,
                    indicatorColor: AppTheme.primaryColor,
                    tabs: [Tab(text: 'Posts'), Tab(text: 'Saved')],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        // Posts tab
                        Center(
                          child: Text(
                            'Posts will appear here',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                        // Saved tab
                        Center(
                          child: Text(
                            'Saved items will appear here',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == _currentNavIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.search);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.createPost);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.studio);
              break;
          }
        },
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
        ),
      ],
    );
  }
}
