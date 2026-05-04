class ProductEntity {
  final String id;
  final String title;
  final String category;
  final double price;
  final String imageUrl;

  ProductEntity({
    required this.id,
    required this.title,
    required this.category,
    this.price = 0.0,
    this.imageUrl = '',
  });
}
