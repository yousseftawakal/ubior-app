class Outfit {
  final String id;
  final String name;
  final String? description;
  final List<String> itemIds; // References to WardrobeItem ids
  final List<String> tags;
  final String? imageUrl;
  final String? occasion;
  final String? season;
  final String creatorId; // Reference to User id
  final DateTime createdAt;

  Outfit({
    required this.id,
    required this.name,
    required this.creatorId,
    this.description,
    this.itemIds = const [],
    this.tags = const [],
    this.imageUrl,
    this.occasion,
    this.season,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create an Outfit from JSON data
  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      itemIds: List<String>.from(json['item_ids'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      imageUrl: json['image_url'],
      occasion: json['occasion'],
      season: json['season'],
      creatorId: json['creator_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Convert Outfit to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'item_ids': itemIds,
      'tags': tags,
      'image_url': imageUrl,
      'occasion': occasion,
      'season': season,
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
