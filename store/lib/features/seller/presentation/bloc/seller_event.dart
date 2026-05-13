abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {}

class UploadProductRequested extends SellerEvent {
  final String title;
  final String category;
  final double price;
  final String description;
  final String image;
  UploadProductRequested({
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
  });
}

class CreateAdRequested extends SellerEvent {
  final String productId;
  final double budget;
  CreateAdRequested(this.productId, this.budget);
}
