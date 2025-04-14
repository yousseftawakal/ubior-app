import '../models/user.dart';
import '../models/outfit.dart';
import '../models/wardrobe_item.dart';
import 'dummy_data.dart';

class SearchService {
  // Simulates search functionality until backend API is available

  // Search for users
  static List<User> searchUsers(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return DummyDataService.users.where((user) {
      return user.displayName.toLowerCase().contains(lowercaseQuery) ||
          user.username.toLowerCase().contains(lowercaseQuery) ||
          (user.bio?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Search for outfits
  static List<Outfit> searchOutfits(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return DummyDataService.outfits.where((outfit) {
      return outfit.name.toLowerCase().contains(lowercaseQuery) ||
          (outfit.description?.toLowerCase().contains(lowercaseQuery) ??
              false) ||
          outfit.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Search for wardrobe items
  static List<WardrobeItem> searchWardrobeItems(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return DummyDataService.wardrobeItems.where((item) {
      return item.name.toLowerCase().contains(lowercaseQuery) ||
          (item.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          item.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
          (item.brand?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (item.color?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (item.season?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Combined search across all entities
  static Map<String, dynamic> search(String query) {
    return {
      'users': searchUsers(query),
      'outfits': searchOutfits(query),
      'wardrobeItems': searchWardrobeItems(query),
    };
  }

  // Get popular search terms (would come from API in real app)
  static List<String> getPopularSearchTerms() {
    return [
      'Summer fashion',
      'Casual style',
      'Office wear',
      'Streetwear',
      'Minimalist',
      'Vintage',
      'Y2K',
      'Sustainable',
    ];
  }
}
