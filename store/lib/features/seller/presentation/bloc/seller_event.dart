import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {}

class AddProductRequested extends SellerEvent {
  final ProductEntity product;
  AddProductRequested(this.product);
}

class UpdateProductRequested extends SellerEvent {
  final ProductEntity product;
  UpdateProductRequested(this.product);
}

class DeleteProductRequested extends SellerEvent {
  final String productId;
  DeleteProductRequested(this.productId);
}
