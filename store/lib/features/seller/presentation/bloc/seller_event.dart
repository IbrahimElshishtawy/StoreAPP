import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {}

class AddProductRequested extends SellerEvent {
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  AddProductRequested({
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });
}

class UpdateProductRequested extends SellerEvent {
  final ProductEntity product;
  UpdateProductRequested(this.product);
}

class DeleteProductRequested extends SellerEvent {
  final String productId;
  DeleteProductRequested(this.productId);
}
