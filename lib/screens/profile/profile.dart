import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubior/config/theme.dart';
import 'package:ubior/cubits/profile/profile_cubit.dart';
import 'package:ubior/cubits/profile/profile_state.dart';
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
  final int _currentNavIndex = 4; // Index for Profile in bottom nav bar

  @override
  void initState() {
    super.initState();
    // Fetch profile data when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Profile: Initializing and fetching user profile');
      context.read<ProfileCubit>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            titleSpacing: 18,
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: AppTheme.textPrimaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
            scrolledUnderElevation: 0,
          ),
          body: _buildProfileContent(context, state),
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
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileState state) {
    // Show loading indicator while fetching profile data
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Show error message if there was an error
    if (state.status == ProfileStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load profile', style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            Text(state.errorMessage ?? 'Unknown error'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().refreshProfile(),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Get user data from state or use placeholder if not available yet
    final user = state.user;
    if (user == null) {
      return Center(child: Text('No profile data available'));
    }

    // Display the profile content with actual user data
    return SingleChildScrollView(
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
                    image:
                        user.coverImageUrl != null &&
                                user.coverImageUrl!.startsWith('http')
                            ? NetworkImage(user.coverImageUrl!) as ImageProvider
                            : AssetImage('assets/images/background.png'),
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
                    constraints: BoxConstraints.tightFor(width: 20, height: 20),
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
                        radius: 56,
                        backgroundImage:
                            user.profileImageUrl != null &&
                                    user.profileImageUrl!.startsWith('http')
                                ? NetworkImage(user.profileImageUrl!)
                                    as ImageProvider
                                : AssetImage('assets/images/thomyorke.png'),
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
              user.displayName,
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
              '@${user.username}',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              user.bio ?? '',
              style: TextStyle(fontSize: 16, color: AppTheme.textPrimaryColor),
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
                    child: _buildStat(user.postsCount.toString(), 'Posts'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildStat(
                      user.followersCount > 1000
                          ? '${(user.followersCount / 1000).toStringAsFixed(1)}k'
                          : user.followersCount.toString(),
                      'Followers',
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _buildStat(
                      user.followingCount.toString(),
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
                          style: TextStyle(color: AppTheme.textSecondaryColor),
                        ),
                      ),
                      // Saved tab
                      Center(
                        child: Text(
                          'Saved items will appear here',
                          style: TextStyle(color: AppTheme.textSecondaryColor),
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
