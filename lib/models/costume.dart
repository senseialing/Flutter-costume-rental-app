class Costume {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String size;
  final int price;
  final double rating;
  final int reviewCount;
  bool isAvailable;
  // --- TAMBAHAN ---
  final String category;

  Costume({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.size,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    // --- TAMBAHAN ---
    required this.category,
  });

  factory Costume.fromJson(Map<String, dynamic> json) {
    return Costume(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      size: json['size'],
      price: json['price'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      // --- TAMBAHAN ---
      category: json['category'] ?? 'Baju', // Default 'Baju' jika tidak ada
    );
  }
}