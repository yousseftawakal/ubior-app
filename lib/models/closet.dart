class Closet {
  final String id;
  final String name;
  final String? description;
  final List<String> itemIds; // References to WardrobeItem ids
  final String ownerId; // Reference to User id
  final String? imageUrl;

  Closet({
    required this.id,
    required this.name,
    required this.ownerId,
    this.description,
    this.itemIds = const [],
    this.imageUrl,
  });

  // Create a Closet from JSON data
  factory Closet.fromJson(Map<String, dynamic> json) {
    return Closet(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      itemIds: List<String>.from(json['item_ids'] ?? []),
      ownerId: json['owner_id'],
      imageUrl: json['image_url'],
    );
  }

  // Convert Closet to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'item_ids': itemIds,
      'owner_id': ownerId,
      'image_url': imageUrl,
    };
  }
}
