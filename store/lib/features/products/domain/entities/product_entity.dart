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
  final bool hasVr;
  final String? dealTag;
  final double? originalPrice;
  final String arModelUrl;

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
    this.hasVr = false,
    this.dealTag,
    this.originalPrice,
    this.arModelUrl = 'assets/models/product.glb',
  });

  String get imageUrl => image;
}
