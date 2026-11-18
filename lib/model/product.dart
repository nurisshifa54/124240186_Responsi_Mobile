class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String image;
  final double rating;
  final int ratingCount;

  // fakestoreapi tidak punya data stok, jadi dibuat batas tetap.
  int get stock => 99;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    final rate = jsonData['rating'] ?? {};
    return Product(
      id: jsonData['id'],
      title: jsonData['title'] ?? '',
      description: jsonData['description'] ?? '',
      category: jsonData['category'] ?? '',
      price: (jsonData['price'] ?? 0).toDouble(),
      image: jsonData['image'] ?? '',
      rating: (rate['rate'] ?? 0).toDouble(),
      ratingCount: (rate['count'] ?? 0).toInt(),
    );
  }
}
