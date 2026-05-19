import 'package:store/features/products/domain/entities/product_entity.dart';
import 'dart:io';

abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {
  final String sellerId;
  GetSellerStatsRequested(this.sellerId);
}

class AddProductRequested extends SellerEvent {
  final ProductEntity product;
  final File? imageFile;
  AddProductRequested(this.product, this.imageFile);
}

class UpdateProductRequested extends SellerEvent {
  final ProductEntity product;
  final File? imageFile;
  UpdateProductRequested(this.product, this.imageFile);
}

class DeleteProductRequested extends SellerEvent {
  final String productId;
  DeleteProductRequested(this.productId);
}

class CreatePromotionRequested extends SellerEvent {
  final String title;
  final String description;
  final DateTime expiryDate;

  CreatePromotionRequested({
    required this.title,
    required this.description,
    required this.expiryDate,
  });
}
