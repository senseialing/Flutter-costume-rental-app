class Costume {
  final String name;
  final String imageUrl;
  final int price;
  final String description;
  final String category;
  final List<String> sizes;
  final String material;
  final String careInstructions;
  final String returnPolicy;
  bool isAvailable;

  Costume({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.sizes,
    required this.material,
    required this.careInstructions,
    required this.returnPolicy,
    this.isAvailable = true,
  });
}
