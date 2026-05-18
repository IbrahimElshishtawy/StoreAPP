import 'dart:io';
import 'package:store/features/products/domain/entities/product_entity.dart';

abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {}

class AddProductRequested extends SellerEvent {
  final ProductEntity product;
  final File? imageFile;
  AddProductRequested(this.product, {this.imageFile});
}

class UpdateProductRequested extends SellerEvent {
  final ProductEntity product;
  final File? imageFile;
  UpdateProductRequested(this.product, {this.imageFile});
}

class DeleteProductRequested extends SellerEvent {
  final String productId;
  DeleteProductRequested(this.productId);
}
