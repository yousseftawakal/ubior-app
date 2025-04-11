import '../models/user.dart';
import '../models/wardrobe_item.dart';
import '../models/outfit.dart';
import '../models/closet.dart';

/// Provides mock data for development until backend API is available
class DummyDataService {
  // Mock users
  static final List<User> users = [
    User(
      id: '1',
      username: 'iloveradiohead',
      displayName: 'Thom Yorke',
      bio: 'It wears mewo',
      profileImageUrl: 'https://example.com/thom.jpg',
      coverImageUrl: 'https://example.com/cover.jpg',
      postsCount: 420,
      followersCount: 8500,
      followingCount: 36,
    ),
    User(
      id: '2',
      username: 'macdemarco',
      displayName: 'Mac Demarco',
      bio: 'Indie artist',
      profileImageUrl: 'https://example.com/mac.jpg',
      postsCount: 210,
      followersCount: 12000,
      followingCount: 184,
    ),
  ];

  // Mock wardrobe items
  static final List<WardrobeItem> wardrobeItems = [
    WardrobeItem(
      id: '1',
      name: 'White Shirt',
      category: ClothingCategory.tops,
      brand: 'Uniqlo',
      color: 'White',
      tags: ['Casual', 'Formal', 'Versatile'],
    ),
    WardrobeItem(
      id: '2',
      name: 'Blue Jeans',
      category: ClothingCategory.bottoms,
      brand: 'Levi\'s',
      color: 'Blue',
      tags: ['Casual', 'Everyday'],
    ),
    WardrobeItem(
      id: '3',
      name: 'Black Blazer',
      category: ClothingCategory.outerwear,
      brand: 'Zara',
      color: 'Black',
      tags: ['Formal', 'Work'],
    ),
    WardrobeItem(
      id: '4',
      name: 'Sneakers',
      category: ClothingCategory.footwear,
      brand: 'Nike',
      color: 'White',
      tags: ['Casual', 'Sport'],
    ),
  ];

  // Mock outfits
  static final List<Outfit> outfits = [
    Outfit(
      id: '1',
      name: 'Business Casual',
      description: 'Perfect for office days',
      creatorId: '1',
      itemIds: ['1', '2', '3'],
      tags: ['Work', 'Business Casual'],
      occasion: 'Work',
      season: 'All Season',
    ),
    Outfit(
      id: '2',
      name: 'Weekend Brunch',
      description: 'Relaxed weekend outfit',
      creatorId: '1',
      itemIds: ['1', '2', '4'],
      tags: ['Casual', 'Weekend'],
      occasion: 'Casual',
      season: 'Spring',
    ),
    Outfit(
      id: '3',
      name: 'Date Night',
      description: 'Evening outfit for dates',
      creatorId: '1',
      itemIds: ['1', '2', '3'],
      tags: ['Evening', 'Elegant', 'Date Night'],
      occasion: 'Evening',
      season: 'All Season',
    ),
    Outfit(
      id: '4',
      name: 'Casual Friday',
      description: 'Relaxed office look',
      creatorId: '1',
      itemIds: ['1', '2', '4'],
      tags: ['Work', 'Casual', 'Friday'],
      occasion: 'Work',
      season: 'All Season',
    ),
  ];

  // Mock closets
  static final List<Closet> closets = [
    Closet(
      id: '1',
      name: 'Everyday Wear',
      ownerId: '1',
      itemIds: ['1', '2', '4'],
    ),
    Closet(id: '2', name: 'Work Attire', ownerId: '1', itemIds: ['1', '3']),
    Closet(
      id: '3',
      name: 'Special Occasions',
      ownerId: '1',
      itemIds: ['1', '3'],
    ),
    Closet(id: '4', name: 'Seasonal', ownerId: '1', itemIds: ['2', '3', '4']),
  ];

  // Get current user (simulate logged in user)
  static User getCurrentUser() {
    return users.first;
  }

  // Get user by ID
  static User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get user's closets
  static List<Closet> getUserClosets(String userId) {
    return closets.where((closet) => closet.ownerId == userId).toList();
  }

  // Get user's outfits
  static List<Outfit> getUserOutfits(String userId) {
    return outfits.where((outfit) => outfit.creatorId == userId).toList();
  }

  // Get user's wardrobe items
  static List<WardrobeItem> getUserWardrobeItems(String userId) {
    // In a real app, each item would have an owner
    // For simplicity, just return all items for now
    return wardrobeItems;
  }
}
