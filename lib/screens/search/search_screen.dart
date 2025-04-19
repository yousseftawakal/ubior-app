import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart'; // Import routes
import '../../widgets/common/bottom_nav_bar.dart';
import '../../services/search_service.dart';
import '../../models/user.dart';
import '../../models/outfit.dart';
import '../../models/wardrobe_item.dart';
import '../../widgets/search/search_result_item.dart';

/// Search screen that allows users to search for users, outfits, and wardrobe items.
/// The screen has two main states:
/// 1. Recent searches view - shown when no search is active
/// 2. Search results view - shown when a search query is entered
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  // List of recent searches (pre-populated for demo purposes)
  final List<String> _recentSearches = [
    'Minimalist outfits',
    'Summer dresses',
    'Sustainable fashion',
    'Vintage jeans',
    'Y2K fashion',
    'Gorpcore outfits',
  ];

  // Current navigation index (1 represents the Search tab)
  final int _currentNavIndex = 1;

  // Flag to track if a search is currently active
  bool _isSearching = false;

  // Map to store search results by category
  Map<String, dynamic> _searchResults = {
    'users': <User>[],
    'outfits': <Outfit>[],
    'wardrobeItems': <WardrobeItem>[],
  };

  /// Handles bottom navigation bar tab selection
  void _onNavTap(int index) {
    // Avoid unnecessary navigation if already on the selected tab
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        // Navigate to Feed Screen (index 0)
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        // Already on Search Screen (index 1)
        return;
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
        // Other screens not implemented yet, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation to tab $index not implemented yet'),
          ),
        );
    }
  }

  /// Removes a search term from recent searches list
  void _removeSearch(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  /// Performs a search with the given query
  /// - If query is empty, clears results and shows recent searches
  /// - If query is not empty, adds to recent searches and fetches results
  void _performSearch(String query) {
    if (query.isEmpty) {
      // Clear search results and show recent searches
      setState(() {
        _isSearching = false;
        _searchResults = {
          'users': <User>[],
          'outfits': <Outfit>[],
          'wardrobeItems': <WardrobeItem>[],
        };
      });
      return;
    }

    // Add to recent searches if not already there
    if (!_recentSearches.contains(query) && query.isNotEmpty) {
      setState(() {
        _recentSearches.insert(0, query); // Add at the beginning
        // Keep only the 10 most recent searches
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      });
    }

    // Perform search using the SearchService
    setState(() {
      _isSearching = true;
      _searchResults = SearchService.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 122,
        // Search bar embedded in the app bar
        title: Padding(
          padding: const EdgeInsets.only(top: 66, bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1EDE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search styles, items, users...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                // Show clear button only when text is entered
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch(''); // Clear search
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted:
                  _performSearch, // Perform search when user presses enter
              onChanged: (value) {
                // Update UI to show/hide clear button
                setState(() {});
              },
            ),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conditionally show search results or recent searches
            // based on whether a search is active
            if (_isSearching) _buildSearchResults() else _buildRecentSearches(),
          ],
        ),
      ),
      // Bottom navigation bar for app-wide navigation
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  /// Builds the recent searches view
  /// Shows a list of recent search terms that users can tap to search again
  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Recent Searches" heading
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 12),
            child: const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5C4B3B),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // List of recent search items
          ..._recentSearches.asMap().entries.map((entry) {
            final index = entry.key;
            final search = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  // History icon to indicate this is a past search
                  leading: const Icon(Icons.history, color: Color(0xFFA3826E)),
                  title: Text(
                    search,
                    style: const TextStyle(
                      color: Color(0xFF5C4B3B),
                      fontSize: 16,
                    ),
                  ),
                  // Close button to remove from recent searches
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFA3826E),
                      size: 18,
                    ),
                    onPressed: () => _removeSearch(index),
                  ),
                  // Tap to perform the search again
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Builds the search results view
  /// Displays search results grouped by category (users, outfits, wardrobe items)
  Widget _buildSearchResults() {
    // If no results found, show a message
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Display search results by category
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // USERS SECTION
        if (_searchResults['users']!.isNotEmpty) ...[
          // Section heading for Users
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Users',
              style: TextStyle(
                color: Color(0xFF5C4B3B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Map each user to a SearchResultItem widget
          ..._searchResults['users']!
              .map(
                (User user) => SearchResultItem(
                  title: user.displayName,
                  subtitle: '@${user.username}',
                  icon: Icons.person,
                  onTap: () {
                    // Handle user tap - navigate to user profile
                  },
                  // Show user profile image if available
                  leading:
                      user.profileImageUrl != null
                          ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.profileImageUrl!,
                            ),
                          )
                          : null,
                ),
              )
              .toList(),
        ],

        // OUTFITS SECTION
        if (_searchResults['outfits']!.isNotEmpty) ...[
          // Section heading for Outfits
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Outfits',
              style: TextStyle(
                color: Color(0xFF5C4B3B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Map each outfit to a SearchResultItem widget
          ..._searchResults['outfits']!
              .map(
                (Outfit outfit) => SearchResultItem(
                  title: outfit.name,
                  subtitle: 'By ${outfit.creatorId}',
                  icon: Icons.checkroom,
                  onTap: () {
                    // Handle outfit tap - navigate to outfit details
                  },
                  // Show outfit image thumbnail if available
                  trailing:
                      outfit.imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              outfit.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                          : null,
                ),
              )
              .toList(),
        ],

        // WARDROBE ITEMS SECTION
        if (_searchResults['wardrobeItems']!.isNotEmpty) ...[
          // Section heading for Wardrobe Items
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Wardrobe Items',
              style: TextStyle(
                color: Color(0xFF5C4B3B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Map each wardrobe item to a SearchResultItem widget
          ..._searchResults['wardrobeItems']!
              .map(
                (WardrobeItem item) => SearchResultItem(
                  title: item.name,
                  subtitle: item.category.name,
                  icon: Icons.inventory_2,
                  onTap: () {
                    // Handle wardrobe item tap - navigate to item details
                  },
                  // Show item image thumbnail if available
                  trailing:
                      item.imageUrl != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                          : null,
                ),
              )
              .toList(),
        ],
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    _searchController.dispose();
    super.dispose();
  }
}
