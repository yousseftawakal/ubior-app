import 'package:flutter/material.dart';
import 'package:ubior/config/routes.dart';
import '../../config/theme.dart';
import '../../models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  int _selectedTab = 0; // 0: Attach, 1: Studio

  // Mock user data (same as profile)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        // shape: ,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF59463D)),
          onPressed:
              () => Navigator.pushReplacementNamed(context, AppRoutes.home),
        ),
        title: Text(
          'New Post',
          style: TextStyle(
            color: Color(0xFF59463D),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff6B5347),
                foregroundColor: const Color(0xffF9F7F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Color(0xffF9F7F4),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(_user.profileImageUrl!),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF59463D),
                          ),
                        ),
                        Text(
                          '@${_user.username}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA3826E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Color(0xFFE6DFD3)),

              // Animated tab bar (Attach/Studio)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double tabWidth = (constraints.maxWidth) / 2;
                    return Container(
                      height: 37,
                      width: constraints.maxWidth,
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
                            left: _selectedTab == 0 ? 0 : tabWidth,
                            top: 0,
                            bottom: 0,
                            width: tabWidth,
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
                              // Attach tab
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _selectedTab = 0),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _selectedTab == 0
                                                ? Colors.white
                                                : AppTheme.textPrimaryColor,
                                      ),
                                      child: const Text('Attach'),
                                    ),
                                  ),
                                ),
                              ),
                              // Studio tab
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _selectedTab = 1),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _selectedTab == 1
                                                ? Colors.white
                                                : AppTheme.textPrimaryColor,
                                      ),
                                      child: const Text('Studio'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Tab content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child:
                    _selectedTab == 0 ? _buildAttachTab() : _buildStudioTab(),
              ),

              const SizedBox(height: 24),

              // Caption field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _captionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write a caption...',
                    hintStyle: TextStyle(
                      color: Color(0xFF71717A),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE6DFD3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE6DFD3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFD5C8B7),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1EDE7),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tags field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      size: 24,
                      Icons.local_offer_outlined,
                      color: Color(0xFFA3826E),
                    ),
                    hintText: 'Add tags...',
                    hintStyle: TextStyle(
                      color: Color(0xFF71717A),
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE6DFD3),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFE6DFD3),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFD5C8B7),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1EDE7),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachTab() {
    return Row(
      children: [
        _buildAttachCard(
          icon: Icons.photo_camera_outlined,
          title: 'Camera',
          description: 'Take a new photo',
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _buildAttachCard(
          icon: Icons.photo_outlined,
          title: 'Gallery',
          description: 'Choose from photos',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildStudioTab() {
    return Row(
      children: [
        _buildAttachCard(
          iconWidget: SvgPicture.asset(
            'assets/icons/item_icon.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(Color(0xFFA3826E), BlendMode.srcIn),
          ),
          title: 'Item',
          description: 'Choose an item',
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _buildAttachCard(
          iconWidget: SvgPicture.asset(
            'assets/icons/suit_icon.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(Color(0xFFA3826E), BlendMode.srcIn),
          ),
          title: 'Outfit',
          description: 'Choose an outfit',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAttachCard({
    IconData? icon,
    Widget? iconWidget,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 143,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE6DFD3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFF1EDE7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:
                      iconWidget ??
                      Icon(icon, size: 24, color: Color(0xFFA3826E)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF59463D),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(color: Color(0xFFA3826E), fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
}
