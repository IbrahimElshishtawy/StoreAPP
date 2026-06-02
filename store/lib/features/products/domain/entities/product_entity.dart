class ProductEntity {
  final String id;
  final String title;
  final String category;
  final double price;
  final String image;
  final String description;
  final double rating;
  final int ratingCount;
  final bool isPromoted;

  ProductEntity({
    required this.id,
    required this.title,
    required this.category,
    this.price = 0.0,
    this.image = '',
    this.description = '',
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isPromoted = false,
  });

  String get imageUrl => image;
}
