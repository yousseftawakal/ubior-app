import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../models/wardrobe_item.dart';
import '../../models/outfit.dart';
import '../../models/closet.dart';
import '../../services/dummy_data.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _currentNavIndex = 3; // Index for Studio in bottom nav bar

  // Variables to store user's data
  late List<WardrobeItem> _wardrobeItems;
  late List<Outfit> _outfits;
  late List<Closet> _closets;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize with dummy data - would be replaced with API calls in production
    _loadUserData();
  }

  // Load user data from the service
  void _loadUserData() {
    final user = DummyDataService.getCurrentUser();

    setState(() {
      _wardrobeItems = DummyDataService.getUserWardrobeItems(user.id);
      _outfits = DummyDataService.getUserOutfits(user.id);
      _closets = DummyDataService.getUserClosets(user.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.only(top: 16, left: 20),
          child: Text(
            'Studio',
            style: TextStyle(
              color: Color(0xFF59463D),
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // TabBar in body
          Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE6DFD3), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(
                    230,
                    223,
                    211,
                    0.5,
                  ), // E6DFD3 with 50% opacity
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF59463D),
              unselectedLabelColor: AppTheme.textSecondaryColor,
              indicatorColor: Color(0xFF59463D),
              indicatorWeight: 3,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Wardrobe'),
                Tab(text: 'Outfits'),
                Tab(text: 'Closets'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Wardrobe Tab
                _buildWardrobeTab(),

                // Outfits Tab
                _buildOutfitsTab(),

                // Closets Tab
                _buildClosetsTab(),
              ],
            ),
          ),
        ],
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
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }

  // Wardrobe Tab - Displays all clothing items
  Widget _buildWardrobeTab() {
    if (_wardrobeItems.isEmpty) {
      return _buildEmptyState(
        'Your wardrobe is empty',
        'Add your first clothing item to start building your digital wardrobe',
        Icons.checkroom,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item count and add button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_wardrobeItems.length} items',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF59463D),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  side: BorderSide(color: Color(0xFFD5C8B7), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => _showAddItemDialog(),
                icon: Icon(Icons.add, size: 20, color: Color(0xFF59463D)),
                label: Text(
                  'Add Item',
                  style: TextStyle(
                    color: Color(0xFF59463D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Categories filter chips
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF59463D),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Tops', false),
                _buildFilterChip('Bottoms', false),
                _buildFilterChip('Dresses', false),
                _buildFilterChip('Outerwear', false),
                _buildFilterChip('Footwear', false),
                _buildFilterChip('Accessories', false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Grid of wardrobe items
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _wardrobeItems.length,
              itemBuilder: (context, index) {
                final item = _wardrobeItems[index];
                return _buildWardrobeItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Outfits Tab - Displays all outfits
  Widget _buildOutfitsTab() {
    if (_outfits.isEmpty) {
      return _buildEmptyState(
        'No outfits yet',
        'Create your first outfit by combining items from your wardrobe',
        Icons.style,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item count and add button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_outfits.length} outfits',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF59463D),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  side: BorderSide(color: Color(0xFFD5C8B7), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => _showAddItemDialog(),
                icon: Icon(Icons.add, size: 20, color: Color(0xFF59463D)),
                label: Text(
                  'Create Outfit',
                  style: TextStyle(
                    color: Color(0xFF59463D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Grid of outfits
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _outfits.length,
              itemBuilder: (context, index) {
                final outfit = _outfits[index];
                return _buildOutfitCard(outfit);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Closets Tab - Displays all closets/collections
  Widget _buildClosetsTab() {
    if (_closets.isEmpty) {
      return _buildEmptyState(
        'No closets yet',
        'Create closets to organize your wardrobe by season, occasion, or any category',
        Icons.grid_view,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item count and add button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_closets.length} closets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF59463D),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  side: BorderSide(color: Color(0xFFD5C8B7), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => _showAddItemDialog(),
                icon: Icon(Icons.add, size: 20, color: Color(0xFF59463D)),
                label: Text(
                  'Create Closet',
                  style: TextStyle(
                    color: Color(0xFF59463D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // List of closets
          Expanded(
            child: ListView.builder(
              itemCount: _closets.length,
              itemBuilder: (context, index) {
                final closet = _closets[index];
                return _buildClosetCard(closet);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Empty state placeholder for tabs with no items
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF1EDE7),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: Color(0xFFA3826E)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF59463D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 16, color: Color(0xFFA3826E)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showAddItemDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF59463D),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter chip for wardrobe categories
  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle filter change
        },
        backgroundColor: Colors.white,
        selectedColor: Color(0xFF6B5347),
        showCheckmark: false,
        labelStyle: TextStyle(
          fontSize: 14,
          color: isSelected ? Color(0xFFF9F7F4) : Color(0xFF6B5347),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Color(0xFF59463D) : Color(0xFFE6DFD3),
            width: 1,
          ),
        ),
      ),
    );
  }

  // Wardrobe item card
  Widget _buildWardrobeItemCard(WardrobeItem item) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFE5E0D9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image or placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image:
                    item.imageUrl != null
                        ? DecorationImage(
                          image: NetworkImage(item.imageUrl!),
                          fit: BoxFit.cover,
                        )
                        : null,
                color: item.imageUrl == null ? Color(0xFFF1EDE7) : null,
              ),
              child:
                  item.imageUrl == null
                      ? Center(
                        child: Icon(
                          _getCategoryIcon(item.category),
                          size: 40,
                          color: Color(0xFFA3826E),
                        ),
                      )
                      : null,
            ),
          ),

          // Item details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF59463D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.category.name,
                  style: TextStyle(fontSize: 14, color: Color(0xFFA3826E)),
                ),
                const SizedBox(height: 4),
                if (item.brand != null)
                  Text(
                    item.brand!,
                    style: TextStyle(fontSize: 12, color: Color(0xFFA3826E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Outfit card
  Widget _buildOutfitCard(Outfit outfit) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFE5E0D9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outfit image or placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image:
                    outfit.imageUrl != null
                        ? DecorationImage(
                          image: NetworkImage(outfit.imageUrl!),
                          fit: BoxFit.cover,
                        )
                        : null,
                color: outfit.imageUrl == null ? Color(0xFFF1EDE7) : null,
              ),
              child:
                  outfit.imageUrl == null
                      ? Center(
                        child: Icon(
                          Icons.checkroom,
                          size: 40,
                          color: Color(0xFFA3826E),
                        ),
                      )
                      : null,
            ),
          ),

          // Outfit details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  outfit.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF59463D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (outfit.occasion != null)
                  Text(
                    outfit.occasion!,
                    style: TextStyle(fontSize: 14, color: Color(0xFFA3826E)),
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.inventory_2, size: 14, color: Color(0xFFA3826E)),
                    const SizedBox(width: 4),
                    Text(
                      '${outfit.itemIds.length} items',
                      style: TextStyle(fontSize: 12, color: Color(0xFFA3826E)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Closet card
  Widget _buildClosetCard(Closet closet) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color(0xFFE5E0D9), width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to closet details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Closet thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF1EDE7),
                  image:
                      closet.imageUrl != null
                          ? DecorationImage(
                            image: NetworkImage(closet.imageUrl!),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
                child:
                    closet.imageUrl == null
                        ? Icon(
                          Icons.grid_view,
                          size: 32,
                          color: Color(0xFFA3826E),
                        )
                        : null,
              ),

              const SizedBox(width: 16),

              // Closet details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      closet.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF59463D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (closet.description != null)
                      Text(
                        closet.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA3826E),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${closet.itemIds.length} items',
                      style: TextStyle(fontSize: 14, color: Color(0xFFA3826E)),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFA3826E)),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to add a new item
  void _showAddItemDialog() {
    final currentTab = _tabController.index;
    String title = 'Add Item'; // Default initialization

    switch (currentTab) {
      case 0:
        title = 'Add Wardrobe Item';
        break;
      case 1:
        title = 'Create Outfit';
        break;
      case 2:
        title = 'Create Closet';
        break;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(
              'This feature will be implemented in a future update.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Helper function to get the appropriate icon for a clothing category
  IconData _getCategoryIcon(ClothingCategory category) {
    switch (category) {
      case ClothingCategory.tops:
        return Icons.accessibility_new;
      case ClothingCategory.bottoms:
        return Icons.accessibility;
      case ClothingCategory.dresses:
        return Icons.accessibility_new;
      case ClothingCategory.outerwear:
        return Icons.airline_seat_flat;
      case ClothingCategory.footwear:
        return Icons.shopping_bag;
      case ClothingCategory.accessories:
        return Icons.watch;
    }
  }
}
