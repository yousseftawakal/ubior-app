enum ClothingCategory {
  tops,
  bottoms,
  dresses,
  outerwear,
  footwear,
  accessories,
}

class WardrobeItem {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final ClothingCategory category;
  final List<String> tags;
  final String? brand;
  final String? color;
  final String? season;

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.imageUrl,
    this.tags = const [],
    this.brand,
    this.color,
    this.season,
  });

  // Create a WardrobeItem from JSON data
  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      category: ClothingCategory.values.byName(json['category']),
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'],
      color: json['color'],
      season: json['season'],
    );
  }

  // Convert WardrobeItem to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'category': category.name,
      'tags': tags,
      'brand': brand,
      'color': color,
      'season': season,
    };
  }
}
